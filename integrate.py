#!/usr/bin/env python3
"""
This script integrates the StepAhead task functionality from stepahead.html
into the template's index.html, replacing the home tab content while keeping
authentication and all other template features.
"""

# Read the stepahead.html content
with open('stepahead.html', 'r') as f:
    stepahead_content = f.read()

# Read the template index.html
with open('index.html', 'r') as f:
    template_content = f.read()

# Extract the task data and functions from stepahead.html
# Find the <script> section with task data
import re

# Extract task data
task_data_match = re.search(r'const tasks = \{[\s\S]*?\};', stepahead_content)
task_data = task_data_match.group(0) if task_data_match else ""

# Extract all the StepAhead functions
stepahead_functions = """
        // StepAhead Task Management
        let currentDay = null;
        let currentTaskIndex = null;
        let currentStep = 0;
        let currentView = 'days'; // 'days', 'tasks', or 'task'

        function showDaysView() {
            currentView = 'days';
            currentDay = null;
            currentTaskIndex = null;
            currentStep = 0;
            renderHomeTab();
        }

        function showTasksView(day) {
            currentView = 'tasks';
            currentDay = day;
            currentTaskIndex = null;
            currentStep = 0;
            renderHomeTab();
        }

        function showTaskView(taskIndex) {
            currentView = 'task';
            currentTaskIndex = taskIndex;
            currentStep = 0;
            renderHomeTab();
        }

        function nextStep() {
            const task = tasks[currentDay][currentTaskIndex];
            if (currentStep < task.steps.length - 1) {
                currentStep++;
                renderHomeTab();
            }
        }

        function prevStep() {
            if (currentStep > 0) {
                currentStep--;
                renderHomeTab();
            }
        }

        function completeTask() {
            // TODO: Save completion to Firebase for the logged-in user
            alert('Great job! Task completed! 🎉');
            showTasksView(currentDay);
        }

        function renderHomeTab() {
            const homeTab = document.getElementById('homeTab');
            let html = '<div class="p-4" style="padding-bottom: 100px;">';

            if (currentView === 'days') {
                // Show day selector
                html += `
                    <h2 class="text-3xl font-bold mb-2 text-white text-center" style="text-shadow: 2px 2px 4px rgba(0,0,0,0.2);">🏠 My Daily Tasks</h2>
                    <p class="text-white text-center mb-6 opacity-90">Choose a day to see your tasks</p>
                    <div class="day-grid">
                `;
                for (let day = 1; day <= 7; day++) {
                    html += `
                        <button class="day-button" onclick="showTasksView(${day})">
                            <div>📅</div>
                            <div style="margin-top: 10px;">Day ${day}</div>
                            <div class="task-count">${tasks[day].length} tasks</div>
                        </button>
                    `;
                }
                html += '</div>';

            } else if (currentView === 'tasks') {
                // Show task list for selected day
                const dayTasks = tasks[currentDay];
                html += `
                    <button class="back-button" onclick="showDaysView()">← Back to Days</button>
                    <h2 class="text-3xl font-bold mb-2 text-white text-center" style="text-shadow: 2px 2px 4px rgba(0,0,0,0.2);">📅 Day ${currentDay}</h2>
                    <p class="text-white text-center mb-6 opacity-90">You have ${dayTasks.length} tasks today</p>
                    <div class="task-grid">
                `;
                dayTasks.forEach((task, index) => {
                    html += `
                        <button class="task-button" onclick="showTaskView(${index})">
                            <div class="task-icon">${task.icon}</div>
                            <div class="task-info">
                                <div class="task-title">Task ${index + 1}: ${task.name}</div>
                                <div class="task-steps">${task.steps.length} steps</div>
                            </div>
                        </button>
                    `;
                });
                html += '</div>';

            } else if (currentView === 'task') {
                // Show individual task with steps
                const task = tasks[currentDay][currentTaskIndex];
                html += `
                    <button class="back-button" onclick="showTasksView(${currentDay})">← Back to Day ${currentDay}</button>
                    <div class="task-view">
                        <div class="task-card" style="background-color: ${task.color};">
                            <div class="task-emoji">${task.icon}</div>
                            <h1 class="task-name">${task.name}</h1>
                            <div class="step-counter">Step ${currentStep + 1} of ${task.steps.length}</div>
                            <div class="step-box">
                                <p class="step-text">${task.steps[currentStep]}</p>
                            </div>
                            <div class="progress-dots">
                `;
                for (let i = 0; i < task.steps.length; i++) {
                    const completed = i <= currentStep ? 'completed' : '';
                    const content = i <= currentStep ? '✓' : (i + 1);
                    html += `<div class="progress-dot ${completed}">${content}</div>`;
                }
                html += `
                            </div>
                            <div class="button-group">
                `;
                if (currentStep > 0) {
                    html += '<button class="nav-button prev" onclick="prevStep()">← Previous</button>';
                }
                if (currentStep < task.steps.length - 1) {
                    html += '<button class="nav-button next" onclick="nextStep()">Next →</button>';
                } else {
                    html += '<button class="nav-button complete" onclick="completeTask()">✓ Task Complete! 🎉</button>';
                }
                html += `
                            </div>
                        </div>
                    </div>
                `;
            }

            html += '</div>';
            homeTab.innerHTML = html;
        }
"""

# Extract StepAhead CSS
stepahead_css_match = re.search(r'<style>([\s\S]*?)</style>', stepahead_content)
stepahead_css = stepahead_css_match.group(1) if stepahead_css_match else ""

# Filter out only the StepAhead-specific styles we need
stepahead_specific_css = """
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
"""

print("✅ Extracted StepAhead components")
print("")
print("StepAhead CSS length:", len(stepahead_specific_css))
print("StepAhead Functions length:", len(stepahead_functions))
print("Task Data length:", len(task_data))
print("")
print("Components ready for integration!")
