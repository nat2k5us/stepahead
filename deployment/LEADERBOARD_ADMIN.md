# Leaderboard Administration

## Reset Leaderboard

To reset (clear) the leaderboard, run the reset script from the deployment folder:

```bash
cd deployment
./reset-leaderboard.sh
```

### Reset Options:

When you run the script, you'll be asked to choose:

1. **📅 DAILY** - Delete entries from last 24 hours (keeps top 25 all-time leaders)
2. **📆 WEEKLY** - Delete entries from last 7 days (keeps top 25 all-time leaders)
3. **🗑️ ALL** - Delete ALL except top 25 all-time leaders
4. **💀 EVERYTHING** - Delete EVERYTHING (no protection)

### How it works:
- Options 1-3 **protect the top 25 all-time leaders** from deletion
- Daily/Weekly resets only delete entries within the time window AND not in top 25
- "ALL" option keeps only the top 25 highest scores ever
- "EVERYTHING" option requires typing `DELETE_EVERYTHING` (dangerous!)
- Uses Firebase Admin SDK for reliable bulk operations

### Requirements:
- Firebase CLI must be installed: `npm install -g firebase-tools`
- Firebase Admin SDK: `npm install -g firebase-admin`
- You must be logged in to Firebase: `firebase login`
- You need admin access to the Firebase project

### Safety Features:
- Interactive menu to choose reset type
- "EVERYTHING" option requires typing `DELETE_EVERYTHING` (extra protection)
- Other options require typing `RESET` to confirm
- Shows count of documents to delete/keep before deletion
- Top 25 all-time leaders are protected (except in EVERYTHING mode)
- Provides detailed progress during deletion
- Shows summary of deleted/remaining documents

## Leaderboard Time Filters

The app now has three leaderboard views:

1. **📅 Daily** - Shows top scores from the last 24 hours
2. **📆 Weekly** - Shows top scores from the last 7 days
3. **🌍 All Time** - Shows all-time top scores

Users can switch between these views using the buttons at the top of the leaderboard tab.

### How it works:
- All reading sessions are stored with a timestamp
- The app filters entries based on the timestamp when displaying the leaderboard
- Daily: `timestamp > (now - 24 hours)`
- Weekly: `timestamp > (now - 7 days)`
- All Time: Shows all entries

### Notes:
- Filtering is done client-side (in the app)
- Older entries remain in Firebase - they're just filtered from view
- Resetting the leaderboard deletes ALL entries regardless of time filter

## Manual Leaderboard Management

If you need to manually manage leaderboard entries:

### View all entries:
```bash
firebase firestore:export gs://your-bucket/backup
```

### Delete specific entries:
You can use the Firebase Console:
1. Go to https://console.firebase.google.com
2. Select your project: `speechtherapy-fa851`
3. Navigate to Firestore Database
4. Go to `reading_sessions` collection
5. Delete specific documents manually

### Backup before reset:
```bash
# Export to Cloud Storage
firebase firestore:export gs://speechtherapy-fa851.appspot.com/backups/$(date +%Y%m%d)

# Or download locally (requires service account key)
firebase firestore:export ./firestore-backup
```

## Automating Leaderboard Resets

If you want to automatically reset the leaderboard on a schedule (e.g., daily for daily leaderboard):

### Option 1: Cloud Functions (Firebase)
Create a scheduled Cloud Function that runs daily/weekly to clean up old entries.

### Option 2: Cron Job (Local)
Set up a cron job on your local machine or server:

```bash
# Edit crontab
crontab -e

# Add line to reset every Monday at midnight
0 0 * * 1 cd /path/to/deployment && ./reset-leaderboard.sh < echo "RESET"
```

**Note**: This is dangerous as it bypasses confirmation!

## Best Practices

1. **Backup First**: Always export data before resetting
2. **Announce Resets**: Let users know when leaderboards will reset
3. **Consider Time Zones**: Plan resets for low-usage times
4. **Test First**: Test the script on a development project first
5. **Monitor**: Check that the reset completed successfully

## Troubleshooting

### Script fails with "Firebase CLI not found"
```bash
npm install -g firebase-tools
```

### Script fails with "Permission denied"
```bash
chmod +x reset-leaderboard.sh
```

### Script fails with "Not authenticated"
```bash
firebase login
```

### Documents not deleting
- Check Firebase security rules
- Verify you have admin access
- Check your internet connection
- Try deleting manually via Firebase Console
