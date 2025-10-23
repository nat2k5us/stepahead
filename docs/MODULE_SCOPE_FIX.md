# Module Scope Fix - Login Function Accessibility

## Problem

When attempting to login, the app threw this error:

```
⚡️  ReferenceError: Can't find variable: signIn
⚡️  URL: capacitor://localhost
⚡️  localhost:793:7
```

## Root Cause

The HTML button at line 793 uses an inline `onclick` attribute:

```html
<button onclick="signIn()" class="login-button">SIGN IN</button>
```

However, the `signIn` function was defined inside a `<script type="module">` tag (line 2710), which has its own scope and doesn't expose functions to the global `window` object automatically.

**Module scripts have their own scope** - functions defined in them are not accessible from inline HTML event handlers like `onclick`.

## Solution

Added explicit exports to the `window` object for all functions that are called from HTML `onclick` attributes.

### web/index.html:3017-3039

```javascript
// Expose functions to window object for onclick handlers
window.signIn = signIn;
window.signUp = signUp;
window.logout = logout;
window.saveProfile = saveProfile;
window.showSignup = showSignup;
window.showLogin = showLogin;
window.changeTheme = changeTheme;
window.switchTab = switchTab;
window.toggleDebugControls = toggleDebugControls;
window.moveNavbar = moveNavbar;
window.resetNavbar = resetNavbar;
window.showTasksView = showTasksView;
window.showDaysView = showDaysView;
window.showTaskView = showTaskView;
window.addBonusTask = addBonusTask;
window.handleStepComplete = handleStepComplete;
window.prevStep = prevStep;
window.nextStep = nextStep;
window.completeTask = completeTask;
window.renderHistoryTab = renderHistoryTab;
window.showTaskDetails = showTaskDetails;
window.bypassFirebaseLogin = bypassFirebaseLogin;
```

## Files Modified

✅ `/Users/natrajbontha/dev/apps/stepahead/web/index.html`
✅ `/Users/natrajbontha/dev/apps/stepahead/index.html`
✅ `/Users/natrajbontha/dev/apps/stepahead/ios/App/App/public/index.html`

## Functions Exposed to Window

All functions that are called from HTML `onclick` attributes:

### Authentication Functions
- `signIn()` - Sign in with email/password
- `signUp()` - Create new account
- `logout()` - Sign out user
- `saveProfile()` - Update user profile
- `showSignup()` - Switch to signup form
- `showLogin()` - Switch to login form
- `bypassFirebaseLogin()` - Development mode bypass

### Theme Functions
- `changeTheme(themeName)` - Change app color theme

### Navigation Functions
- `switchTab(tabName, element)` - Switch between main tabs
- `showDaysView()` - Show day selector
- `showTasksView(dayNumber)` - Show tasks for a day
- `showTaskView(taskIndex)` - Show individual task

### Task Functions
- `addBonusTask(dayNumber)` - Add bonus task
- `handleStepComplete()` - Complete current step
- `prevStep()` - Go to previous step
- `nextStep()` - Go to next step
- `completeTask()` - Complete entire task

### History Functions
- `renderHistoryTab()` - Show history tab
- `showTaskDetails(taskId)` - Show task detail graph

### Debug Functions
- `toggleDebugControls()` - Show/hide debug panel
- `moveNavbar(direction)` - Move navbar up/down
- `resetNavbar()` - Reset navbar position

## Testing

After this fix:

1. ✅ Login button should work without ReferenceError
2. ✅ Signup button should work
3. ✅ All navigation should work (tabs, tasks, days)
4. ✅ Theme switching should work
5. ✅ Task completion should work
6. ✅ History tab should work
7. ✅ Logout should work

## Why This Works

By assigning the functions to the `window` object:

```javascript
window.signIn = signIn;
```

We make the function accessible globally, which allows the HTML `onclick` attribute to find it:

```html
<button onclick="signIn()">  <!-- This can now find window.signIn -->
```

## Alternative Approaches (Not Used)

**Option 1: Remove `type="module"`**
- Would lose ES6 module benefits
- Would pollute global scope automatically
- Not recommended for modern code

**Option 2: Use addEventListener**
- Would require changing all onclick handlers
- More verbose for simple cases
- Better for complex interactions

**Option 3: Keep both approaches**
- Use modules for organization
- Expose only what's needed to window
- ✅ **This is what we did**

## Next Steps

Now that the login works, the next issue to address is:

1. **Enable Cloud Firestore API** in Firebase Console
   - URL: https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=stepahead-519b0
   - This will allow the History tab to save/read task completions

2. **Run Firestore Security Rules Fix**
   ```bash
   ./deployment/fix-task-history-rules.sh
   ```

3. **Test the full flow**:
   - Login → Select Today → Complete Task → View History

## Reference

- **Module Scope**: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules
- **Window Object**: https://developer.mozilla.org/en-US/docs/Web/API/Window
- **Event Handlers**: https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Event_handlers
