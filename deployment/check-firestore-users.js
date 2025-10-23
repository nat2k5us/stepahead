#!/usr/bin/env node

// Check Firestore users collection
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyDpD1Vv3WsRjB2g7zZjohO3I24sMJsHLGw",
  authDomain: "stepahead-519b0.firebaseapp.com",
  projectId: "stepahead-519b0",
  storageBucket: "stepahead-519b0.firebasestorage.app",
  messagingSenderId: "335105043215",
  appId: "1:335105043215:web:stepahead"
};

console.log('🔍 Checking Firestore users collection...\n');

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

try {
  const usersRef = collection(db, 'users');
  const snapshot = await getDocs(usersRef);

  if (snapshot.empty) {
    console.log('❌ No users found in Firestore');
    console.log('\nThis means:');
    console.log('  1. Users are signing up but Firestore writes are failing');
    console.log('  2. OR Firestore Security Rules are blocking writes');
    console.log('  3. OR users only exist in Firebase Auth, not Firestore\n');
  } else {
    console.log(`✅ Found ${snapshot.size} user(s) in Firestore:\n`);
    snapshot.forEach(doc => {
      console.log(`User ID: ${doc.id}`);
      console.log(`Data:`, doc.data());
      console.log('---');
    });
  }

  process.exit(0);
} catch (error) {
  console.error('❌ Error reading Firestore:', error.message);

  if (error.code === 'permission-denied') {
    console.log('\n⚠️  PERMISSION DENIED');
    console.log('Your Firestore Security Rules are blocking reads.');
    console.log('Check rules at: https://console.firebase.google.com/project/stepahead-519b0/firestore/rules');
  }

  process.exit(1);
}
