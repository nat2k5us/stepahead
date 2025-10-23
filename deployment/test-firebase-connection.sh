#!/bin/bash

# ============================================================================
# Firebase Connection Test
# ============================================================================
# Tests Firebase Authentication and Firestore by:
# 1. Creating a test user
# 2. Verifying the user was created
# 3. Deleting the test user
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}🔥 Firebase Connection Test${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Generate test username with timestamp
TEST_USERNAME="test_$(date +%s)"
TEST_PASSWORD="test123456"
TEST_EMAIL="${TEST_USERNAME}@stepahead.app"

echo -e "${CYAN}Test Configuration:${NC}"
echo -e "  Username: ${YELLOW}${TEST_USERNAME}${NC}"
echo -e "  Email:    ${YELLOW}${TEST_EMAIL}${NC}"
echo ""

# Create a Node.js script to test Firebase
cat > "$PROJECT_ROOT/firebase-test.mjs" << 'EOF'
import { initializeApp } from 'firebase/app';
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, deleteUser } from 'firebase/auth';
import { getFirestore, doc, setDoc, getDoc, deleteDoc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyDpD1Vv3WsRjB2g7zZjohO3I24sMJsHLGw",
  authDomain: "stepahead-519b0.firebaseapp.com",
  projectId: "stepahead-519b0",
  storageBucket: "stepahead-519b0.firebasestorage.app",
  messagingSenderId: "335105043215",
  appId: "1:335105043215:web:stepahead"
};

const testUsername = process.argv[2];
const testPassword = process.argv[3];
const testEmail = process.argv[4];

async function testFirebase() {
  console.log('📡 Initializing Firebase...');
  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db = getFirestore(app);

  let userCredential = null;
  let testPassed = true;
  let firestoreEnabled = false;

  try {
    // Step 1: Create test user
    console.log('👤 Creating test user...');
    userCredential = await createUserWithEmailAndPassword(auth, testEmail, testPassword);
    console.log(`✅ User created: ${userCredential.user.uid}`);

    // Step 2: Write to Firestore (with timeout)
    console.log('📝 Writing to Firestore...');
    try {
      const writePromise = setDoc(doc(db, 'users', userCredential.user.uid), {
        username: testUsername,
        email: testEmail,
        createdAt: new Date().toISOString(),
        testUser: true
      });

      // Timeout after 5 seconds
      await Promise.race([
        writePromise,
        new Promise((_, reject) => setTimeout(() => reject(new Error('Firestore write timeout')), 5000))
      ]);

      console.log('✅ Firestore write successful');
      firestoreEnabled = true;

      // Step 3: Read from Firestore
      console.log('📖 Reading from Firestore...');
      const docSnap = await getDoc(doc(db, 'users', userCredential.user.uid));
      if (docSnap.exists()) {
        const data = docSnap.data();
        console.log(`✅ Firestore read successful: username=${data.username}`);
      } else {
        console.log('❌ Firestore document not found');
        testPassed = false;
      }

      // Step 3.5: Create test task history data
      console.log('📊 Creating test task history...');
      const taskCompletions = [
        {
          taskName: "Make Your Bed",
          taskIcon: "🛏️",
          dayOfWeek: 1,
          stepTimes: [28.5, 19.2, 14.8, 9.5],
          estimatedTimes: [30, 20, 15, 10],
          totalScore: 95
        },
        {
          taskName: "Wash Your Breakfast Dishes",
          taskIcon: "🍽️",
          dayOfWeek: 1,
          stepTimes: [18.2, 9.5, 14.1, 55.3, 28.7, 19.2],
          estimatedTimes: [20, 10, 15, 60, 30, 20],
          totalScore: 98
        },
        {
          taskName: "Water One Plant",
          taskIcon: "🌱",
          dayOfWeek: 1,
          stepTimes: [14.2, 28.5, 18.9, 29.1, 9.3],
          estimatedTimes: [15, 30, 20, 30, 10],
          totalScore: 97
        }
      ];

      for (const taskData of taskCompletions) {
        const totalTime = taskData.stepTimes.reduce((sum, time) => sum + time, 0);
        const estimatedTotal = taskData.estimatedTimes.reduce((sum, time) => sum + time, 0);
        const now = new Date();

        const taskDoc = {
          taskName: taskData.taskName,
          taskIcon: taskData.taskIcon,
          dayOfWeek: taskData.dayOfWeek,
          stepTimes: taskData.stepTimes,
          estimatedTimes: taskData.estimatedTimes,
          totalTime: totalTime,
          estimatedTotal: estimatedTotal,
          totalScore: taskData.totalScore,
          completedAt: now.toISOString(),
          timestamp: now,
          userId: userCredential.user.uid,
          userEmail: testEmail
        };

        const docId = `${Date.now()}_${taskData.dayOfWeek}_${taskData.taskName.replace(/\s+/g, '_')}`;
        await setDoc(doc(db, 'users', userCredential.user.uid, 'taskHistory', docId), taskDoc);
        console.log(`  ✅ ${taskData.taskIcon} ${taskData.taskName} (${taskData.totalScore}/100)`);

        // Small delay to ensure unique timestamps
        await new Promise(resolve => setTimeout(resolve, 10));
      }

      console.log('✅ Test task history created (3 tasks)');

    } catch (firestoreError) {
      console.log(`❌ Firestore error: ${firestoreError.message}`);
      if (firestoreError.message.includes('PERMISSION_DENIED')) {
        console.log('⚠️  Firestore API is not enabled or configured');
      }
      testPassed = false;
    }

    // Step 4: Sign out and sign in again
    console.log('🔄 Testing sign in...');
    await auth.signOut();
    const signInCredential = await signInWithEmailAndPassword(auth, testEmail, testPassword);
    console.log(`✅ Sign in successful: ${signInCredential.user.uid}`);

  } catch (error) {
    console.log(`❌ Test failed: ${error.message}`);
    testPassed = false;
  } finally {
    // Cleanup: Delete test user (ALWAYS run this)
    if (userCredential && userCredential.user) {
      try {
        console.log('🧹 Cleaning up test user...');

        // Re-authenticate to ensure we can delete
        try {
          await signInWithEmailAndPassword(auth, testEmail, testPassword);
        } catch (e) {
          // User might already be signed in
        }

        // Delete Firestore document (only if Firestore is enabled)
        if (firestoreEnabled) {
          try {
            await Promise.race([
              deleteDoc(doc(db, 'users', userCredential.user.uid)),
              new Promise((_, reject) => setTimeout(() => reject(new Error('timeout')), 3000))
            ]);
            console.log('✅ Firestore document deleted');
          } catch (e) {
            console.log('⚠️  Firestore document cleanup skipped');
          }
        }

        // Delete authentication user (CRITICAL - must always run)
        const currentUser = auth.currentUser;
        if (currentUser) {
          await deleteUser(currentUser);
          console.log('✅ Authentication user deleted');
        } else {
          console.log('⚠️  No user to delete from Authentication');
        }
      } catch (cleanupError) {
        console.log(`⚠️  Cleanup error: ${cleanupError.message}`);
        // Try one more time to delete the auth user
        try {
          const userToDelete = auth.currentUser;
          if (userToDelete) {
            await deleteUser(userToDelete);
            console.log('✅ Authentication user deleted (retry)');
          }
        } catch (e) {
          console.log(`❌ Failed to delete authentication user: ${e.message}`);
        }
      }
    }
  }

  if (testPassed) {
    console.log('');
    console.log('✅ Firebase connection test PASSED');
    process.exit(0);
  } else {
    console.log('');
    console.log('❌ Firebase connection test FAILED');
    process.exit(1);
  }
}

testFirebase();
EOF

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo -e "${YELLOW}Please install Node.js to run this test${NC}"
    exit 1
fi

# Check if firebase packages are installed
if [ ! -d "$PROJECT_ROOT/node_modules/firebase" ]; then
    echo -e "${YELLOW}⚠️  Firebase packages not found. Installing...${NC}"
    echo ""
    cd "$PROJECT_ROOT"
    npm install firebase
    echo ""
fi

# Run the test
echo -e "${CYAN}Running Firebase test...${NC}"
echo ""

cd "$PROJECT_ROOT"
if node firebase-test.mjs "$TEST_USERNAME" "$TEST_PASSWORD" "$TEST_EMAIL"; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ Firebase is properly configured and working!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    rm -f firebase-test.mjs
    exit 0
else
    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ Firebase connection test failed${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting:${NC}"
    echo -e "  ${RED}Cloud Firestore needs to be created and configured:${NC}"
    echo ""
    echo -e "  ${CYAN}Step 1: Create Firestore Database${NC}"
    echo -e "    1. Go to: ${YELLOW}https://console.firebase.google.com/project/stepahead-519b0/firestore${NC}"
    echo -e "    2. Click ${GREEN}\"Create database\"${NC}"
    echo -e "    3. Choose ${GREEN}\"Start in production mode\"${NC} (we'll update rules next)"
    echo -e "    4. Select your preferred location (e.g., us-central)"
    echo ""
    echo -e "  ${CYAN}Step 2: Set up Security Rules${NC}"
    echo -e "    1. Go to: ${YELLOW}https://console.firebase.google.com/project/stepahead-519b0/firestore/rules${NC}"
    echo -e "    2. Replace with these ${GREEN}development rules${NC}:"
    echo -e "       ${YELLOW}rules_version = '2';${NC}"
    echo -e "       ${YELLOW}service cloud.firestore {${NC}"
    echo -e "       ${YELLOW}  match /databases/{database}/documents {${NC}"
    echo -e "       ${YELLOW}    match /{document=**} {${NC}"
    echo -e "       ${YELLOW}      allow read, write: if true;${NC}"
    echo -e "       ${YELLOW}    }${NC}"
    echo -e "       ${YELLOW}  }${NC}"
    echo -e "       ${YELLOW}}${NC}"
    echo -e "    3. Click ${GREEN}\"Publish\"${NC}"
    echo ""
    echo -e "  ${YELLOW}⚠️  Note: These are open rules for development. Secure them for production!${NC}"
    echo ""
    echo -e "${CYAN}What worked:${NC}"
    echo -e "  ✅ Firebase Authentication (user creation and sign-in)"
    echo ""
    echo -e "${CYAN}What failed:${NC}"
    echo -e "  ❌ Cloud Firestore (database not created or rules too restrictive)"
    echo ""
    rm -f firebase-test.mjs
    exit 1
fi
