# Add/Edit Task Modal - Redesigned

## Design Philosophy
Create a beautiful, intuitive task creation modal that feels delightful to use. The design should minimize cognitive load, use smart defaults, and make task creation feel effortless rather than like a chore.

## Visual Design Requirements

### Color Scheme (Same as main app)
- Primary: Deep Blue (#1976D2)
- Secondary: Teal (#00796B)
- Background: Light Grey (#F5F5F5)
- Surface: White (#FFFFFF)
- Error: Red (#D32F2F)
- Success: Green (#388E3C)
- Warning: Orange (#F57C00)
- Text Primary: Dark Grey (#212121)
- Text Secondary: Medium Grey (#757575)

### Modal Appearance
- **Desktop**: Centered modal, 600px max width, 80% max height
- **Mobile**: Full screen with slide-up animation
- **Backdrop**: Semi-transparent black (rgba(0,0,0,0.5))
- **Border Radius**: 16px on desktop, 16px top corners only on mobile
- **Shadow**: Elevation 24dp for floating effect

---

## Layout Structure

### 1. Modal Header (Fixed, 72px height)
**Visual Style**: Clean white background with subtle bottom border

**Left Section**:
- Close button (X icon) - 40x40px touch target
- Subtle hover effect (grey background circle)

**Center Section**:
- Title: "New Task" or "Edit Task" (20px, font-weight: 600)
- Subtitle: Smart context like "for [Contact Name]" if related (14px, grey)

**Right Section**:
- "Create Task" primary button (or "Save Changes" for edit)
- Button should be prominent but not overwhelming
- Disabled state until title is entered

---

### 2. Priority & Quick Settings Bar (Below header, 64px height)
**Visual Style**: Light grey background (#F8F9FA) to distinguish from content

**Layout**: Horizontal row with smart spacing

**Priority Selector** (Visual pills, not dropdown):
```
[🔴 Urgent] [🟠 High] [🟡 Medium] [🟢 Low]
```
- Only one selectable at a time
- Selected state: Colored background with white text
- Unselected: Grey outline
- Smooth transition on selection

**Quick Date Buttons** (Right side):
```
[Today] [Tomorrow] [Next Week] [Custom 📅]
```
- Smart chips that auto-set due date
- Custom opens date picker inline
- Selected chip shows primary color

---

### 3. Main Content Area (Scrollable)

#### A. Task Title Section (Top, prominent)
**Design**: Large, borderless input field
- Placeholder: "What needs to be done?"
- Font size: 18px (larger than normal inputs)
- Auto-focus on modal open
- Character counter (subtle, bottom right): "0/100"
- No visible border until focused
- Smooth underline animation on focus

#### B. Smart Context Row (Horizontal chips/buttons)
**Visual**: Icon + text buttons in a row
```
[👤 Assign to] [🏢 Related to] [📁 Category] [🔄 Repeat]
```
- Each opens inline selector (not new modal)
- Selected items show as colored chips below
- Can remove with (x) on chip

#### C. Description Section (Expandable)
**Default State**: Collapsed with "Add description..." button
**Expanded State**: 
- Rich text editor with formatting toolbar
- Minimum 3 lines, max 10 lines before scroll
- Formatting: Bold, Italic, Bullet points, Numbered list
- Placeholder: "Add notes, requirements, or context..."

#### D. Due Date & Time Section
**Visual Design**: Card-style container with icon
```
📅 Due Date & Time
[Date selector] at [Time selector] 
□ All day task
□ Add reminder (30 min before)
```
- Inline calendar picker (not popup)
- Time picker with common options (9:00, 12:00, 3:00, 5:00, Custom)
- Smart suggestions based on working hours

#### E. Subtasks Section (Optional)
**Header**: "Break it down" with toggle to show/hide
**Design**: 
```
+ Add subtask
─────────────
□ Subtask 1 [x]
□ Subtask 2 [x]
```
- Simple checkbox list
- Inline editing
- Drag to reorder
- Progress indicator: "0 of 2 complete"

#### F. Attachments Section
**Visual**: Drag-and-drop zone
```
┌─────────────────────────┐
│   📎 Drop files here    │
│   or click to browse    │
└─────────────────────────┘
```
- Support multiple files
- Show preview thumbnails
- File size and type validation
- Remove option for each file

---

### 4. Smart Suggestions Panel (Right sidebar on desktop, bottom sheet on mobile)
**Visual Style**: Subtle background with rounded corners

**Sections**:

**A. Suggested Assignees** (Based on recent selections)
```
Recent:
[👤 John] [👤 Sarah] [👤 Me]
```

**B. Task Templates** (Common task types)
```
Quick Templates:
📞 Follow-up call
📧 Send email
📄 Review document
🤝 Schedule meeting
```
- One-click fills in common fields

**C. Related Items** (Smart linking)
```
Link to:
• Current deal: "Project Phoenix"
• Last viewed contact: "John Doe"
```

---

### 5. Footer Actions (Fixed, 64px height)
**Visual Style**: White background with top border

**Left Side**:
- "Cancel" text button (no background)

**Right Side** (Button group with spacing):
- "Save as Draft" (outlined button)
- "Create & New" (secondary button)
- "Create Task" (primary button, prominent)

**Mobile**: Stack buttons vertically for better touch targets

---

## Interaction Details

### Animations & Transitions
1. **Modal Entry**: Slide up with fade (300ms ease-out)
2. **Priority Selection**: Color fill animation (200ms)
3. **Field Focus**: Smooth underline grow (200ms)
4. **Validation Errors**: Shake animation + red highlight
5. **Success State**: Brief green check before close

### Keyboard Shortcuts (Desktop)
- `Ctrl/Cmd + Enter`: Create task
- `Escape`: Close modal
- `Tab`: Navigate between fields
- `Ctrl/Cmd + 1-4`: Set priority levels

### Smart Behaviors
1. **Auto-save**: Draft saved every 30 seconds
2. **Duplicate Detection**: Warn if similar task exists
3. **Smart Dates**: Parse natural language ("next Monday")
4. **Recent Items**: Remember last 5 assignments/categories
5. **Contextual Defaults**: Pre-fill based on where modal was opened

---

## States & Variations

### Loading State
- Skeleton screens for form fields
- Subtle loading spinner on buttons
- Maintain layout to prevent jumps

### Error States
- Inline validation (red text below fields)
- Non-blocking errors (toast notifications)
- Required field indicators (subtle red asterisk)

### Success State
- Brief success animation
- Auto-close after 1 second
- Or stay open if "Create & New" clicked

### Edit Mode Differences
1. Title: "Edit Task" instead of "New Task"
2. Pre-filled fields with current values
3. "Save Changes" instead of "Create Task"
4. Add "Delete Task" button (red, requires confirmation)
5. Show "Last modified" timestamp

---

## Mobile-Specific Considerations

### Layout Adjustments
1. Full screen modal with gesture support
2. Swipe down to close (with visual indicator)
3. Fixed header/footer, scrollable content
4. Bottom sheet for secondary options
5. Larger touch targets (min 48x48px)

### Mobile-Only Features
1. Voice input button for title/description
2. Camera button for quick photo attachments
3. Native date/time pickers
4. Haptic feedback on actions

---

## Accessibility Requirements

1. **Focus Management**: Auto-focus title field, logical tab order
2. **Screen Readers**: Proper ARIA labels and announcements
3. **Contrast**: All text meets WCAG AA standards
4. **Keyboard Navigation**: Full keyboard support
5. **Error Announcements**: Screen reader announces validation errors

---

## Empty States

### No Assignees Available
```
"No team members found"
[Invite team members]
```

### No Related Items
```
"Start typing to search contacts or deals"
```

---

## Advanced Features (Optional)

1. **AI Suggestions**: 
   - Smart title completion
   - Suggested due dates based on task type
   - Auto-categorization

2. **Voice Commands**:
   - "Create a follow-up task for tomorrow"
   - Natural language processing

3. **Recurring Tasks**:
   - Daily, Weekly, Monthly, Custom
   - End date or number of occurrences
   - Skip weekends option

4. **Task Dependencies**:
   - "Blocked by" / "Blocking" relationships
   - Visual indicator of dependencies

---

## Design Inspiration

Think of this modal as a blend of:
- **Todoist**: Clean, minimal task entry
- **Notion**: Smart suggestions and linking
- **Linear**: Beautiful animations and keyboard shortcuts
- **Things 3**: Delightful interactions and visual feedback

The goal is to make task creation feel less like filling out a form and more like having a smart assistant help you organize your work.

---

## Deliverables

Please provide:
1. **HTML/CSS** implementation with all states
2. **Responsive versions** (mobile, tablet, desktop)
3. **Interactive prototype** showing animations
4. **Component states**: Default, hover, focus, disabled, error
5. **PNG preview** of the complete modal
6. **Dark mode version** (optional but appreciated)

Focus on making this modal a joy to use - something users actually want to interact with rather than avoid.