# Firebase Setup & Troubleshooting Guide

## Overview

This Speech Reading Trainer app uses Firebase Firestore for cloud data storage. This guide helps you troubleshoot common Firebase issues.

## Firebase Configuration

The app is currently configured to use:
- **Project ID**: `speechtherapy-fa851`
- **Collections**:
  - `reading_sessions` - Stores completed reading sessions for leaderboard
  - `stories` - Stores custom user stories

## Troubleshooting Leaderboard Issues

### 1. Check Browser Console

Open your browser's Developer Tools (F12) and check the Console tab for error messages. The app now provides detailed error logging:

- `🔄 Fetching leaderboard from Firestore...` - Query is starting
- `📊 Fetched X leaderboard entries` - Success
- `❌ Error fetching leaderboard` - Something went wrong

### 2. Common Errors & Solutions

#### Error: "Missing or insufficient permissions"

**Problem**: Firestore security rules are blocking access

**Solution**: Update Firestore rules in Firebase Console:
1. Go to https://console.firebase.google.com/
2. Select project: `speechtherapy-fa851`
3. Navigate to **Firestore Database** → **Rules**
4. For development, use open rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ Important**: For production, implement proper authentication-based rules.

#### Error: "The query requires an index"

**Problem**: Firestore needs a composite index for the orderBy query

**Solution**:
1. Check the error message in console - it usually includes a direct link to create the index
2. Or manually go to: Firebase Console → Firestore → **Indexes** tab
3. Click "Create Index" with these settings:
   - Collection ID: `reading_sessions`
   - Fields to index:
     - `score` - Descending
   - Query scope: Collection

The index typically takes 1-2 minutes to build.

#### Error: "No results yet. Start reading to appear here!"

**Problem**: The `reading_sessions` collection is empty

**Solution**:
1. Complete at least one reading session in the Training tab
2. Or use the `addSampleData()` function:
   - Open browser console (F12)
   - Type: `addSampleData()`
   - Press Enter
   - Check the leaderboard again

### 3. Verify Firebase Connection

Check if you're online and Firebase is accessible:

```javascript
// In browser console
console.log("Online status:", navigator.onLine);
```

The app automatically handles offline status and will show:
```
📡 Offline - Cannot load leaderboard. Check your connection.
```

### 4. Check Data Structure

Reading sessions must have this structure:
```javascript
{
  date: "1/15/2025",
  time: "10:30:45 AM",
  user: "Username",
  story: "Story text preview...",
  wordsRead: 100,
  speed: 60,
  avgVolume: 35,
  pauses: 5,
  score: 85,
  result: "Excellent",
  timestamp: 1642248645000
}
```

Verify your data in Firebase Console:
1. Go to Firestore → Data
2. Open `reading_sessions` collection
3. Check if documents have all required fields, especially `score`

## Testing the Leaderboard

### Desktop View
1. Click the "🏆 Leaderboard" tab
2. Check browser console for log messages
3. Leaderboard should display as a table

### Mobile View
1. Resize browser to mobile size (< 768px width) or use mobile device
2. Tap the "🏆 Leaderboard" button in bottom navigation
3. Leaderboard should display as card list

## Manual Testing Functions

Open browser console and try these:

```javascript
// Test fetching leaderboard
fetchLeaderboard()

// Add sample data
addSampleData()

// Check current user
console.log("Current user:", currentUser)

// Check online status
console.log("Online:", isOnline)
```

## Firebase Console Links

- **Main Console**: https://console.firebase.google.com/project/speechtherapy-fa851
- **Firestore Database**: https://console.firebase.google.com/project/speechtherapy-fa851/firestore
- **Firestore Rules**: https://console.firebase.google.com/project/speechtherapy-fa851/firestore/rules
- **Firestore Indexes**: https://console.firebase.google.com/project/speechtherapy-fa851/firestore/indexes

## Real-Time Updates

The app uses Firebase real-time listeners (`onSnapshot`) for automatic updates:
- When someone completes a reading session, the leaderboard updates automatically
- No page refresh needed
- Works on both desktop and mobile views

## Need More Help?

1. Check the browser console for detailed error messages
2. Verify Firebase project is active and not suspended
3. Ensure you have internet connectivity
4. Try clearing browser cache and reloading
5. Test with sample data using `addSampleData()`

## Recent Fixes (2025-01)

- ✅ Fixed mobile leaderboard not updating (was only updating desktop view)
- ✅ Added detailed error logging for Firebase issues
- ✅ Added automatic detection of index and permission errors
- ✅ Improved offline handling with better user messages
