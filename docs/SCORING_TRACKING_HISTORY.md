# Task Scoring, Tracking, and History System

## Overview

Implemented a comprehensive task performance tracking system with:
- **Negative timer countdown** - Timers continue into negative time to track overtime
- **Scoring system** - Tasks scored 0-100 based on time performance
- **Firestore audit trail** - All task completions saved with detailed metrics
- **Day names** - 7 days renamed to Monday-Sunday
- **History tab** - Renamed from "Explore", shows task completion history
- **Grouped history view** - Shows tasks with completion counts (x2, x3, etc.)
- **Multi-line graphs** - Visual comparison of multiple task attempts

## Features Implemented

### 1. Negative Timer Countdown

**Previous Behavior:**
- Timer stopped at 0:00
- User couldn't see how much overtime they took

**New Behavior:**
- Timer continues counting: 0:00 → -0:01 → -0:02 → -0:30
- Visual state changes:
  - **Normal:** Black text (plenty of time)
  - **Warning:** Red pulsing (< 10 seconds)
  - **Overtime:** Dark red, faster pulse (negative time)

**Code:**
```javascript
// Timer now goes negative
stepTimer = setInterval(() => {
    timeRemaining--;
    updateTimerDisplay();

    if (timeRemaining === 0) {
        speak("Time is up! Keep going, say done or next when ready.");
    }
    // Continues counting - doesn't stop
}, 1000);
```

**Display:**
```javascript
const sign = timeRemaining < 0 ? '-' : '';
timerElement.textContent = `${sign}${minutes}:${seconds}`;
```

### 2. Scoring System

**How Scoring Works:**
- Start with **100 points** (perfect score)
- **Penalty for overtime:** 0.5 points per second over estimated time
- **Max penalty per step:** 15 points
- **Minimum score:** 0 (can't go negative)

**Example:**
```
Task: Make Your Bed (4 steps)

Step 1: Estimated 30s, Actual 35s → Overtime 5s → Penalty 2.5 points
Step 2: Estimated 20s, Actual 18s → No penalty
Step 3: Estimated 15s, Actual 15s → No penalty
Step 4: Estimated 10s, Actual 25s → Overtime 15s → Penalty 7.5 points

Final Score: 100 - 2.5 - 7.5 = 90/100
```

**Code:**
```javascript
taskPerformanceData.stepTimes.forEach((actualTime, index) => {
    const estimatedTime = taskPerformanceData.estimatedTimes[index];

    if (actualTime > estimatedTime) {
        const overtime = actualTime - estimatedTime;
        const penalty = Math.min(overtime * 0.5, 15);
        totalScore -= penalty;
    }
});

totalScore = Math.max(0, Math.round(totalScore));
```

**Completion Alert:**
```
Great job! Task completed! 🎉

Score: 90/100
Time: 93.2s / 75s
```

### 3. Firestore Audit Trail

**What Gets Saved:**

Every task completion creates a document in:
```
users/{userId}/taskHistory/{timestamp}_{day}_{taskIndex}
```

**Document Structure:**
```javascript
{
  taskName: "Make Your Bed",
  taskIcon: "🛏️",
  dayOfWeek: 1,  // 1 = Monday
  stepTimes: [35.2, 18.1, 15.0, 25.3],  // Actual time per step
  estimatedTimes: [30, 20, 15, 10],     // Expected time per step
  totalTime: 93.6,          // Total actual time
  estimatedTotal: 75,       // Total expected time
  totalScore: 90,           // Calculated score
  completedAt: "2025-10-22T10:30:00Z",
  timestamp: Firestore.Timestamp,
  userId: "abc123",
  userEmail: "user@example.com"
}
```

**Why This Data:**
- **stepTimes** - To analyze which steps take longer
- **estimatedTimes** - To compare performance to expectations
- **totalScore** - To track improvement over time
- **timestamp** - To order attempts chronologically
- **dayOfWeek** - To see which days user is most active

### 4. Day Names (Monday-Sunday)

**Previous:**
- Days shown as "Day 1", "Day 2", etc.

**New:**
- Day 1 = Monday
- Day 2 = Tuesday
- Day 3 = Wednesday
- Day 4 = Thursday
- Day 5 = Friday
- Day 6 = Saturday
- Day 7 = Sunday

**Helper Function:**
```javascript
function getDayName(dayNumber) {
    const dayNames = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday'
    };
    return dayNames[dayNumber] || `Day ${dayNumber}`;
}
```

**Updated Displays:**
- Day selector: Shows "Monday", "Tuesday", etc.
- Task list header: "📅 Monday" instead of "📅 Day 1"
- Back button: "← Back to Monday" instead of "← Back to Day 1"

### 5. History Tab (Renamed from Explore)

**Navigation Bar:**
- Icon changed: 🔍 → 📊
- Label changed: "Explore" → "History"
- Tab ID changed: `exploreTab` → `historyTab`

**Purpose:**
Show users their task completion history with performance metrics.

### 6. Grouped History View

**How It Works:**

Tasks are grouped by name, showing:
- Task icon and name
- **Completion count** (x1, x2, x3, etc.)
- **Average score** across all attempts

**Display:**
```
┌────────────────────────────────────────────┐
│  🛏️  Make Your Bed                    92  │
│      Completed 3 times          Avg Score  │
├────────────────────────────────────────────┤
│  🍽️  Wash Your Breakfast Dishes      85  │
│      Completed 5 times          Avg Score  │
├────────────────────────────────────────────┤
│  🌱  Water One Plant                  78  │
│      Completed 2 times          Avg Score  │
└────────────────────────────────────────────┘
```

**Code:**
```javascript
// Group tasks by name
const taskGroups = {};
querySnapshot.forEach((doc) => {
    const data = doc.data();
    const taskKey = data.taskName;

    if (!taskGroups[taskKey]) {
        taskGroups[taskKey] = {
            taskName: data.taskName,
            taskIcon: data.taskIcon,
            attempts: [],
            count: 0
        };
    }

    taskGroups[taskKey].attempts.push(data);
    taskGroups[taskKey].count++;
});

// Calculate average score
const avgScore = group.attempts.reduce((sum, a) =>
    sum + a.totalScore, 0) / group.count;
```

**Clickable Cards:**
- Click any task to see detailed view with graph

### 7. Multi-Line Graph for Attempt Comparison

**When Clicked:**
Shows a line graph comparing step times across multiple attempts.

**Graph Features:**
- **X-axis:** Step numbers (S1, S2, S3, etc.)
- **Y-axis:** Time in seconds
- **Multiple lines:** One per attempt (up to 6 attempts shown)
- **Different colors:** Each attempt has unique color
- **Legend:** Shows which line is which attempt
- **Data points:** Marked with squares on each line

**Example Graph:**
```
Time (s)
   60│                    ● Attempt 1 (blue)
      │                   ○ Attempt 2 (red)
   50│              ●    △ Attempt 3 (green)
      │         ●   ○
   40│    ●        △
      │   ○   △
   30│  △
      │
   20│
      └──────────────────────────
        S1   S2   S3   S4   S5
```

**Insights from Graph:**
- See which steps improve over time
- Identify steps that consistently take longer
- Track overall speed improvement
- Compare different attempts visually

**Implementation:**
Uses HTML5 Canvas API to draw:
```javascript
function drawTaskGraph(taskData) {
    const canvas = document.getElementById('taskChart');
    const ctx = canvas.getContext('2d');

    // Draw axes
    // Draw lines for each attempt
    // Add legend
}
```

**Colors Used:**
1. Blue (#3498db)
2. Red (#e74c3c)
3. Green (#2ecc71)
4. Orange (#f39c12)
5. Purple (#9b59b6)
6. Teal (#1abc9c)

### 8. Attempt Detail View

When viewing a task's history, shows:

**Summary:**
- Task name and icon
- Total completions

**Graph:**
- Multi-line comparison of all attempts

**Attempt List:**
```
┌────────────────────────────────────────────┐
│ Attempt 1    10/22/2025, 10:30 AM     95  │
│ Time: 73.2s / 75s                          │
├────────────────────────────────────────────┤
│ Attempt 2    10/22/2025, 2:15 PM      88  │
│ Time: 82.5s / 75s                          │
├────────────────────────────────────────────┤
│ Attempt 3    10/23/2025, 9:00 AM      92  │
│ Time: 76.8s / 75s                          │
└────────────────────────────────────────────┘
```

**Score Color Coding:**
- **Green:** Score >= 80 (excellent)
- **Yellow:** Score >= 60 (good)
- **Red:** Score < 60 (needs improvement)

## User Experience Flow

### Completing a Task

1. **Start task:**
   - Timer starts (e.g., 0:30)
   - Voice announces step
   - Timer counts down

2. **During step:**
   - Timer: 0:30 → 0:29 → ... → 0:10 (turns red)
   - Timer: 0:10 → ... → 0:00 (announces "Time is up!")
   - Timer: 0:00 → -0:01 → -0:05 (darker red, faster pulse)

3. **Complete step:**
   - Say "done" or click "✓ Done"
   - Actual time recorded: 35 seconds
   - Move to next step

4. **Complete task:**
   - All step times recorded
   - Score calculated
   - Saved to Firestore
   - Alert shows score
   - Return to day view

### Viewing History

1. **Tap "History" tab** (📊)
   - Loads from Firestore
   - Groups tasks by name
   - Shows completion counts

2. **Tap a task card:**
   - Shows detailed view
   - Graph displays with multiple lines
   - List of all attempts

3. **Tap "Back to History":**
   - Returns to task list

## Technical Details

### Performance Tracking Variables

```javascript
let currentTaskStartTime = null;
let currentStepStartTime = null;
let taskPerformanceData = {
    stepTimes: [],
    estimatedTimes: [],
    totalScore: 0,
    taskName: '',
    taskIcon: '',
    dayOfWeek: 0
};
```

### Timer States CSS

```css
/* Normal state */
#stepTimer {
    color: #2c3e50;
}

/* Warning state (< 10s) */
.timer-warning {
    color: #e74c3c !important;
    animation: timerPulse 1s ease-in-out infinite;
}

/* Overtime state (negative) */
.timer-overtime {
    color: #c0392b !important;
    animation: overtimePulse 0.5s ease-in-out infinite;
}
```

### Firestore Security Rules Needed

```javascript
// Allow users to write their own task history
match /users/{userId}/taskHistory/{docId} {
  allow write: if request.auth != null && request.auth.uid == userId;
  allow read: if request.auth != null && request.auth.uid == userId;
}
```

## Benefits

### For Users:

1. **Clear Feedback:**
   - Know exactly how much overtime taken
   - See numeric score for performance
   - Visual graph shows improvement

2. **Motivation:**
   - Compete against own previous attempts
   - See progress over time
   - Aim for higher scores

3. **Awareness:**
   - Identify which steps take longer
   - Understand time management
   - Track completion patterns

### For Caregivers/Therapists:

1. **Progress Monitoring:**
   - See all task completions
   - Track improvement trends
   - Identify problem areas

2. **Data-Driven Decisions:**
   - Which tasks need more practice
   - Which steps need extra support
   - When to adjust estimates

3. **Objective Metrics:**
   - Hard data, not just observations
   - Quantifiable progress
   - Historical trends

## Future Enhancements

Potential improvements:

1. **Adaptive Estimates:**
   - Adjust estimated times based on user's averages
   - Personalized difficulty

2. **Achievements/Badges:**
   - "Perfect Score" - Score 100
   - "Speedy" - Beat time by 20%
   - "Consistent" - Complete same task 5 days in row

3. **Weekly Reports:**
   - Summary of tasks completed
   - Average scores
   - Most improved task

4. **Compare to Others:**
   - Anonymous benchmarks
   - Age-appropriate comparisons
   - Privacy-preserving aggregation

5. **Export Data:**
   - CSV download
   - PDF report
   - Share with healthcare provider

6. **Goal Setting:**
   - Set target score
   - Set target completion count
   - Track progress to goal

## Testing

To test the new features:

1. **Complete a task twice:**
   - Monday → Make Your Bed (try to beat estimate)
   - Check score in completion alert
   - Repeat the same task

2. **View History tab:**
   - Should see "Make Your Bed" with "Completed 2 times"
   - Shows average score

3. **Click task card:**
   - See graph with 2 lines
   - Each line shows step times for one attempt
   - See list of attempts with scores

4. **Test negative timer:**
   - Start a task
   - Wait for timer to hit 0:00
   - Keep waiting - should go -0:01, -0:02, etc.
   - Complete step - overtime recorded

5. **Check Firestore:**
   - Open Firebase Console
   - Navigate to Firestore
   - Check `users/{userId}/taskHistory`
   - Should see documents with all metrics

## Files Modified

- ✅ `web/index.html` - All new features
- ✅ `index.html` - Synced
- ✅ `ios/App/App/public/index.html` - Synced

## Data Privacy

**User data:**
- Stored in user's own Firestore collection
- Only accessible by that user
- Not shared with other users
- Can be deleted by user

**What's NOT collected:**
- No video/audio recordings
- No location data
- No device information
- No third-party tracking

## Console Logging

Helpful debug logs:

```
⏱️  Step 1 completed in 35.2s
⏱️  Step 2 completed in 18.1s
⏱️  Final step completed in 25.3s
📊 Task Performance: { stepTimes: [...], totalScore: 90 }
✅ Task completion saved to Firestore
```

## Current Status

✅ Timer goes negative
✅ Scoring system implemented
✅ Firestore audit trail working
✅ Days renamed to Monday-Sunday
✅ History tab created
✅ Grouped task view with counts
✅ Multi-line graph for comparisons
✅ All changes synced to iOS

The task tracking and history system is now fully operational!

## Summary

This update transforms StepAhead from a simple task list into a comprehensive **task coaching and performance tracking system**:

- **Real-time feedback** via timer and voice
- **Objective scoring** based on performance
- **Complete audit trail** in Firestore
- **Visual progress tracking** with graphs
- **Comparative analysis** across attempts

Users can now not only complete tasks, but **measure, track, and improve** their performance over time!
