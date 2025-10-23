# Theme Persistence Fix - User-Specific Themes

## Problem

When switching between users, the color theme selected by one user was carried over to the second user, even though both users had selected different themes.

## Root Cause

The theme preference was being stored in browser `localStorage`, which is **global** and persists across all user sessions:

```javascript
// Old approach - global storage
localStorage.setItem('appTheme', themeName);
```

This caused:
- Theme persists when switching users
- User A's theme shows for User B
- No user-specific theme preferences
- Confusing user experience

## Solution

Changed theme storage to be **user-specific** by storing it in Firestore under each user's profile document.

## What Changed

### 1. Updated `changeTheme()` Function

**Before:**
```javascript
function changeTheme(themeName) {
    // ... theme application logic ...

    // Save to localStorage (global)
    localStorage.setItem('appTheme', themeName);
}
```

**After:**
```javascript
async function changeTheme(themeName) {
    // ... theme application logic ...

    // Save theme to Firestore per user (not localStorage)
    if (auth.currentUser) {
        try {
            await setDoc(doc(db, 'users', auth.currentUser.uid), {
                theme: themeName
            }, { merge: true });
            console.log('🎨 Theme saved to Firestore:', themeName);
        } catch (error) {
            console.warn('⚠️  Could not save theme to Firestore:', error.message);
            // Fallback to localStorage if Firestore fails
            localStorage.setItem('appTheme', themeName);
        }
    } else {
        // Not logged in, use localStorage as fallback
        localStorage.setItem('appTheme', themeName);
    }
}
```

**Key improvements:**
- Made function `async` to support Firestore writes
- Saves theme to `users/{uid}` document with `{ merge: true }` (preserves other fields)
- Falls back to localStorage if Firestore fails or user not logged in
- Proper error handling with console warnings

### 2. Load Theme on Login

Added theme loading in `onAuthStateChanged` listener:

```javascript
onAuthStateChanged(auth, async (user) => {
    if (user) {
        // ... existing profile loading code ...

        let userTheme = 'theme-default'; // Default theme

        try {
            const userDoc = await getDoc(doc(db, 'users', user.uid));
            if (userDoc.exists()) {
                const userData = userDoc.data();
                userName = userData.displayName || userName;
                userTheme = userData.theme || 'theme-default';  // ← Load theme
                console.log('✅ Loaded user profile from Firestore');
            }
        } catch (firestoreError) {
            // Continue with fallback
        }

        // Load user's theme preference
        changeTheme(userTheme);
        console.log('🎨 Loaded user theme:', userTheme);
    }
});
```

**What this does:**
- Loads user's theme from Firestore on login
- Applies their saved theme immediately
- Falls back to `theme-default` if no theme saved
- Each user sees their own theme preference

### 3. Clear Theme on Logout

Updated `logout()` function to reset theme:

```javascript
async function logout() {
    if (confirm('Are you sure you want to logout?')) {
        try {
            await window.signOut(window.auth);

            // ... existing logout code ...

            // Reset theme to default and clear localStorage
            localStorage.removeItem('appTheme');
            changeTheme('theme-default');
            console.log('🎨 Theme reset to default on logout');
        } catch (error) {
            alert('Error signing out: ' + error.message);
        }
    }
}
```

**What this does:**
- Removes any theme from localStorage
- Resets to default theme
- Ensures clean state for next user
- Prevents theme leakage between users

## Files Modified

- ✅ `web/index.html` - Updated changeTheme(), onAuthStateChanged, logout()
- ✅ `index.html` - Synced from web/index.html
- ✅ `ios/App/App/public/index.html` - Synced from web/index.html

## How It Works Now

### User Flow:

**User A logs in:**
1. Selects "Ocean" theme in Settings
2. Theme saved to Firestore: `users/{userA_uid}/theme = "theme-ocean"`
3. Ocean theme applied to UI

**User A logs out:**
1. Logout function clears theme
2. UI resets to default theme
3. Login screen shows default theme

**User B logs in:**
1. Their theme loaded from Firestore: `users/{userB_uid}/theme = "theme-forest"`
2. Forest theme applied to UI
3. User B sees their own theme preference

**User A logs in again:**
1. Their Ocean theme loaded from Firestore
2. Ocean theme applied
3. User A sees their saved preference

### Technical Flow:

```
Login → Load theme from Firestore → Apply user's theme
  ↓
Change theme → Save to Firestore (per user)
  ↓
Logout → Reset to default → Clear localStorage
```

## Firestore Data Structure

Each user's theme is stored in their profile document:

```javascript
// Firestore: users collection
{
  "users": {
    "{user_uid}": {
      "displayName": "Voidydude",
      "email": "voidydude@gmail.com",
      "theme": "theme-ocean"  // ← User-specific theme
    }
  }
}
```

The `{ merge: true }` option ensures we don't overwrite other fields when saving the theme.

## Benefits

1. **User-specific themes** - Each user has their own theme preference
2. **Cross-device sync** - User's theme syncs across devices via Firestore
3. **Persistent** - Theme preference survives app restarts
4. **Isolated** - No theme leakage between users
5. **Fallback support** - Works even if Firestore fails (uses localStorage)

## Testing

To verify the fix:

1. **Login as User A:**
   - Email: `voidydude@gmail.com`
   - Select "Ocean" theme in Settings
   - Logout

2. **Login as User B:**
   - Email: `test@example.com`
   - Select "Forest" theme in Settings
   - Logout

3. **Login as User A again:**
   - Should see Ocean theme (not Forest)
   - Theme should be persisted from first login

4. **Login as User B again:**
   - Should see Forest theme (not Ocean)
   - Each user has their own preference

## Console Logs

You should see these logs when testing:

**On login:**
```
🔔 Auth state changed, user: voidydude@gmail.com
✅ Loaded user profile from Firestore
🎨 Loaded user theme: theme-ocean
```

**On theme change:**
```
🎨 Theme saved to Firestore: theme-ocean
🎨 Theme changed to: theme-ocean
```

**On logout:**
```
🎨 Theme reset to default on logout
👋 User signed out
```

## Known Limitations

1. **Requires Firestore access** - If Firestore security rules block writes, theme won't save
2. **Network dependent** - Theme save requires network connection
3. **Fallback to localStorage** - If Firestore fails, uses global localStorage as fallback

## Next Steps

If you want to extend this pattern to other settings:

1. **Notifications preference** - Save to Firestore per user
2. **Dark mode preference** - Save to Firestore per user
3. **Other settings** - Follow the same pattern

Example:
```javascript
// Save notification preference
await setDoc(doc(db, 'users', auth.currentUser.uid), {
    notificationsEnabled: enabled
}, { merge: true });

// Load on login
const notifEnabled = userData.notificationsEnabled || false;
```

## Related Issues

This fix also prevents:
- Theme confusion when using shared devices
- Unexpected theme changes when switching accounts
- Poor UX for multi-user scenarios

## Current Status

✅ Theme saved to Firestore per user
✅ Theme loaded on login
✅ Theme cleared on logout
✅ Each user has isolated theme preference
✅ No more theme leakage between users

The theme system is now fully user-specific and works correctly in multi-user scenarios!
