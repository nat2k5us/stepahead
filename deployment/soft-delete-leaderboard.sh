#!/bin/bash

# Soft Delete Leaderboard Script
# Marks documents as deleted instead of removing them
# Uses Firebase REST API - no dependencies needed!

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   Soft Delete Leaderboard Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Firebase project configuration
PROJECT_ID="speechtherapy-fa851"
COLLECTION="reading_sessions"
API_KEY="AIzaSyDLgMyx61LAewI3InaKKPOneXV3pMFrxvk"

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found!${NC}"
    echo ""
    echo "Install it with:"
    echo "  npm install -g firebase-tools"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Firebase CLI found${NC}"
echo ""

# Login check
echo "Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Firebase${NC}"
    echo ""
    echo "Logging in..."
    firebase login
fi

echo -e "${GREEN}✅ Authenticated${NC}"
echo ""

# Ask what to reset
echo -e "${BLUE}What do you want to reset?${NC}"
echo ""
echo "  1) 📅 DAILY   - Mark entries from last 24 hours as deleted"
echo "  2) 📆 WEEKLY  - Mark entries from last 7 days as deleted"
echo "  3) 🗑️  ALL     - Mark ALL entries as deleted (except top 25)"
echo "  4) 💀 EVERYTHING - Mark EVERYTHING as deleted (no protection)"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        RESET_TYPE="DAILY"
        TIMEFRAME="24 hours"
        CUTOFF_MS=$((24 * 60 * 60 * 1000))
        ;;
    2)
        RESET_TYPE="WEEKLY"
        TIMEFRAME="7 days"
        CUTOFF_MS=$((7 * 24 * 60 * 60 * 1000))
        ;;
    3)
        RESET_TYPE="ALL"
        TIMEFRAME="all time (keeping top 25)"
        CUTOFF_MS=0
        ;;
    4)
        RESET_TYPE="EVERYTHING"
        TIMEFRAME="EVERYTHING"
        CUTOFF_MS=0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}⚠️  Soft Delete ${RESET_TYPE} leaderboard${NC}"
echo ""
if [ "$RESET_TYPE" = "EVERYTHING" ]; then
    echo -e "${RED}This will mark ALL leaderboard entries as deleted!${NC}"
    echo -e "${RED}NO ENTRIES WILL BE PROTECTED!${NC}"
elif [ "$RESET_TYPE" = "ALL" ]; then
    echo "This will mark all entries as deleted EXCEPT the top 25 all-time leaders"
else
    echo "This will mark entries from the last ${TIMEFRAME} as deleted"
    echo "Top 25 all-time leaders will be preserved"
fi
echo ""
echo "  Project: ${PROJECT_ID}"
echo "  Collection: ${COLLECTION}"
echo ""
echo -e "${BLUE}Note: Documents are marked as 'deleted', not removed${NC}"
echo ""

if [ "$RESET_TYPE" = "EVERYTHING" ]; then
    read -p "Type 'DELETE_EVERYTHING' to confirm: " confirmation
    if [ "$confirmation" != "DELETE_EVERYTHING" ]; then
        echo -e "${YELLOW}❌ Cancelled${NC}"
        exit 0
    fi
else
    read -p "Type 'RESET' to confirm: " confirmation
    if [ "$confirmation" != "RESET" ]; then
        echo -e "${YELLOW}❌ Cancelled${NC}"
        exit 0
    fi
fi

echo ""
echo -e "${YELLOW}Starting soft delete...${NC}"
echo ""

# Fetch all documents
echo "📡 Fetching all leaderboard entries..."
RESPONSE=$(curl -s "https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}?pageSize=1000&key=${API_KEY}")

# Save response to temp file
TEMP_RESPONSE=$(mktemp)
echo "$RESPONSE" > "$TEMP_RESPONSE"

# Parse and determine which to mark as deleted
python3 << EOPYTHON
import sys, json

try:
    with open('$TEMP_RESPONSE', 'r') as f:
        data = json.load(f)

    if 'documents' not in data:
        print("${YELLOW}ℹ️  No documents found${NC}")
        sys.exit(0)

    docs = data['documents']
    print(f"${GREEN}✅ Found {len(docs)} documents${NC}")
    print()

    reset_type = '$RESET_TYPE'
    cutoff_ms = $CUTOFF_MS
    now_ms = $(date +%s)000

    to_mark = []

    if reset_type == 'EVERYTHING':
        to_mark = docs
    elif reset_type == 'DAILY' or reset_type == 'WEEKLY':
        # Get top 25 by score
        docs_with_score = []
        for doc in docs:
            fields = doc.get('fields', {})
            score = int(fields.get('score', {}).get('integerValue', 0))
            timestamp = int(fields.get('timestamp', {}).get('integerValue', 0))
            docs_with_score.append({
                'doc': doc,
                'score': score,
                'timestamp': timestamp,
                'id': doc['name'].split('/')[-1]
            })

        sorted_docs = sorted(docs_with_score, key=lambda x: x['score'], reverse=True)
        top25_ids = set(d['id'] for d in sorted_docs[:25])

        # Mark entries in timeframe that aren't in top 25
        for d in docs_with_score:
            age = now_ms - d['timestamp']
            if age <= cutoff_ms and d['id'] not in top25_ids:
                to_mark.append(d['doc'])
    elif reset_type == 'ALL':
        # Keep only top 25
        docs_with_score = []
        for doc in docs:
            fields = doc.get('fields', {})
            score = int(fields.get('score', {}).get('integerValue', 0))
            docs_with_score.append({'doc': doc, 'score': score})

        sorted_docs = sorted(docs_with_score, key=lambda x: x['score'], reverse=True)
        to_mark = [d['doc'] for d in sorted_docs[25:]]

    print(f"${YELLOW}🏷️  Will mark as deleted: {len(to_mark)} documents${NC}")
    print(f"${GREEN}✅ Will keep visible: {len(docs) - len(to_mark)} documents${NC}")
    print()

    # Save doc names for marking
    with open('/tmp/docs_to_mark.txt', 'w') as f:
        for doc in to_mark:
            f.write(doc['name'] + '\n')

except Exception as e:
    print(f"${RED}❌ Error: {e}${NC}")
    sys.exit(1)
EOPYTHON

if [ $? -ne 0 ]; then
    rm -f "$TEMP_RESPONSE"
    exit 1
fi

# Check if we have any documents to mark
if [ ! -f /tmp/docs_to_mark.txt ]; then
    echo -e "${YELLOW}ℹ️  No documents to mark${NC}"
    rm -f "$TEMP_RESPONSE"
    exit 0
fi

DOC_COUNT=$(wc -l < /tmp/docs_to_mark.txt | tr -d ' ')

if [ "$DOC_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}ℹ️  No documents to mark${NC}"
    rm -f "$TEMP_RESPONSE" /tmp/docs_to_mark.txt
    exit 0
fi

echo ""
echo -e "${YELLOW}🏷️  Marking ${DOC_COUNT} documents as deleted...${NC}"
echo ""

MARKED=0
FAILED=0

while IFS= read -r doc_name; do
    DOC_ID=$(basename "$doc_name")

    # Update document to add 'deleted: true' field
    UPDATE_URL="https://firestore.googleapis.com/v1/${doc_name}?updateMask.fieldPaths=deleted&key=${API_KEY}"

    UPDATE_DATA='{
      "fields": {
        "deleted": {
          "booleanValue": true
        }
      }
    }'

    HTTP_CODE=$(curl -s -o /tmp/update_response.txt -w "%{http_code}" \
        -X PATCH "$UPDATE_URL" \
        -H "Content-Type: application/json" \
        -d "$UPDATE_DATA")

    if [ "$HTTP_CODE" = "200" ]; then
        ((MARKED++))
        echo -e "  ${GREEN}✅ [${MARKED}/${DOC_COUNT}] Marked: ${DOC_ID}${NC}"
    else
        ((FAILED++))
        echo -e "  ${RED}❌ Failed: ${DOC_ID} (HTTP ${HTTP_CODE})${NC}"
    fi

    sleep 0.05

done < /tmp/docs_to_mark.txt

# Clean up
rm -f "$TEMP_RESPONSE" /tmp/docs_to_mark.txt /tmp/update_response.txt

echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}✅ Soft Delete Complete!${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""
echo "Summary:"
echo "  Total documents processed: ${DOC_COUNT}"
echo "  Successfully marked: ${MARKED}"
echo "  Failed: ${FAILED}"
echo ""

if [ "$FAILED" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Some updates failed${NC}"
    echo ""
fi

echo -e "${GREEN}✅ Leaderboard has been soft-deleted!${NC}"
echo -e "${BLUE}ℹ️  Update your app to filter out documents where deleted=true${NC}"
echo ""
