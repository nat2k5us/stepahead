# StepAhead Project Instructions

## Git Commit Guidelines

### When to Commit
Create git commits at these key milestones:
1. **After completing a feature that works** - Test on iOS simulator first, then commit
2. **Before making risky changes** - Commit the working state before adding complex features
3. **After fixing a bug** - Commit once the fix is verified working
4. **When user confirms something works** - After user testing confirms functionality
5. **At end of session** - Before wrapping up work

### Commit Message Format
**DO NOT include these sections:**
- ❌ `🤖 Generated with [Claude Code]`
- ❌ `Co-Authored-By: Claude`

**DO include:**
- ✅ Clear description of what changed
- ✅ What features are working/tested
- ✅ Technical details of changes
- ✅ Next steps planned

### Example Good Commit:
```
Add task navigation and step-by-step view

- Implemented clickable task cards
- Added step-by-step instruction view
- Tested on iOS simulator: all features working

Technical changes:
- Added showTaskView() function
- Added navigation state management
- Updated renderHomeTab() to handle clicks

Next: Add timer functionality for steps
```

## Development Approach

### Incremental Testing
When adding features to this iOS app:
1. **Start with working baseline** - Always have a known working state
2. **Add features one at a time** - Test after each addition
3. **Test on iOS simulator** - Rebuild in Xcode and verify before proceeding
4. **Commit when working** - Don't wait until "everything" is done
5. **If something breaks** - Revert to last working commit and try again

### iOS-Specific Notes
- Firebase auth callbacks can be slow/unreliable - always add fallback timeouts
- Test splash screen behavior - disable or set to 0ms if causing issues
- Z-index issues common - login screen needs z-index > 200
- Always test touch/tap events on actual iOS simulator, not just browser

## Project Context
- **App:** StepAhead - Step-by-step household task guidance
- **Platform:** iOS (Capacitor)
- **Framework:** Vanilla JS + Tailwind CSS
- **Backend:** Firebase (optional, has dev bypass mode)
- **Features:** Task lists, step-by-step instructions, progress tracking
