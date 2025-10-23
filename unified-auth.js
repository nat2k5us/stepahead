// ============================================================================
// Unified Username/Password Authentication for StepAhead
// ============================================================================
// This provides a single-form login experience:
// - User enters username + password
// - System automatically logs in if user exists
// - System automatically registers if user is new
// - No email required (generates username@stepahead.app internally)
// ============================================================================

import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword,
         updateProfile, sendPasswordResetEmail } from 'firebase/auth';
import { getFirestore, doc, setDoc, getDoc } from 'firebase/firestore';

// ============================================================================
// Configuration
// ============================================================================

const AUTH_DOMAIN = 'stepahead.app'; // Domain used for generated emails

// ============================================================================
// Helper: Convert username to email
// ============================================================================

function usernameToEmail(username) {
    // Clean username (remove spaces, lowercase)
    const cleanUsername = username.trim().toLowerCase().replace(/\s+/g, '');

    // Validate username
    if (!cleanUsername || cleanUsername.length < 3) {
        throw new Error('Username must be at least 3 characters');
    }

    if (!/^[a-z0-9_]+$/.test(cleanUsername)) {
        throw new Error('Username can only contain letters, numbers, and underscores');
    }

    return `${cleanUsername}@${AUTH_DOMAIN}`;
}

// ============================================================================
// Unified Sign In / Sign Up
// ============================================================================

async function unifiedAuth(username, password) {
    const auth = getAuth();
    const db = getFirestore();

    // Validate inputs
    if (!username || !password) {
        throw new Error('Please enter username and password');
    }

    if (password.length < 6) {
        throw new Error('Password must be at least 6 characters');
    }

    // Convert username to email
    const email = usernameToEmail(username);

    try {
        // Try to sign in first
        console.log(`🔑 Attempting login for: ${username}`);
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        console.log(`✅ Login successful for: ${username}`);
        return {
            user: userCredential.user,
            isNewUser: false,
            username: username
        };

    } catch (signInError) {
        // If user doesn't exist, try to create account
        if (signInError.code === 'auth/user-not-found' ||
            signInError.code === 'auth/invalid-credential') {

            try {
                console.log(`👤 User not found, creating new account for: ${username}`);

                // Create new user
                const userCredential = await createUserWithEmailAndPassword(auth, email, password);

                // Set display name
                await updateProfile(userCredential.user, {
                    displayName: username
                });

                // Save user data to Firestore
                await setDoc(doc(db, 'users', userCredential.user.uid), {
                    username: username,
                    email: email, // Generated email
                    displayName: username,
                    createdAt: new Date().toISOString(),
                    lastLogin: new Date().toISOString()
                });

                console.log(`✅ Account created and logged in for: ${username}`);
                return {
                    user: userCredential.user,
                    isNewUser: true,
                    username: username
                };

            } catch (createError) {
                // Handle account creation errors
                if (createError.code === 'auth/email-already-in-use') {
                    throw new Error('Username already taken');
                } else if (createError.code === 'auth/weak-password') {
                    throw new Error('Password is too weak. Use at least 6 characters.');
                } else {
                    throw new Error(`Registration failed: ${createError.message}`);
                }
            }
        } else if (signInError.code === 'auth/wrong-password') {
            throw new Error('Incorrect password');
        } else {
            throw new Error(`Login failed: ${signInError.message}`);
        }
    }
}

// ============================================================================
// Password Reset (Admin/Console Only for Username System)
// ============================================================================

async function resetPasswordForUsername(username) {
    const auth = getAuth();
    const email = usernameToEmail(username);

    try {
        // This will send email to username@stepahead.app
        // Which won't work unless you have email forwarding set up
        await sendPasswordResetEmail(auth, email);
        console.log(`Password reset email sent to ${email}`);
        return true;
    } catch (error) {
        console.error('Password reset error:', error);
        throw new Error('Password reset not available. Contact support.');
    }
}

// ============================================================================
// Check if Username is Available
// ============================================================================

async function isUsernameAvailable(username) {
    const auth = getAuth();
    const email = usernameToEmail(username);

    try {
        // Try to fetch sign-in methods for this email
        const signInMethods = await fetchSignInMethodsForEmail(auth, email);
        return signInMethods.length === 0; // Available if no sign-in methods
    } catch (error) {
        // If error, assume available
        return true;
    }
}

// ============================================================================
// Update Last Login Time
// ============================================================================

async function updateLastLogin(userId) {
    const db = getFirestore();
    try {
        await setDoc(doc(db, 'users', userId), {
            lastLogin: new Date().toISOString()
        }, { merge: true });
    } catch (error) {
        console.error('Failed to update last login:', error);
    }
}

// ============================================================================
// Export Functions
// ============================================================================

export {
    unifiedAuth,
    usernameToEmail,
    resetPasswordForUsername,
    isUsernameAvailable,
    updateLastLogin
};

// ============================================================================
// Usage Example
// ============================================================================

/*

// In your HTML/JavaScript:

import { unifiedAuth } from './unified-auth.js';

async function handleLogin() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    try {
        const result = await unifiedAuth(username, password);

        if (result.isNewUser) {
            console.log('Welcome! Your account has been created.');
            showMessage('Account created! Welcome to StepAhead!');
        } else {
            console.log('Welcome back!');
            showMessage(`Welcome back, ${result.username}!`);
        }

        // Update last login
        await updateLastLogin(result.user.uid);

        // Show main app
        showMainApp(result.user);

    } catch (error) {
        showError(error.message);
    }
}

// For password reset (admin only):
async function handlePasswordReset() {
    const username = prompt('Enter username to reset password:');
    try {
        await resetPasswordForUsername(username);
        alert('Password reset email sent (if email forwarding is configured)');
    } catch (error) {
        alert(error.message);
    }
}

*/

// ============================================================================
// HTML Example
// ============================================================================

/*

<!-- Simple single-form login -->
<div class="login-container">
    <h1>StepAhead</h1>
    <input type="text" id="username" placeholder="Username" />
    <input type="password" id="password" placeholder="Password" />
    <button onclick="handleLogin()">Sign In / Sign Up</button>
    <p class="help-text">
        Enter your username and password.
        New users will be registered automatically!
    </p>
</div>

*/
