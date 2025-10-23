# Logout Button Fix

## Problem

The logout button was not navigating users back to the sign-in page after logout.

## Root Cause

The logout function was calling `signOut()` which successfully logged out the user from Firebase Auth, but wasn't explicitly handling the UI transition back to the login screen.

While the `onAuthStateChanged` listener SHOULD automatically handle this, there was a timing or state management issue causing the UI to not update properly.

## Solution

Updated the `logout()` function to explicitly handle the UI transition:

### Before:
```javascript
async function logout() {
    if (confirm('Are you sure you want to logout?')) {
        try {
            await window.signOut(window.auth);
        } catch (error) {
            alert('Error signing out: ' + error.message);
        }
    }
}
```

### After:
```javascript
async function logout() {
    if (confirm('Are you sure you want to logout?')) {
        try {
            await window.signOut(window.auth);

            // Explicitly navigate back to login screen
            document.getElementById('loginScreen').classList.remove('hidden');
            document.getElementById('mainAppContainer').classList.add('hidden');
            document.body.classList.remove('app-active');

            // Clear any form data
            document.getElementById('profileName').value = '';
            document.getElementById('profileEmail').value = '';
            document.getElementById('userName').textContent = '';
        } catch (error) {
            alert('Error signing out: ' + error.message);
        }
    }
}
```

## What Changed

1. **Show login screen:** Removes 'hidden' class from loginScreen
2. **Hide main app:** Adds 'hidden' class to mainAppContainer
3. **Remove app-active class:** Cleans up body classes
4. **Clear form data:** Removes any residual user data from profile fields

## Files Modified

- ✅ `web/index.html` - Updated logout function
- ✅ `index.html` - Updated logout function (root)
- ✅ `ios/App/App/public/index.html` - Synced via sync-web-to-ios.sh

## Testing

To verify the fix:

1. **Login** to the app
2. Navigate to **Profile** tab
3. Click **Logout** button
4. Confirm the logout in the dialog
5. **Verify:** You should be taken back to the login screen

## Related Components

- **Login Screen:** `#loginScreen` element
- **Main App:** `#mainAppContainer` element
- **Auth State Listener:** `onAuthStateChanged()` - Still handles automatic state changes
- **Logout Button:** Located in Profile tab

## Why Explicit UI Handling Was Needed

The Firebase `onAuthStateChanged` listener should automatically detect when a user signs out and update the UI accordingly. However, in some cases:

1. **Timing issues:** The UI might not update immediately
2. **State conflicts:** Other parts of the app might interfere with the listener
3. **Browser caching:** The DOM might not reflect the auth state change immediately

By explicitly handling the UI transition in the logout function, we ensure:
- ✅ Immediate UI response
- ✅ Consistent behavior across all browsers
- ✅ Clear user feedback
- ✅ Proper cleanup of user data

## Best Practice

This is actually a **better pattern** than relying solely on the auth state listener for logout:

```javascript
// Good: Explicit UI handling
await signOut(auth);
showLoginScreen();
clearUserData();

// OK but less reliable: Relying only on listener
await signOut(auth);
// Wait for onAuthStateChanged to fire...
```

The explicit approach ensures deterministic behavior and better user experience.
