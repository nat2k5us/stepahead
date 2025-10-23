# Bonus Tasks and Today-Focused UI

## Overview

Implemented a today-focused experience with bonus task system and improved day selection UI:
- **Today's card is 4x larger** with task preview
- **Other days are smaller cards** at the bottom
- **Only today's tasks are enabled** - other days are view-only
- **Bonus tasks** can be added after completing all required tasks with 70%+ average score
- **One bonus task at a time** - complete one to add another

## Features Implemented

### 1. Today-Focused Day Selection

**Today's Large Card:**
- **4x larger** than other day cards
- **Gradient background** (purple gradient)
- **Task preview list** showing all tasks for today
- **Hover animation** - lifts on hover
- **Clear call-to-action** - "Tap to start your day!"

**Layout:**
```
┌─────────────────────────────────────────┐
│           🏠 My Daily Tasks             │
│         Today is Monday                 │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │                                   │ │
│  │          📅                       │ │
│  │        Monday                     │ │
│  │     3 tasks to complete           │ │
│  │                                   │ │
│  │   Today's Tasks:                  │ │
│  │   🛏️ Make Your Bed (4 steps)      │ │
│  │   🍽️ Wash Dishes (6 steps)       │ │
│  │   🌱 Water Plant (5 steps)        │ │
│  │                                   │ │
│  │   👆 Tap to start your day!       │ │
│  │                                   │ │
│  └───────────────────────────────────┘ │
│                                         │
│         ──── Other Days ────            │
│                                         │
│  ┌────┐  ┌────┐  ┌────┐                │
│  │Tue │  │Wed │  │Thu │                │
│  │ 🔒 │  │ 🔒 │  │ 🔒 │                │
│  └────┘  └────┘  └────┘                │
│  ┌────┐  ┌────┐  ┌────┐                │
│  │Fri │  │Sat │  │Sun │                │
│  │ 🔒 │  │ 🔒 │  │ 🔒 │                │
│  └────┘  └────┘  └────┘                │
└─────────────────────────────────────────┘
```

**Code:**
```javascript
// Get today's day number (1=Monday, 7=Sunday)
function getTodayDayNumber() {
    const today = new Date().getDay(); // 0=Sunday, 1=Monday
    return today === 0 ? 7 : today; // Convert Sunday from 0 to 7
}

// Render today's card large
const todayDayNumber = getTodayDayNumber();
const todayTasks = tasks[todayDayNumber];

// Large card with gradient, icon, task list
html += `
    <button class="today-card" style="
        width: 100%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 30px;
        ...
    ">
        <div style="font-size: 60px;">📅</div>
        <div style="font-size: 28px;">${getDayName(todayDayNumber)}</div>
        <!-- Task preview list -->
    </button>
`;
```

### 2. Smaller Day Cards for Other Days

**Other Days:**
- **1/3 size** of today's card
- **3 columns grid** layout
- **Disabled state** - grayed out with lock icon
- **View only** - can view but not complete tasks
- **Aligned at bottom** below today's card

**Visual Styling:**
```css
background: rgba(150, 150, 150, 0.3); /* Grayed out */
opacity: 0.6; /* Semi-transparent */
cursor: not-allowed; /* Can't click */
```

**Lock Icon:**
```html
🔒 View Only
```

### 3. Disabled Tasks for Non-Today Days

**When viewing a non-today day:**

**Warning Banner:**
```
┌────────────────────────────────────────┐
│  🔒 View Only - Tasks can only be     │
│  completed on their scheduled day      │
└────────────────────────────────────────┘
```

**Task Cards:**
- **Opacity: 0.5** - Visually disabled
- **Lock icon** in top-right corner
- **Cursor: not-allowed**
- **onclick returns false** - Can't be clicked
- **disabled attribute** - Actually disabled

**Code:**
```javascript
const isToday = currentDay === todayDayNumber;
const isDisabled = !isToday;

dayTasks.forEach((task, index) => {
    html += `
        <button class="task-button"
                onclick="${isDisabled ? 'return false' : `showTaskView(${index})`}"
                style="${isDisabled ? 'opacity: 0.5; cursor: not-allowed;' : ''}"
                ${isDisabled ? 'disabled' : ''}>
            ${isDisabled ? '<div style="position: absolute; top: 10px; right: 10px;">🔒</div>' : ''}
        </button>
    `;
});
```

### 4. Bonus Task System

**How It Works:**

**Requirements to unlock bonus tasks:**
1. ✅ All required tasks for the day completed
2. ✅ Average score across all completions >= 70%
3. ✅ Must be today (not a past/future day)

**Checking Eligibility:**
```javascript
async function checkDayCompletion(dayNumber) {
    // Get required task count
    const requiredTaskCount = tasks[dayNumber].length;

    // Get today's completions from Firestore
    const today = new Date().toDateString();
    let todayCompletions = [];

    querySnapshot.forEach((doc) => {
        const data = doc.data();
        const completedDate = data.timestamp?.toDate().toDateString();
        if (completedDate === today) {
            todayCompletions.push(data);
        }
    });

    // Check if all tasks completed
    const allComplete = todayCompletions.length >= requiredTaskCount;

    // Calculate average score
    let avgScore = 0;
    if (todayCompletions.length > 0) {
        const totalScore = todayCompletions.reduce((sum, t) =>
            sum + (t.totalScore || 0), 0);
        avgScore = totalScore / todayCompletions.length;
    }

    // Can add bonus if all complete AND score >= 70
    const canAddBonus = allComplete && avgScore >= 70;

    return { allComplete, canAddBonus, avgScore };
}
```

**Three Scenarios:**

**Scenario 1: Not All Tasks Complete**
```
(Nothing shown - keep completing required tasks)
```

**Scenario 2: All Complete, BUT Score < 70%**
```
┌────────────────────────────────────────┐
│  📊 Current Average Score: 65/100     │
│                                        │
│  Complete tasks again with 70%+       │
│  average to unlock bonus tasks!       │
└────────────────────────────────────────┘
```

**Scenario 3: All Complete AND Score >= 70%**
```
┌────────────────────────────────────────┐
│         ⭐ Add Bonus Task ⭐           │
│   Earn extra points! (Avg: 85/100)    │
└────────────────────────────────────────┘
```

### 5. Adding a Bonus Task

**User Flow:**

1. **Complete all required tasks** with good scores
2. **See "Add Bonus Task" button** appear
3. **Click button** → Prompt appears
4. **Enter task name** (e.g., "Organize my desk")
5. **Task added** to today's list with:
   - **Icon:** ⭐ (star)
   - **Color:** #FFD700 (gold)
   - **Badge:** "⭐ BONUS" label
   - **1 step:** "Complete this bonus task!"
   - **Duration:** 60 seconds

**Code:**
```javascript
function addBonusTask(dayNumber) {
    const taskName = prompt('Enter bonus task name:');
    if (!taskName) return;

    const newTask = {
        name: taskName,
        icon: '⭐',
        steps: ['Complete this bonus task!'],
        stepDurations: [60],
        color: '#FFD700',
        isBonus: true  // Mark as bonus
    };

    tasks[dayNumber].push(newTask);
    showTasksView(dayNumber);  // Refresh view
}
```

**Bonus Task Appearance:**
```
┌────────────────────────────────────┐
│  ⭐                                │
│                                    │
│  Task 4: Organize my desk          │
│  ⭐ BONUS                          │
│  1 step                            │
└────────────────────────────────────┘
```

### 6. One Bonus at a Time

**Logic:**
- After completing a bonus task, button reappears
- Can add another bonus task
- Repeat indefinitely as long as average >= 70%

**Why:**
- Keeps users focused on one task at a time
- Prevents overwhelming with too many options
- Encourages quality over quantity

## User Experience

### Morning Flow

**1. User opens app:**
```
Sees: Large Monday card with today's 3 tasks
      Small grayed cards for Tue-Sun below
```

**2. User taps Monday card:**
```
Shows: 3 enabled task cards
       (Tue-Sun would show disabled tasks)
```

**3. User completes all 3 tasks:**
```
Scores: Task 1: 95/100
        Task 2: 88/100
        Task 3: 92/100
Average: 91.67/100 ✅ (> 70%)
```

**4. Returns to task list:**
```
Shows: "⭐ Add Bonus Task ⭐" button
       Earn extra points! (Avg: 92/100)
```

**5. User clicks button:**
```
Prompt: "Enter bonus task name:"
User types: "Clean bathroom sink"
```

**6. New task appears:**
```
Task 4: Clean bathroom sink ⭐ BONUS
1 step
```

**7. User completes bonus task:**
```
Score: 80/100
New Average: (95+88+92+80)/4 = 88.75/100
```

**8. Button reappears:**
```
Shows: "⭐ Add Bonus Task ⭐" button again
       Can add another!
```

### Low Score Scenario

**1. User completes tasks with low scores:**
```
Task 1: 55/100
Task 2: 60/100
Task 3: 65/100
Average: 60/100 ❌ (< 70%)
```

**2. Returns to task list:**
```
Shows: "📊 Current Average Score: 60/100
        Complete tasks again with 70%+ average
        to unlock bonus tasks!"
```

**3. User repeats Task 1:**
```
New attempt: 85/100
Now have: 55, 60, 65, 85
Average: 66.25/100 ❌ (still < 70%)
```

**4. User repeats Task 2:**
```
New attempt: 90/100
Now have: 55, 60, 65, 85, 90
Average: 71/100 ✅ (>= 70%)
```

**5. Bonus task unlocked!**
```
Shows: "⭐ Add Bonus Task ⭐" button
```

### Viewing Other Days

**1. User taps "Tuesday" (small card):**
```
Shows: Task list with warning banner
       "🔒 View Only - Tasks can only be completed
        on their scheduled day"

       All task cards grayed out with 🔒 icon
       Can't click them
```

**2. User can see what's coming:**
```
Task 1: Make Your Bed 🔒
Task 2: Take Out Trash 🔒
Task 3: Wipe Counter 🔒
```

**3. User goes back:**
```
Returns to day selector
Only Monday (today) is enabled
```

## Technical Details

### Today Detection

```javascript
function getTodayDayNumber() {
    const today = new Date().getDay();
    // JavaScript: 0=Sun, 1=Mon, 2=Tue, ..., 6=Sat
    // Our system: 1=Mon, 2=Tue, ..., 7=Sun
    return today === 0 ? 7 : today;
}
```

### Completion Tracking

**Firestore Query:**
```javascript
// Get all completions for this day
const q = query(
    taskHistoryRef,
    where('dayOfWeek', '==', dayNumber)
);

// Filter to only today's date
const today = new Date().toDateString(); // "Mon Oct 22 2025"
todayCompletions = completions.filter(c =>
    c.timestamp?.toDate().toDateString() === today
);
```

**Why This Works:**
- Counts each completion separately
- User can complete same task multiple times
- Only counts completions from today
- Allows score improvement through repetition

### Bonus Task Data Structure

```javascript
{
    name: "User-entered task name",
    icon: "⭐",
    steps: ["Complete this bonus task!"],
    stepDurations: [60],  // 1 minute
    color: "#FFD700",     // Gold
    isBonus: true         // Flag for special handling
}
```

**Why Simple:**
- Bonus tasks are meant to be quick
- One step keeps it focused
- 60 seconds is reasonable default
- User can take more time if needed

### Visual Hierarchy

**Card Sizes:**
- Today's card: **100% width, 300px+ height**
- Other days: **33% width, 120px height**
- Ratio: Approximately **4:1** as requested

**Color Coding:**
- Today: Purple gradient (vibrant, active)
- Other days: Gray translucent (inactive)
- Bonus task: Gold (#FFD700)

## Benefits

### For Users:

1. **Clear Focus:**
   - See today's tasks immediately
   - Not distracted by other days
   - Large, prominent card guides attention

2. **Motivation Through Bonuses:**
   - Extra tasks = extra points
   - Encourages high scores (70%+ requirement)
   - Sense of achievement

3. **Flexibility:**
   - Can add custom tasks
   - Not limited to preset tasks
   - Personalize daily routine

4. **Planning:**
   - See upcoming days (view-only)
   - Know what's coming tomorrow
   - Prepare mentally

### For Caregivers:

1. **Structured Routine:**
   - One day at a time
   - Prevents overwhelm
   - Clear daily expectations

2. **Quality Enforcement:**
   - Must score 70%+ for bonuses
   - Encourages task repetition to improve
   - Focus on doing well, not just completing

3. **Progress Tracking:**
   - Can see if user earned bonus tasks
   - Average scores visible
   - Improvement over time

## Edge Cases Handled

### What if user completes tasks at 11:59 PM?

**Midnight Rollover:**
- Completions timestamped at completion time
- `toDateString()` compares dates, not times
- Tasks completed on 10/22 count for 10/22
- Even if viewed on 10/23

**Example:**
```
10/22 11:59 PM: Complete Task 1 → Counts for 10/22
10/23 12:01 AM: View tasks → 10/23 is "today"
                            → 10/22 tasks don't count
```

### What if user never reaches 70%?

**No Bonus Access:**
- System shows encouragement message
- User can retry tasks to improve score
- No penalty, just no bonus unlock
- Can still complete required tasks tomorrow

### What if user adds bonus but doesn't complete it?

**Bonus Persists:**
- Bonus task stays in task list
- Treated like any other task
- Must complete to unlock next bonus
- Can view but not complete on other days

### What if system date is wrong?

**Graceful Degradation:**
- Uses JavaScript `new Date()`
- Relies on device time
- If wrong, user sees wrong "today"
- No data corruption - just UX issue

## Future Enhancements

Potential improvements:

1. **Bonus Point Multipliers:**
   - 1st bonus: 1.5x points
   - 2nd bonus: 2x points
   - Encourage multiple bonuses

2. **Streak Tracking:**
   - 7 days of 70%+ average
   - Unlock special rewards
   - Visual streak counter

3. **Custom Bonus Steps:**
   - Let user define multiple steps
   - More complex bonus tasks
   - Higher point values

4. **Scheduled Bonuses:**
   - Pre-plan bonus tasks
   - Auto-appear when unlocked
   - Weekly bonus suggestions

5. **Challenge Mode:**
   - Time-based challenges
   - Score-based challenges
   - Leaderboards (if multi-user)

## Testing

To test the new features:

**Test Today's Large Card:**
1. Open app
2. Verify large card for current day
3. Check task preview list
4. Tap card → should navigate to tasks

**Test Other Days Disabled:**
1. Scroll to "Other Days" section
2. Tap a non-today day
3. Verify "View Only" warning
4. Try to click tasks → should be disabled

**Test Bonus Task System:**
1. Complete all tasks for today with score >= 70%
2. Return to task list
3. Should see "Add Bonus Task" button
4. Click → enter task name
5. Verify bonus task appears with ⭐ BONUS badge

**Test Low Score Scenario:**
1. Complete tasks with average < 70%
2. Return to task list
3. Should see message about needing 70%+
4. Repeat tasks with better scores
5. Button should appear when average >= 70%

## Files Modified

- ✅ `web/index.html` - All features implemented
- ✅ `index.html` - Synced
- ✅ `ios/App/App/public/index.html` - Synced

## Console Logging

Helpful debug logs:

```
getTodayDayNumber: 1 (Monday)
checkDayCompletion: { allComplete: true, canAddBonus: true, avgScore: 85 }
addBonusTask: Organize my desk
```

## Current Status

✅ Today's card 4x larger with task preview
✅ Other days smaller and disabled
✅ Only today's tasks enabled
✅ Bonus task system with 70% requirement
✅ One bonus at a time
✅ Bonus badge and gold styling
✅ All changes synced to iOS

The today-focused UI with bonus task system is now fully operational!

## Summary

This update creates a **focused, progressive daily experience**:

- **Clear priority** - Today's tasks are front and center
- **Quality over quantity** - Must score well to unlock bonuses
- **Controlled progression** - One bonus at a time
- **Future planning** - Can preview upcoming days
- **Motivation system** - Bonus tasks as rewards

Users now have a **structured, rewarding daily routine** with the ability to **earn extra credit** for excellent performance!
