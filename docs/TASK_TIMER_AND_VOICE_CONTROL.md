# Task Timer and Voice Control Feature

## Overview

Added a comprehensive task timer system with voice commands and text-to-speech announcements to help users complete tasks step-by-step.

## Features Added

### 1. Step Timer with Countdown

Each task step now displays a countdown timer showing the estimated time for completion:

- **Visual Timer Display:** Large, easy-to-read countdown clock (MM:SS format)
- **Step-Specific Durations:** Each step has a custom estimated time
- **Countdown Animation:** Timer counts down in real-time
- **Visual Warning:** Timer turns red and pulses when less than 10 seconds remain
- **Audio Alert:** Text-to-speech announces when time is up

### 2. Voice Recognition Commands

Users can control task progression using voice commands:

**Supported Commands:**
- "done"
- "next"
- "complete"
- "ok"

**How It Works:**
- Voice recognition starts automatically when a task begins
- Listens continuously for completion commands
- Advances to next step or completes task when command recognized
- Works in background while user performs the task

### 3. Text-to-Speech Announcements

The app reads instructions aloud to guide users:

**What Gets Announced:**
- Task name when starting
- Each step instruction
- Reminder to say voice commands
- Time-up notification
- Task completion celebration

**Example Announcement:**
> "Starting task: Make Your Bed. Pull the blanket and sheets up to the pillows. Say done, next, complete, or ok to move to the next step."

### 4. Visual "Done" Button

For users who prefer not to use voice commands:

- Large, prominent "✓ Done" button
- Purple gradient styling for visibility
- Hover animation for feedback
- Alternative to voice commands
- Clear instruction showing voice options

## Technical Implementation

### Task Data Structure

Each task now includes `stepDurations` array:

```javascript
{
  name: "Make Your Bed",
  icon: "🛏️",
  steps: [
    "Pull the blanket and sheets up to the pillows",
    "Smooth out any wrinkles with your hands",
    "Arrange the pillows at the top",
    "Step back and look - you did it!"
  ],
  stepDurations: [30, 20, 15, 10], // seconds for each step
  color: "#E8F4F8"
}
```

### Key Functions

**Timer Management:**
```javascript
startStepTimer(duration)  // Starts countdown timer for step
updateTimerDisplay()      // Updates timer every second
```

**Voice Recognition:**
```javascript
initVoiceRecognition()    // Initialize Web Speech API
startVoiceRecognition()   // Start listening for commands
stopVoiceRecognition()    // Stop listening (on task completion)
handleStepComplete()      // Handle voice/button completion
```

**Text-to-Speech:**
```javascript
speak(text)               // Announce text using Speech Synthesis API
```

### Browser Compatibility

**Voice Recognition:**
- ✅ Chrome/Edge (Web Speech API)
- ✅ Safari (WebKit Speech Recognition)
- ❌ Firefox (not supported - button fallback available)

**Text-to-Speech:**
- ✅ Chrome/Edge
- ✅ Safari
- ✅ Firefox
- ✅ Most modern browsers

**Fallback:**
If voice recognition is not supported, the "Done" button works independently.

## User Experience Flow

### Starting a Task

1. User selects a task from their day
2. Task card displays with:
   - Task icon and name
   - Large countdown timer
   - Current step instruction
   - "Done" button
   - Voice command hint
3. Voice recognition starts automatically
4. Text-to-speech announces the task and first step

### Completing a Step

**Option 1 - Voice Command:**
1. User performs the step
2. User says "done", "next", "complete", or "ok"
3. Voice command recognized
4. Timer advances to next step
5. New step announced via text-to-speech

**Option 2 - Button Click:**
1. User performs the step
2. User clicks "✓ Done" button
3. Timer advances to next step
4. New step announced via text-to-speech

### Timer Behavior

**Normal State:**
- Timer counts down from estimated duration
- Displayed in black color
- Smooth countdown

**Warning State (< 10 seconds):**
- Timer turns red
- Pulses with animation
- Visual urgency indicator

**Time Up:**
- Timer reaches 0:00
- Stops counting (doesn't go negative)
- Announces: "Time is up! Say done or next to continue."
- User can still take more time if needed

### Completing a Task

**Last Step:**
- "Done" button or voice command
- Announces: "Great job! Task completed!"
- Shows success alert
- Stops voice recognition
- Clears timer
- Returns to task list

## Visual Design

### Timer Display

```
┌─────────────────────────┐
│         0:30            │  ← Large, bold countdown
│  ⏱️ Estimated time for  │  ← Helpful label
│      this step          │
└─────────────────────────┘
```

### Done Button

```
┌────────────────────────────┐
│      ✓ Done                │  ← Purple gradient button
├────────────────────────────┤
│  🎤 Or say "done", "next", │  ← Voice hint
│     "complete", or "ok"    │
└────────────────────────────┘
```

### Progress Tracking

```
Step 2 of 4

[✓] [✓] [3] [4]  ← Progress dots
```

## Accessibility Features

1. **Visual + Audio Feedback:**
   - See the timer count down
   - Hear instructions read aloud

2. **Multiple Input Methods:**
   - Voice commands
   - Touch/click button
   - Previous/Next buttons still available

3. **Clear Instructions:**
   - Each step read aloud
   - Visual timer guidance
   - Command hints displayed

4. **Flexible Timing:**
   - Timer is a guide, not enforced
   - Users can take more time if needed
   - No penalties for exceeding time

## Step Duration Estimates

### Current Estimates

**Make Your Bed:**
- Pull blanket up: 30 seconds
- Smooth wrinkles: 20 seconds
- Arrange pillows: 15 seconds
- Step back: 10 seconds

**Wash Dishes:**
- Scrape food: 20 seconds
- Turn on water: 10 seconds
- Apply soap: 15 seconds
- Scrub dishes: 60 seconds
- Rinse: 30 seconds
- Place to dry: 20 seconds

**Water Plant:**
- Get water: 15 seconds
- Find plant: 30 seconds
- Check soil: 20 seconds
- Pour water: 30 seconds
- Celebrate: 10 seconds

### Default Duration

Tasks without specified durations default to **30 seconds per step**.

## Configuration

### Adjust Speech Rate

In `speak()` function:
```javascript
utterance.rate = 0.9;  // 0.1-10, default 1
                       // 0.9 = slightly slower for clarity
```

### Adjust Timer Warning Threshold

In `updateTimerDisplay()` function:
```javascript
if (timeRemaining <= 10) {  // Change 10 to different value
    timerElement.classList.add('timer-warning');
}
```

### Adjust Voice Recognition Language

In `initVoiceRecognition()` function:
```javascript
recognition.lang = 'en-US';  // Change to other language codes
```

## Future Enhancements

Potential improvements:

1. **Customizable Step Durations:**
   - Allow users to adjust times
   - Learn from user's actual completion times
   - Personalized estimates

2. **Pause/Resume Timer:**
   - Pause button for interruptions
   - Resume where left off

3. **Task Statistics:**
   - Track average completion times
   - Show personal best times
   - Progress over time

4. **More Voice Commands:**
   - "pause" / "resume"
   - "repeat" (read step again)
   - "help" (show voice commands)

5. **Multi-Language Support:**
   - Spanish, French, etc.
   - Locale-specific speech

6. **Visual Progress Bar:**
   - Circular progress around timer
   - Linear bar below timer

## Testing

To test the feature:

1. **Login to the app**
2. **Select a day** (e.g., Day 1)
3. **Select a task** (e.g., Make Your Bed)
4. **Observe:**
   - Timer displays and counts down
   - Step is announced via audio
   - Voice command hint shown
5. **Test voice command:**
   - Say "done" or "next"
   - Should advance to next step
6. **Test button:**
   - Click "✓ Done" button
   - Should advance to next step
7. **Complete task:**
   - On last step, say "done" or click button
   - Should show completion and return to task list

## Browser Permissions

**First time using voice commands:**
- Browser will request microphone permission
- User must grant permission
- Permission persists for domain

**If permission denied:**
- Voice commands won't work
- "Done" button still works
- No error shown to user

## Console Logging

Helpful logs for debugging:

```
✅ Voice recognition initialized
✅ Firebase functions exposed to window
🎤 Voice recognition started
🔊 Speaking: Starting task: Make Your Bed...
🎤 Voice command: done
🔊 Speaking: Step 2. Smooth out any wrinkles...
```

## Files Modified

- ✅ `web/index.html` - Added timer, voice, and speech features
- ✅ `index.html` - Synced from web/index.html
- ✅ `ios/App/App/public/index.html` - Synced from web/index.html

## CSS Classes Added

```css
.timer-warning {
    color: #e74c3c !important;
    animation: timerPulse 1s ease-in-out infinite;
}

@keyframes timerPulse {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.1); opacity: 0.8; }
}
```

## JavaScript Variables Added

```javascript
let stepTimer = null;           // Interval for countdown
let timeRemaining = 0;          // Current time left
let recognition = null;         // Speech recognition instance
let isVoiceEnabled = false;     // Voice listening state
```

## Current Status

✅ Timer displays on each step
✅ Countdown animation works
✅ Voice recognition listens for commands
✅ Text-to-speech announces steps
✅ "Done" button provides visual alternative
✅ Visual warning at 10 seconds
✅ Audio notification when time is up
✅ Voice recognition stops on task completion
✅ Timer clears on task completion

The task timer and voice control system is now fully functional!

## User Benefits

1. **Better Task Guidance:** Know how long each step should take
2. **Hands-Free Operation:** Complete tasks without touching device
3. **Audio Instructions:** Hear what to do next
4. **Flexible Interaction:** Voice OR button - user's choice
5. **Time Management:** Visual countdown helps pace work
6. **Accessibility:** Multiple ways to interact with tasks
7. **Motivation:** See progress and celebrate completion

This feature transforms the app into a true task coaching system!
