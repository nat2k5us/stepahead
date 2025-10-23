# User Created in Auth But Not in Firestore - SOLUTION

## Problem

You successfully logged in with `voidydude@gmail.com`, but the user doesn't appear in Firestore.

### What We Found:
- ✅ User exists in **Firebase Authentication** (nat2k5us@gmail.com)
- ❌ NO users exist in **Firestore database**
- ✅ Code DOES attempt to save to Firestore after signup
- ❌ Firestore write is FAILING SILENTLY

## Root Cause

Your **Firestore Security Rules** are likely blocking writes from the client.

## Solution

### Step 1: Check Your Current Firestore Rules

Open this URL:
```
https://console.firebase.google.com/project/stepahead-519b0/firestore/rules
```

### Step 2: Identify the Problem

You probably have one of these BLOCKING rules:

#### ❌ PROBLEM: Rules blocking authenticated users
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false; // Blocks everything!
    }
  }
}
```

#### ❌ PROBLEM: Test mode expired
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      // This expires and then blocks everything
      allow read, write: if request.time < timestamp.date(2024, 10, 22);
    }
  }
}
```

### Step 3: Fix with Production-Ready Rules

Replace your current rules with these:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to create and read/write their own user document
    match /users/{userId} {
      // Allow user creation during signup (authenticated users can create their own doc)
      allow create: if request.auth != null && request.auth.uid == userId;

      // Allow users to read/write their own data
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
    }

    // Tasks belong to users
    match /tasks/{taskId} {
      // Anyone authenticated can create a task
      allow create: if request.auth != null;

      // Only the owner can read/update/delete their tasks
      allow read, update, delete: if request.auth != null
                                  && resource.data.userId == request.auth.uid;
    }
  }
}
```

### Step 4: Click "Publish" to Save

After pasting the new rules, click the **"Publish"** button in Firebase Console.

### Step 5: Test Again

1. **Sign out** from your app
2. **Sign up** with a NEW account (e.g., testuser2@gmail.com)
3. **Check Firestore**:
   ```bash
   node deployment/check-firestore-users.js
   ```

You should now see the user in Firestore!

## Why This Happened

During your Firebase connection test, you likely created the Firestore database with default rules that:
1. Started in "test mode" (allow all)
2. Had an expiration date
3. Or were set to block all writes

When you signed up users BEFORE fixing the rules, they were created in **Firebase Auth** (which has different permissions) but failed to write to **Firestore** (which was blocked).

## Quick Verification

Run this to check users:
```bash
# Check Firebase Authentication (should show users)
firebase auth:export /tmp/users.json --project stepahead-519b0
cat /tmp/users.json

# Check Firestore (currently empty, should have users after fix)
node deployment/check-firestore-users.js
```

## After Fixing

Once you update the rules:
1. New signups will create Firestore documents ✅
2. Existing auth users (nat2k5us@gmail.com) won't have Firestore docs
3. Those users can either:
   - Re-signup with a different email
   - Or have their profile data created when they first update their profile

## Understanding the Flow

### Normal Signup Flow:
```
1. User enters email/password
2. createUserWithEmailAndPassword() → Firebase Auth ✅
3. setDoc() → Firestore users/{uid} ✅ (if rules allow)
4. User can now use the app
```

### What Was Happening (Broken):
```
1. User enters email/password
2. createUserWithEmailAndPassword() → Firebase Auth ✅
3. setDoc() → Firestore users/{uid} ❌ (blocked by rules, fails silently)
4. User appears logged in but has no Firestore data
```

## Check Rules Are Working

After updating rules, you can test them in Firebase Console:
```
https://console.firebase.google.com/project/stepahead-519b0/firestore/rules
```

Click "Rules Playground" to simulate operations.

## Related Files

- Signup code: `web/index.html` (line ~2100)
- Firestore check: `deployment/check-firestore-users.js`
- Firebase config: `web/index.html` (Firebase config section)
