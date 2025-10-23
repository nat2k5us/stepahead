# Leaderboard Reset Instructions

The reset script is having authentication issues. Here's the **simplest solution**:

## Option 1: Temporary Security Rule Change (EASIEST)

1. **Open Firebase Console**:
   - Go to: https://console.firebase.google.com/project/speechtherapy-fa851/firestore/rules

2. **Temporarily allow deletes** (change for 5 minutes only):
   ```javascript
   rules_version = '2';

   service cloud.firestore {
     match /databases/{database}/documents {
       match /reading_sessions/{document=**} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update, delete: if true;  // ← TEMPORARY! Change back after reset!
       }
     }
   }
   ```

3. **Publish the rules** (click "Publish")

4. **Run the reset script**:
   ```bash
   ./deployment/reset-leaderboard.sh
   ```

5. **IMMEDIATELY change the rules back**:
   ```javascript
   rules_version = '2';

   service cloud.firestore {
     match /databases/{database}/documents {
       match /reading_sessions/{document=**} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update, delete: if request.auth != null;  // ← SECURE!
       }
     }
   }
   ```

6. **Publish again**

---

## Option 2: Use Firebase Console (MANUAL)

1. Go to: https://console.firebase.google.com/project/speechtherapy-fa851/firestore/data/reading_sessions
2. Click the three dots menu ⋮
3. Select "Delete collection"
4. Confirm

**Note**: This is manual but works immediately with no auth issues.

---

## Option 3: Service Account (COMPLEX)

If you want a permanent automated solution:

1. **Create service account**:
   - Go to: https://console.firebase.google.com/project/speechtherapy-fa851/settings/serviceaccounts/adminsdk
   - Click "Generate new private key"
   - Download the JSON file

2. **Save it**:
   ```bash
   mv ~/Downloads/speechtherapy-*.json ~/.firebase/speechtherapy-service-account.json
   chmod 600 ~/.firebase/speechtherapy-service-account.json
   ```

3. **Install Firebase Admin SDK** (one-time):
   ```bash
   cd deployment
   npm install firebase-admin
   ```

4. **Run the script**

---

## Why is this happening?

Your Firestore security rules require `request.auth != null` for deletes, which means:
- ✅ Authenticated app users can delete their own entries
- ❌ Unauthenticated REST API calls are blocked (including admin scripts)

The script needs either:
1. A temporary rule change (easiest)
2. Manual deletion via console (simplest)
3. Service account credentials (most secure/permanent)

**Recommendation**: Use Option 1 for now (5-minute rule change), then Option 3 for permanent solution.
