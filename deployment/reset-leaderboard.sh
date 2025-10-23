#!/bin/bash

# Reset Leaderboard Script
# Simple version using Firestore REST API (no auth required when rules allow)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   Leaderboard Reset Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Firebase project configuration
PROJECT_ID="speechtherapy-fa851"
COLLECTION="reading_sessions"

# Confirmation
echo -e "${RED}⚠️  WARNING: This will DELETE ALL leaderboard entries!${NC}"
echo -e "${RED}This will permanently remove all data from ${COLLECTION}!${NC}"
echo ""
echo "  Project: ${PROJECT_ID}"
echo "  Collection: ${COLLECTION}"
echo ""
echo -e "${YELLOW}This action CANNOT be undone!${NC}"
echo ""

read -p "Type 'DELETE_EVERYTHING' to confirm: " confirmation

if [ "$confirmation" != "DELETE_EVERYTHING" ]; then
    echo -e "${YELLOW}❌ Cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Starting deletion...${NC}"
echo ""

# Create a temporary Node.js script to delete documents
TEMP_SCRIPT=$(mktemp).js

cat > "$TEMP_SCRIPT" << 'EOJS'
const https = require('https');

const PROJECT_ID = 'speechtherapy-fa851';
const COLLECTION = 'reading_sessions';

async function fetchDocuments() {
  const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}?pageSize=1000`;

  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

async function deleteDocument(docPath) {
  const url = `https://firestore.googleapis.com/v1/${docPath}`;

  return new Promise((resolve, reject) => {
    const options = {
      method: 'DELETE'
    };

    const req = https.request(url, options, (res) => {
      resolve(res.statusCode);
    });

    req.on('error', reject);
    req.end();
  });
}

async function main() {
  console.log(`📡 Fetching documents from ${COLLECTION}...`);

  let response;
  try {
    response = await fetchDocuments();
  } catch (error) {
    console.error('\x1b[31m❌ Error fetching documents:', error.message, '\x1b[0m');
    process.exit(1);
  }

  if (!response.documents || response.documents.length === 0) {
    console.log('\x1b[33mℹ️  No documents found in collection\x1b[0m');
    return;
  }

  const docs = response.documents;
  console.log(`\x1b[32m✅ Found ${docs.length} documents\x1b[0m\n`);
  console.log('🗑️  Deleting documents...\n');

  let deleted = 0;
  let failed = 0;
  const MAX_CONSECUTIVE_FAILURES = 3;
  let consecutiveFailures = 0;

  for (const doc of docs) {
    const docPath = doc.name;
    const docId = docPath.split('/').pop();

    try {
      const statusCode = await deleteDocument(docPath);

      if (statusCode === 200 || statusCode === 204) {
        deleted++;
        consecutiveFailures = 0;
        console.log(`  \x1b[32m✅ [${deleted}/${docs.length}] Deleted: ${docId}\x1b[0m`);
      } else {
        failed++;
        consecutiveFailures++;
        console.log(`  \x1b[31m❌ Failed: ${docId} (HTTP ${statusCode})\x1b[0m`);

        if (consecutiveFailures >= MAX_CONSECUTIVE_FAILURES) {
          console.log(`\n\x1b[31m❌ Stopping: ${MAX_CONSECUTIVE_FAILURES} consecutive failures\x1b[0m`);
          if (statusCode === 403) {
            console.log(`\x1b[33m⚠️  Permission denied!\x1b[0m`);
            console.log(`\x1b[33m⚠️  Make sure Firestore rules allow 'write: if true' temporarily\x1b[0m`);
          }
          process.exit(1);
        }
      }
    } catch (error) {
      failed++;
      consecutiveFailures++;
      console.log(`  \x1b[31m❌ Error: ${docId}: ${error.message}\x1b[0m`);

      if (consecutiveFailures >= MAX_CONSECUTIVE_FAILURES) {
        console.log(`\n\x1b[31m❌ Stopping: ${MAX_CONSECUTIVE_FAILURES} consecutive failures\x1b[0m`);
        process.exit(1);
      }
    }

    await new Promise(resolve => setTimeout(resolve, 50));
  }

  console.log('\n\x1b[33m========================================\x1b[0m');
  console.log('\x1b[32m✅ Deletion Complete!\x1b[0m');
  console.log('\x1b[33m========================================\x1b[0m\n');
  console.log(`Summary:`);
  console.log(`  Total: ${docs.length}`);
  console.log(`  Deleted: ${deleted}`);
  console.log(`  Failed: ${failed}\n`);

  if (failed > 0) {
    console.log(`\x1b[33m⚠️  Some deletions failed - check Firestore rules\x1b[0m\n`);
    process.exit(1);
  }

  process.exit(0);
}

main().catch(error => {
  console.error('\x1b[31m❌ Error:', error.message, '\x1b[0m');
  process.exit(1);
});
EOJS

# Run the Node.js script
node "$TEMP_SCRIPT"
EXIT_CODE=$?

# Clean up
rm -f "$TEMP_SCRIPT"

echo ""
if [ $EXIT_CODE -ne 0 ]; then
    echo -e "${RED}❌ Deletion failed${NC}"
    echo ""
    echo -e "${YELLOW}💡 Make sure you temporarily changed Firestore rules to:${NC}"
    echo -e "${YELLOW}   allow write: if true;  // TEMPORARY${NC}"
    echo ""
    echo -e "${YELLOW}   Then change it back after the reset!${NC}"
fi

echo ""
