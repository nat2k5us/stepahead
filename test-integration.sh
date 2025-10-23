#!/bin/bash

echo "🧪 Testing StepAhead Integration"
echo "================================"
echo ""

# Check if required files exist
echo "✓ Checking files..."
test -f index.html && echo "  ✅ index.html exists" || echo "  ❌ index.html missing"
test -f web/index.html && echo "  ✅ web/index.html exists" || echo "  ❌ web/index.html missing"
test -f ios/App/App/public/index.html && echo "  ✅ iOS index.html exists" || echo "  ❌ iOS index.html missing"
echo ""

# Check for task data
echo "✓ Checking task data..."
if grep -q "const tasks = {" index.html; then
    echo "  ✅ Task data found"
    task_count=$(grep -c "Make Your Bed" index.html)
    echo "  ✅ Found $task_count task entries"
else
    echo "  ❌ Task data missing"
fi
echo ""

# Check for functions
echo "✓ Checking functions..."
grep -q "function renderHomeTab()" index.html && echo "  ✅ renderHomeTab() found" || echo "  ❌ renderHomeTab() missing"
grep -q "function showDaysView()" index.html && echo "  ✅ showDaysView() found" || echo "  ❌ showDaysView() missing"
grep -q "function showTasksView" index.html && echo "  ✅ showTasksView() found" || echo "  ❌ showTasksView() missing"
grep -q "function nextStep()" index.html && echo "  ✅ nextStep() found" || echo "  ❌ nextStep() missing"
echo ""

# Check for CSS
echo "✓ Checking CSS..."
grep -q ".day-grid" index.html && echo "  ✅ Day grid styles found" || echo "  ❌ Day grid styles missing"
grep -q ".task-button" index.html && echo "  ✅ Task button styles found" || echo "  ❌ Task button styles missing"
grep -q ".progress-dot" index.html && echo "  ✅ Progress dot styles found" || echo "  ❌ Progress dot styles missing"
echo ""

# Check for initialization
echo "✓ Checking initialization..."
grep -q "renderHomeTab();" index.html && echo "  ✅ renderHomeTab() is called" || echo "  ❌ renderHomeTab() not called"
echo ""

# Check homeTab container
echo "✓ Checking home tab..."
if grep -q 'id="homeTabContent"' index.html; then
    echo "  ✅ homeTabContent container found"
else
    echo "  ❌ homeTabContent container missing"
fi
echo ""

echo "================================"
echo "✅ Integration test complete!"
echo ""
echo "To run the app:"
echo "  python3 -m http.server 8000"
echo "  Then open http://localhost:8000"
echo ""
