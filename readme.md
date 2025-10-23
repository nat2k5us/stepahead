# StepAhead - Daily Task Helper

Simple step-by-step household tasks for everyone, especially helpful for individuals with autism or memory challenges.

## 🚀 Quick Start

```bash
# 1. Run the app in iOS Simulator
./run-me-first.sh
# Select: 🚀 Launch in Simulator

# 2. Or test in web browser
python3 -m http.server 8000
# Open http://localhost:8000
```

## 📱 About StepAhead

**Purpose:** Help special needs individuals, memory-challenged users, and those with multi-task difficulties improve these deficiencies through fun, inspiring, and structured daily practice.

**Mission:**
Transform daily household tasks into therapeutic learning experiences that build confidence, independence, and life skills through positive reinforcement and progressive challenge.

**How It Helps:**
- 🧠 **Memory Training** - Builds memory through repetition and structured routines
- 🎯 **Focus Building** - Single-task focus reduces overwhelm and improves concentration
- ⭐ **Confidence Boost** - Small wins create positive momentum and self-esteem
- 📈 **Progressive Learning** - Gradually increases complexity as skills improve
- 🎨 **Visual Support** - Icons, colors, and progress dots provide clear guidance
- 🎉 **Positive Reinforcement** - Celebrates every completed step and task

**Features:**
- 7 days of progressive tasks (3 tasks on Day 1, up to 9 tasks on Day 7)
- Step-by-step instructions with visual progress indicators
- Each task broken into simple, manageable steps
- Beautiful color-coded task cards for visual learning
- Achievement tracking to show progress over time
- Fun and encouraging feedback

**Target Audience:**
- Individuals with autism spectrum disorders
- People with memory challenges or cognitive difficulties
- Those struggling with multi-tasking and task management
- Anyone learning independent living skills
- Caregivers and therapists supporting skill development

## ⚙️ Current Configuration

**Status:** ✅ Fully configured and ready to test

- **App Name:** StepAhead
- **Bundle ID:** com.stepahead.app
- **Firebase Project:** stepahead-519b0
- **Package Name:** stepahead
- **Author:** Natraj Bontha

Run `./show-config.sh` to see all current values (27/27 parameters customized).

## 🔥 Firebase Setup

### Current Status

✅ **Configuration Updated:**
- Project ID: `stepahead-519b0`
- API Key: Configured
- All Firebase values updated in code

⏳ **Firebase Console Setup Needed:**

1. **Enable Email/Password Authentication:**
   ```
   https://console.firebase.google.com/project/stepahead-519b0/authentication
   → Sign-in method → Enable "Email/Password"
   ```

2. **Create Firestore Database:**
   ```
   → Firestore Database → Create database
   → Start in production mode
   → Choose location: us-central (recommended)
   ```

3. **Set Security Rules:**
   Copy rules from section below and paste in Firestore → Rules tab

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Task completions
      match /completions/{completionId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // User progress
      match /progress/{progressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Public tasks (read-only)
    match /tasks/{taskId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

## 🔐 Authentication

### Current Setup: Email + Password

**How it works:**
1. User enters name, email, password
2. Firebase creates account
3. User data saved to Firestore: `users/{uid}`
4. Automatically logged in

**Login credentials for testing (bypass mode active):**
- Click "SIGN IN" button (no credentials needed)
- Or use: dev@master.local / master123

### Future: Username-Only Authentication

**Planned improvement:**
- User enters: `john` + `password123`
- System generates: `john@stepahead.app` (behind the scenes)
- User only remembers: `john`

**To implement:** See `unified-auth.js` for complete code

### Password Reset

**In Firebase Console:**
1. Go to Authentication → Users
2. Find user → Click ⋮ → "Reset password"
3. Firebase sends reset email

**For username system:** Manual reset recommended (user contacts support)

## 📝 Task Structure

### Day 1: 3 Tasks
- Make Your Bed (4 steps)
- Wash Breakfast Dishes (6 steps)
- Water One Plant (5 steps)

### Day 2: 4 Tasks
- Make Your Bed
- Take Out the Trash
- Wipe the Kitchen Counter
- Put Away 5 Things

### Day 3-7: Progressive Complexity
Tasks increase to 5, 6, 7, 8, and 9 tasks by Day 7, teaching users gradually.

## 🌟 How StepAhead Improves Skills

### Memory Improvement
**The Challenge:** Forgetting what to do next, losing track mid-task
**How StepAhead Helps:**
- Breaks tasks into memorable chunks
- Visual reminders at each step
- Repetition builds long-term memory
- Progress tracking shows what's been done
- Daily practice strengthens recall

### Multi-Tasking Development
**The Challenge:** Getting overwhelmed by multiple tasks, not knowing where to start
**How StepAhead Helps:**
- Single-task focus (no switching mid-task)
- Clear sequence: Day → Task → Step
- Gradual increase in task count (3 → 9 tasks)
- Completion tracking prevents redoing tasks
- Builds capacity over time

### Executive Function Training
**The Challenge:** Difficulty planning, organizing, and completing tasks
**How StepAhead Helps:**
- Pre-planned task sequences
- Clear start and end points
- Step-by-step structure eliminates planning burden
- Progress visualization shows achievement
- Routine building through daily practice

### Confidence & Independence Building
**The Challenge:** Fear of failure, reliance on others
**How StepAhead Helps:**
- Success guaranteed (can't fail, only practice)
- Celebrates every small win
- Builds competence through repetition
- Visual proof of progress
- Reduces need for caregiver prompting

### Focus & Attention Training
**The Challenge:** Distraction, losing focus mid-task
**How StepAhead Helps:**
- One step visible at a time
- Clear visual cues
- No unnecessary distractions
- Manageable chunks prevent overwhelm
- Completion feedback reinforces attention

## 🛠️ Development

### Test in Web Browser

```bash
# Start local server
python3 -m http.server 8000

# Open http://localhost:8000
# Click "SIGN IN" (bypass mode active)
```

### Test in iOS Simulator

```bash
# Option 1: Use menu
./run-me-first.sh
# Select: 🚀 Launch in Simulator

# Option 2: Manual
npx cap sync ios
npx cap open ios
# Build and run in Xcode
```

### Making Changes

```bash
# 1. Edit index.html (your main app file)

# 2. Sync to web and iOS
cp index.html web/index.html
npx cap copy ios

# 3. Test
./run-me-first.sh
```

## 📂 Project Structure

```
stepahead/
├── index.html                    # Main app with StepAhead tasks
├── web/index.html               # Synced copy for web
├── ios/App/App/public/          # Synced to iOS
├── stepahead.html               # Original standalone version (reference)
├── capacitor.config.json        # App configuration
├── package.json                 # Dependencies
├── .firebaserc                  # Firebase project
├── show-config.sh              # View current configuration
├── run-me-first.sh             # Interactive deployment menu
└── readme.md                   # This file
```

## 🚢 Deployment

### TestFlight (iOS Beta)

```bash
./run-me-first.sh
# Select: 📦 Publish to TestFlight
```

Requirements:
- Apple Developer account
- App Store Connect API key configured
- Certificates and provisioning profiles

### App Store (iOS Production)

```bash
./run-me-first.sh
# Select: 🏪 Publish to App Store
```

## 🎯 Roadmap

### Phase 1: Core Functionality ✅
- [x] Task data structure with progressive difficulty
- [x] Navigation system
- [x] Step-by-step UI with visual progress
- [x] Firebase integration
- [x] User authentication
- [x] Fun, encouraging design

### Phase 2: Achievement & Progress Tracking (Next)
- [ ] Save completed tasks to Firestore
- [ ] Track completion history with calendar view
- [ ] Daily streak counter (build positive habits!)
- [ ] Progress statistics and improvement graphs
- [ ] Achievement badges and rewards 🏆
- [ ] Celebration animations on task completion
- [ ] Weekly improvement summary

### Phase 3: Therapeutic Enhancements
- [ ] Memory training mode (recall previous steps)
- [ ] Timed challenges (optional, for building speed)
- [ ] Difficulty adjustment based on performance
- [ ] Positive affirmations and encouragement
- [ ] Task confidence ratings (how did you feel?)
- [ ] Guided breathing/calm moments between tasks
- [ ] Success journaling

### Phase 4: Personalization & Accessibility
- [ ] Custom task lists (add your own tasks)
- [ ] Task notes and personal tips
- [ ] Voice guidance for steps
- [ ] Audio feedback option
- [ ] Adjustable text size and contrast
- [ ] Speed control (fast/medium/slow pace)
- [ ] Preferred learning style settings

### Phase 5: Caregiver & Support Features
- [ ] Share progress with caregivers/therapists
- [ ] Caregiver dashboard for monitoring
- [ ] Photo documentation of completed tasks
- [ ] Multi-user support (family accounts)
- [ ] Weekly progress reports via email
- [ ] Task suggestions based on skill level
- [ ] Professional therapist notes section

### Phase 6: Advanced Learning Features
- [ ] Task dependencies (unlock harder tasks)
- [ ] Skill tree visualization
- [ ] Social features (opt-in community)
- [ ] Video demonstrations for complex tasks
- [ ] AR/Camera assistance for task guidance
- [ ] Voice commands for hands-free operation
- [ ] Integration with smart home devices

## 💾 Saving Task Completions

When user completes a task, save to Firestore:

```javascript
async function completeTask() {
    const user = window.auth.currentUser;
    if (!user) return;

    const task = tasks[currentDay][currentTaskIndex];

    // Save to Firestore
    await window.setDoc(
        window.doc(window.db, 'users', user.uid, 'completions',
            `day${currentDay}_task${currentTaskIndex}_${Date.now()}`
        ),
        {
            day: currentDay,
            taskIndex: currentTaskIndex,
            taskName: task.name,
            completedAt: new Date().toISOString(),
            stepCount: task.steps.length
        }
    );
}
```

**Data structure in Firestore:**
```
users/
  └── {userId}/
      ├── displayName: "John"
      ├── email: "john@example.com"
      └── completions/
          ├── day1_task0_1729612345678/
          │   ├── day: 1
          │   ├── taskName: "Make Your Bed"
          │   ├── completedAt: "2025-10-22T..."
          │   └── stepCount: 4
          └── day1_task1_1729612456789/
              └── ...
```

## 🔧 Common Commands

```bash
# View current configuration
./show-config.sh

# Run app in simulator
./run-me-first.sh  # → Launch in Simulator

# Sync web to iOS
./run-me-first.sh  # → Sync web to iOS

# Rebuild iOS (after changes)
rm -rf ios/App/build
npx cap sync ios
npx cap open ios

# Increment version
./run-me-first.sh  # → Increment version/build
```

## 🐛 Troubleshooting

### App shows "TacoTalk"
- Files weren't synced properly
- Run: `cp index.html web/index.html && npx cap copy ios`

### Tasks not showing
- Check browser console for errors (F12)
- Verify `tasks` object is defined: `console.log(tasks)`
- Ensure `renderHomeTab()` is called after login

### Firebase errors
- Enable Email/Password in Firebase Console
- Check Firestore security rules
- Verify Firebase config in index.html

### iOS build errors
```bash
# Clean and rebuild
rm -rf ios/App/build
rm -rf ~/Library/Developer/Xcode/DerivedData
npx cap sync ios
# Clean in Xcode: Shift+Cmd+K
```

## 📚 Additional Documentation

- **show-config.sh** - View all current configuration values
- **unified-auth.js** - Username-only authentication system (optional)
- **run-me-first.sh** - Interactive menu for all deployment tasks

## 🔗 Firebase Console Links

- **Project**: https://console.firebase.google.com/project/stepahead-519b0
- **Authentication**: /authentication/users
- **Firestore**: /firestore/data
- **Rules**: /firestore/rules

## 🔒 Security Notes

- API key in code is **safe to expose** (protected by Firebase rules)
- Real security is enforced by Firestore security rules
- Never disable security rules entirely
- Monitor Firebase usage for unexpected activity

## 📧 Support

- **Support**: support@stepahead.app
- **Privacy**: privacy@stepahead.app
- **Developer**: Natraj Bontha

## 🎨 Design Philosophy

### Therapeutic Design Principles

**1. Reduce Cognitive Load**
- One task at a time, one step at a time
- Clear, simple language
- Visual hierarchy with icons and colors
- Minimal distractions

**2. Build Confidence Through Success**
- Start easy (3 tasks) and gradually increase
- Celebrate every step completion
- Progress indicators show achievement
- Positive, encouraging language

**3. Support Different Learning Styles**
- Visual learners: Icons, colors, progress dots
- Sequential learners: Step-by-step breakdown
- Kinesthetic learners: Actionable instructions
- Repetition: Daily practice builds habits

**4. Accessible & Inclusive**
- Large, readable text
- High contrast colors
- Clear navigation
- No time pressure (unless chosen)

**5. Fun & Motivating**
- Playful colors and emojis
- Celebration moments
- Achievement tracking
- Gamification elements (future)

### Color Psychology
- **Primary**: #667eea (Purple/Blue) - Calming, focused, trustworthy
- **Success**: Green - Achievement, growth, positive
- **Accent**: Warm colors for encouragement
- **Background**: Gradient - Visually appealing without distraction

### Design Details
- **Login Icon**: 🏠 (Home = safety, comfort)
- **Task Icons**: Relevant emojis for quick recognition
- **Button Style**: Large touch targets, clear labels
- **Progress Dots**: Visual feedback on completion
- **Animations**: Smooth, calming transitions

## ✅ Quick Checklist

Before testing:
- [ ] Firebase Authentication enabled
- [ ] Firestore database created
- [ ] Security rules applied
- [ ] Run `./show-config.sh` (should show 27/27 customized)

Before deploying:
- [ ] Remove bypass login
- [ ] Test real authentication
- [ ] Add privacy policy
- [ ] Test on real device
- [ ] Update app icons

---

**Ready to test?** Run `./run-me-first.sh` and select "🚀 Launch in Simulator"!

Happy building! 🚀
