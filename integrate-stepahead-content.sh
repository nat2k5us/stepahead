#!/bin/bash
# This script integrates the StepAhead task content into the template's home tab
# while preserving the authentication and navigation structure

set -e

echo "Integrating StepAhead content into the template..."

# First, let's extract the CSS and JavaScript from stepahead.html
# and create a modified index.html with the task functionality

cat > /tmp/stepahead-styles.css << 'EOF'
/* StepAhead Task Styles */
.day-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 15px;
    padding: 10px;
}

.day-button {
    padding: 30px;
    font-size: 1.5rem;
    font-weight: bold;
    background: white;
    border: none;
    border-radius: 15px;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    transition: transform 0.2s, box-shadow 0.2s;
    color: #667eea;
    text-align: center;
}

.day-button:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
}

.task-grid {
    display: grid;
    gap: 15px;
}

.task-button {
    padding: 20px;
    background: white;
    border: none;
    border-radius: 15px;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    transition: transform 0.2s;
    text-align: left;
    display: flex;
    align-items: center;
    gap: 15px;
}

.task-button:hover {
    transform: translateY(-3px);
}

.task-icon {
    font-size: 2.5rem;
}

.task-info {
    flex: 1;
}

.task-title {
    font-size: 1.3rem;
    font-weight: bold;
    color: #333;
    margin-bottom: 5px;
}

.task-steps {
    font-size: 1rem;
    color: #666;
}

.task-view {
    padding: 20px;
    padding-bottom: 100px;
}

.task-card {
    background: white;
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    text-align: center;
}

.task-emoji {
    font-size: 4rem;
    margin-bottom: 15px;
}

.task-name {
    font-size: 2rem;
    color: #333;
    margin-bottom: 20px;
}

.step-counter {
    font-size: 1.1rem;
    color: #666;
    margin-bottom: 30px;
}

.step-box {
    background: #f8f9fa;
    padding: 30px;
    border-radius: 15px;
    margin-bottom: 30px;
    min-height: 120px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.step-text {
    font-size: 1.5rem;
    color: #333;
    line-height: 1.6;
}

.progress-dots {
    display: flex;
    gap: 10px;
    margin-bottom: 25px;
    justify-content: center;
    flex-wrap: wrap;
}

.progress-dot {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background: #ddd;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1rem;
    font-weight: bold;
}

.progress-dot.completed {
    background: #4CAF50;
}

.button-group {
    display: flex;
    gap: 15px;
    justify-content: center;
    flex-wrap: wrap;
}

.nav-button {
    padding: 15px 30px;
    font-size: 1.2rem;
    color: white;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.nav-button.prev {
    background: #6c757d;
}

.nav-button.next {
    background: #007bff;
}

.nav-button.complete {
    background: #28a745;
    animation: pulse 1.5s infinite;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

.back-button {
    padding: 12px 24px;
    font-size: 1rem;
    background: white;
    color: #667eea;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    margin-bottom: 20px;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    font-weight: 600;
}

.task-count {
    font-size: 0.9rem;
    margin-top: 8px;
    color: #666;
}
EOF

echo "✅ StepAhead styles extracted"
echo ""
echo "Now you need to manually integrate the content:"
echo ""
echo "1. Add the CSS from /tmp/stepahead-styles.css to index.html <style> section"
echo "2. Replace the homeTab content with the StepAhead day grid"
echo "3. Add the task data and JavaScript functions from stepahead.html"
echo ""
echo "I'll create a detailed integration guide next..."

