# Firebase Test with Task History Data

## Overview

The Firebase test script (`deployment/test-firebase-connection.sh`) has been updated to create sample task history data for testing the History tab and performance tracking features.

## What It Does

When you run the Firebase test, it now:

1. ✅ Creates a test user
2. ✅ Writes user profile to Firestore
3. ✅ **Creates 3 sample task completions** (NEW!)
4. ✅ Reads from Firestore to verify
5. ✅ Tests sign in
6. ✅ Cleans up test data

## Sample Task Data Created

The script creates 3 task completion records:

### Task 1: Make Your Bed
```javascript
{
  taskName: "Make Your Bed",
  taskIcon: "🛏️",
  dayOfWeek: 1, // Monday
  stepTimes: [28.5, 19.2, 14.8, 9.5], // Actual seconds per step
  estimatedTimes: [30, 20, 15, 10],   // Expected seconds per step
  totalTime: 72.0,
  estimatedTotal: 75,
  totalScore: 95,
  completedAt: "2025-10-22T...",
  timestamp: Firestore.Timestamp,
  userId: "test_user_uid",
  userEmail: "test@stepahead.app"
}
```

**Score: 95/100** - Almost perfect timing!

### Task 2: Wash Your Breakfast Dishes
```javascript
{
  taskName: "Wash Your Breakfast Dishes",
  taskIcon: "🍽️",
  dayOfWeek: 1,
  stepTimes: [18.2, 9.5, 14.1, 55.3, 28.7, 19.2],
  estimatedTimes: [20, 10, 15, 60, 30, 20],
  totalTime: 145.0,
  estimatedTotal: 155,
  totalScore: 98,
  ...
}
```

**Score: 98/100** - Excellent performance!

### Task 3: Water One Plant
```javascript
{
  taskName: "Water One Plant",
  taskIcon: "🌱",
  dayOfWeek: 1,
  stepTimes: [14.2, 28.5, 18.9, 29.1, 9.3],
  estimatedTimes: [15, 30, 20, 30, 10],
  totalTime: 100.0,
  estimatedTotal: 105,
  totalScore: 97,
  ...
}
```

**Score: 97/100** - Great job!

## Running the Test

```bash
cd /Users/natrajbontha/dev/apps/stepahead
./deployment/test-firebase-connection.sh
```

**Output:**
```
🔥 Firebase Connection Test
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test Configuration:
  Username: test_1729612345
  Email:    test_1729612345@stepahead.app

Running Firebase test...

📡 Initializing Firebase...
👤 Creating test user...
✅ User created: abc123xyz...
📝 Writing to Firestore...
✅ Firestore write successful
📖 Reading from Firestore...
✅ Firestore read successful: username=test_1729612345
📊 Creating test task history...
  ✅ 🛏️ Make Your Bed (95/100)
  ✅ 🍽️ Wash Your Breakfast Dishes (98/100)
  ✅ 🌱 Water One Plant (97/100)
✅ Test task history created (3 tasks)
🔄 Testing sign in...
✅ Sign in successful: abc123xyz...
🧹 Cleaning up test user...
✅ Firestore document deleted
✅ Authentication user deleted

✅ Firebase connection test PASSED

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Firebase is properly configured and working!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## What Gets Created in Firestore

**Firestore Structure:**
```
users/
  {test_user_uid}/
    - username: "test_1729612345"
    - email: "test_1729612345@stepahead.app"
    - createdAt: "2025-10-22T10:30:00Z"
    - testUser: true

    taskHistory/
      {timestamp}_1_Make_Your_Bed
        - taskName: "Make Your Bed"
        - taskIcon: "🛏️"
        - stepTimes: [28.5, 19.2, 14.8, 9.5]
        - totalScore: 95
        - ...

      {timestamp}_1_Wash_Your_Breakfast_Dishes
        - taskName: "Wash Your Breakfast Dishes"
        - taskIcon: "🍽️"
        - stepTimes: [18.2, 9.5, 14.1, 55.3, 28.7, 19.2]
        - totalScore: 98
        - ...

      {timestamp}_1_Water_One_Plant
        - taskName: "Water One Plant"
        - taskIcon: "🌱"
        - stepTimes: [14.2, 28.5, 18.9, 29.1, 9.3]
        - totalScore: 97
        - ...
```

## Why This Is Useful

**1. Testing History Tab:**
- Verifies Firestore reads work
- Tests task grouping logic
- Validates score calculations
- Checks timestamp handling

**2. Testing Graph Display:**
- Multiple tasks to group
- Different step counts (4, 6, 5 steps)
- Various scores to compare
- Real timing data

**3. Verifying Permissions:**
- Tests read access to taskHistory
- Tests write access to taskHistory
- Ensures user isolation (uid-based paths)

**4. Development:**
- Quick way to populate test data
- No need to manually complete tasks
- Consistent test data across runs

## Cleanup

**Automatic Cleanup:**
The script automatically deletes:
- ✅ Test user from Authentication
- ✅ User profile document
- ✅ **Task history documents** (subcollection)

**Note:** Test data is temporary and cleaned up immediately after the test completes.

## For Real User Testing

If you want to create task history for a **real user** (not deleted after test):

1. **Complete tasks in the app** normally
2. Or use the separate script:
   ```bash
   node deployment/create-test-task-data.js voidydude@gmail.com password123
   ```

The test script creates temporary data for testing, the separate script creates permanent data for real users.

## Troubleshooting

### Error: Permission Denied

```
❌ Firestore error: Missing or insufficient permissions
```

**Fix:**
```bash
./deployment/fix-task-history-rules.sh
```

This updates Firestore security rules to allow users to read/write their own task history.

### Task History Not Showing in App

**Possible causes:**
1. Firestore rules blocking reads
2. User not logged in
3. No task history created yet

**Check:**
1. Run `./deployment/fix-task-history-rules.sh`
2. Log in to the app
3. Run Firebase test to create sample data

### Test User Not Cleaned Up

If the test fails mid-way, the test user might remain in Authentication.

**Manual cleanup:**
1. Go to: https://console.firebase.google.com/project/stepahead-519b0/authentication/users
2. Find users with email like `test_*@stepahead.app`
3. Delete them manually

## What's Next

After running this test successfully:

1. ✅ Firebase Authentication working
2. ✅ Firestore read/write working
3. ✅ Task history structure validated
4. ✅ Sample data created for testing

**Now you can:**
- Open the app
- Complete actual tasks
- View history in History tab
- See graphs of performance
- Add bonus tasks

## Files Modified

- ✅ `deployment/test-firebase-connection.sh` - Added task history creation

## Summary

The Firebase test now creates **realistic task completion data** with:
- Multiple tasks
- Different step counts
- Actual timing data
- Calculated scores
- Proper timestamps

This makes it easy to test the History tab and verify that all the performance tracking features work correctly! 🎉
