#!/usr/bin/env node

/**
 * Create Test Task Data in Firestore
 *
 * This script creates sample task completion records with full audit trail
 * and metric data to test the History tab and performance tracking.
 */

const { initializeApp } = require('firebase/app');
const { getAuth, signInWithEmailAndPassword } = require('firebase/auth');
const { getFirestore, collection, doc, setDoc, Timestamp } = require('firebase/firestore');

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDpD1Vv3WsRjB2g7zZjohO3I24sMJsHLGw",
  authDomain: "stepahead-519b0.firebaseapp.com",
  projectId: "stepahead-519b0",
  storageBucket: "stepahead-519b0.firebasestorage.app",
  messagingSenderId: "335105043215",
  appId: "1:335105043215:web:stepahead"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

// Sample task completion data
const sampleTaskCompletions = [
  {
    taskName: "Make Your Bed",
    taskIcon: "🛏️",
    dayOfWeek: 1, // Monday
    stepTimes: [28.5, 19.2, 14.8, 9.5], // Actual time for each step (seconds)
    estimatedTimes: [30, 20, 15, 10], // Expected time for each step
    totalScore: 95,
    completedAt: new Date().toISOString(),
    daysAgo: 0 // Today
  },
  {
    taskName: "Make Your Bed",
    taskIcon: "🛏️",
    dayOfWeek: 1,
    stepTimes: [35.2, 22.1, 17.3, 12.8],
    estimatedTimes: [30, 20, 15, 10],
    totalScore: 85,
    completedAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
    daysAgo: 1 // Yesterday
  },
  {
    taskName: "Make Your Bed",
    taskIcon: "🛏️",
    dayOfWeek: 1,
    stepTimes: [32.0, 18.5, 15.2, 10.3],
    estimatedTimes: [30, 20, 15, 10],
    totalScore: 92,
    completedAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
    daysAgo: 2 // 2 days ago
  },
  {
    taskName: "Wash Your Breakfast Dishes",
    taskIcon: "🍽️",
    dayOfWeek: 1,
    stepTimes: [18.2, 9.5, 14.1, 55.3, 28.7, 19.2],
    estimatedTimes: [20, 10, 15, 60, 30, 20],
    totalScore: 98,
    completedAt: new Date().toISOString(),
    daysAgo: 0
  },
  {
    taskName: "Wash Your Breakfast Dishes",
    taskIcon: "🍽️",
    dayOfWeek: 1,
    stepTimes: [22.5, 11.2, 16.8, 68.1, 35.2, 23.4],
    estimatedTimes: [20, 10, 15, 60, 30, 20],
    totalScore: 82,
    completedAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
    daysAgo: 1
  },
  {
    taskName: "Water One Plant",
    taskIcon: "🌱",
    dayOfWeek: 1,
    stepTimes: [14.2, 28.5, 18.9, 29.1, 9.3],
    estimatedTimes: [15, 30, 20, 30, 10],
    totalScore: 97,
    completedAt: new Date().toISOString(),
    daysAgo: 0
  },
  {
    taskName: "Water One Plant",
    taskIcon: "🌱",
    dayOfWeek: 1,
    stepTimes: [18.5, 35.2, 25.1, 38.7, 12.5],
    estimatedTimes: [15, 30, 20, 30, 10],
    totalScore: 78,
    completedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
    daysAgo: 3
  },
  {
    taskName: "Take Out the Trash",
    taskIcon: "🗑️",
    dayOfWeek: 2, // Tuesday
    stepTimes: [25.3, 32.1, 45.8, 28.2, 35.7, 22.1],
    estimatedTimes: [30, 30, 60, 30, 30, 30],
    totalScore: 88,
    completedAt: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000).toISOString(),
    daysAgo: 6
  },
  {
    taskName: "Organize Desk",
    taskIcon: "⭐",
    dayOfWeek: 1,
    stepTimes: [58.3], // Bonus task - 1 step
    estimatedTimes: [60],
    totalScore: 100,
    completedAt: new Date().toISOString(),
    daysAgo: 0,
    isBonus: true
  }
];

async function createTestData() {
  console.log('\n🔥 Creating Test Task Data in Firestore\n');
  console.log('=====================================\n');

  // Get user email from command line or use default
  const userEmail = process.argv[2] || 'voidydude@gmail.com';
  const userPassword = process.argv[3];

  if (!userPassword) {
    console.error('❌ Error: Password required\n');
    console.log('Usage: node create-test-task-data.js <email> <password>');
    console.log('Example: node create-test-task-data.js voidydude@gmail.com mypassword\n');
    process.exit(1);
  }

  try {
    // Sign in
    console.log(`🔐 Signing in as: ${userEmail}`);
    const userCredential = await signInWithEmailAndPassword(auth, userEmail, userPassword);
    const user = userCredential.user;
    console.log(`✅ Signed in successfully (UID: ${user.uid})\n`);

    // Create task completions
    console.log('📝 Creating task completion records...\n');

    let successCount = 0;
    let errorCount = 0;

    for (const taskData of sampleTaskCompletions) {
      try {
        // Calculate total times
        const totalTime = taskData.stepTimes.reduce((sum, time) => sum + time, 0);
        const estimatedTotal = taskData.estimatedTimes.reduce((sum, time) => sum + time, 0);

        // Create timestamp
        const completedDate = new Date(taskData.completedAt);
        const timestamp = Timestamp.fromDate(completedDate);

        // Create unique document ID
        const docId = `${timestamp.seconds}_${taskData.dayOfWeek}_${taskData.taskName.replace(/\s+/g, '_')}`;

        // Full task completion document
        const taskCompletion = {
          taskName: taskData.taskName,
          taskIcon: taskData.taskIcon,
          dayOfWeek: taskData.dayOfWeek,
          stepTimes: taskData.stepTimes,
          estimatedTimes: taskData.estimatedTimes,
          totalTime: totalTime,
          estimatedTotal: estimatedTotal,
          totalScore: taskData.totalScore,
          completedAt: taskData.completedAt,
          timestamp: timestamp,
          userId: user.uid,
          userEmail: user.email,
          ...(taskData.isBonus && { isBonus: true })
        };

        // Save to Firestore
        const taskRef = doc(db, 'users', user.uid, 'taskHistory', docId);
        await setDoc(taskRef, taskCompletion);

        const bonusBadge = taskData.isBonus ? ' ⭐ BONUS' : '';
        const daysAgoText = taskData.daysAgo === 0 ? 'today' :
                           taskData.daysAgo === 1 ? 'yesterday' :
                           `${taskData.daysAgo} days ago`;

        console.log(`  ✅ ${taskData.taskIcon} ${taskData.taskName}${bonusBadge}`);
        console.log(`     Score: ${taskData.totalScore}/100 | Time: ${totalTime.toFixed(1)}s / ${estimatedTotal}s`);
        console.log(`     Completed: ${daysAgoText}`);
        console.log(`     Steps: ${taskData.stepTimes.length} | Doc ID: ${docId}`);
        console.log('');

        successCount++;
      } catch (error) {
        console.error(`  ❌ Failed to create ${taskData.taskName}: ${error.message}\n`);
        errorCount++;
      }
    }

    console.log('=====================================\n');
    console.log(`✅ Created ${successCount} task completion records`);
    if (errorCount > 0) {
      console.log(`❌ Failed to create ${errorCount} records`);
    }
    console.log('');

    // Summary by task
    console.log('📊 Summary by Task:\n');
    const taskGroups = {};
    sampleTaskCompletions.forEach(task => {
      if (!taskGroups[task.taskName]) {
        taskGroups[task.taskName] = { count: 0, avgScore: 0, icon: task.taskIcon };
      }
      taskGroups[task.taskName].count++;
      taskGroups[task.taskName].avgScore += task.totalScore;
    });

    Object.entries(taskGroups).forEach(([name, data]) => {
      const avg = Math.round(data.avgScore / data.count);
      console.log(`  ${data.icon} ${name}`);
      console.log(`     Completed ${data.count} time${data.count > 1 ? 's' : ''} | Avg Score: ${avg}/100`);
      console.log('');
    });

    console.log('=====================================\n');
    console.log('🎉 Test data created successfully!\n');
    console.log('Next steps:');
    console.log('  1. Open the app');
    console.log('  2. Go to History tab');
    console.log('  3. You should see task completion data');
    console.log('  4. Click a task to see the multi-line graph\n');

    console.log('Firestore Console:');
    console.log(`  https://console.firebase.google.com/project/stepahead-519b0/firestore/data/~2Fusers~2F${user.uid}~2FtaskHistory\n`);

    process.exit(0);

  } catch (error) {
    console.error('\n❌ Error:', error.message);
    console.error('');

    if (error.code === 'auth/wrong-password' || error.code === 'auth/user-not-found') {
      console.log('💡 Tip: Check your email and password');
    } else if (error.code === 'auth/invalid-email') {
      console.log('💡 Tip: Use a valid email format');
    } else if (error.code === 'permission-denied') {
      console.log('💡 Tip: Run ./deployment/fix-task-history-rules.sh to fix Firestore permissions');
    }

    console.log('');
    process.exit(1);
  }
}

// Run the script
createTestData();
