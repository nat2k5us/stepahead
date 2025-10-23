Great question! Here are practical ways to reduce token usage when working with Claude Code:

## Keep Context Focused

**Use targeted file selection:**
- Only add files that are directly relevant to your task
- Use `claude code remove <file>` to drop files you no longer need
- Avoid adding entire directories when you only need specific files

**Leverage .claudeignore:**
- Create a `.claudeignore` file to automatically exclude unnecessary files (like `node_modules/`, build artifacts, test fixtures, large data files)
- This prevents accidental inclusion of high-token-count files

## Optimize Your Prompts

**Be specific and concise:**
- "Fix the authentication bug in login.ts" uses fewer tokens than lengthy descriptions
- Provide error messages directly rather than asking Claude to figure out what's wrong

**Break down complex tasks:**
- Instead of one massive request, use iterative prompts
- Complete one focused change, then move to the next

## Manage Conversation History

**Start fresh when appropriate:**
- Long conversations accumulate token usage
- If you're switching to an unrelated task, consider starting a new session
- Use `claude code reset` to clear the conversation history

**Summarize instead of re-explaining:**
- Reference previous work briefly rather than repeating full context

## Smart File Handling

**Use diffs efficiently:**
- Claude Code shows file changes as diffs, which are more token-efficient than full file rewrites
- When reviewing changes, you're only seeing what changed, not entire files

**Preview before committing:**
- Review suggested changes to ensure they're on track before continuing

## General Tips

- **Remove verbose output**: If you've added log files or error dumps, remove them once the issue is resolved
- **Use relative paths**: Shorter file references use fewer tokens
- **Leverage tool use**: Claude Code's built-in tools (file operations, shell commands) are more efficient than describing what you want done

The key principle: **keep your context window lean and relevant**. Every file and message in the conversation uses tokens, so regular pruning helps keep costs down while maintaining effectiveness.

How to Prune:

Here are the specific commands and techniques to prune your Claude Code context:

## Core Pruning Commands

**Remove specific files:**
```bash
claude code remove <file>
claude code remove src/utils.ts
claude code remove *.log  # Remove multiple files
```

**Clear conversation history:**
```bash
claude code reset
```
This wipes the entire conversation but keeps your file context.

**Start completely fresh:**
```bash
# Exit and restart Claude Code
exit
claude code
```

## Strategic Pruning Workflow

**After solving a task:**
1. Remove files that were only needed for debugging
2. Remove any logs, dumps, or temporary files you added
3. Keep only files you'll need for the next task

**Mid-conversation cleanup:**
```bash
# Check what's currently in context
claude code list

# Remove what you don't need anymore
claude code remove old-file.ts
claude code remove debug-output.txt
```

**When switching tasks:**
- If the new task is unrelated, use `claude code reset` to clear conversation history
- Remove files from the previous task
- Add only files needed for the new task

## Prevention (Better than Pruning)

**Use .claudeignore from the start:**
```gitignore
# .claudeignore
node_modules/
*.log
*.tmp
build/
dist/
coverage/
.env
*.test.ts  # If not working on tests
```

**Add files incrementally:**
- Don't add entire directories upfront
- Add files as you need them: `claude code add src/auth.ts`
- This keeps your initial context small

## Quick Check

Periodically run `claude code list` to see what's in your context. If you see files you're not actively working with, remove them.

The most effective pruning strategy is **preemptive**: only add what you need, and remove it as soon as you're done with it.