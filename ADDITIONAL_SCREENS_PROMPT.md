# Additional Screens for Flutter CRM Application

## Context
This is a continuation of the CRM application design. We've already designed the 5 main screens (Dashboard, Contacts, Deals, Tasks, Reports). Now we need detail views and forms for complete functionality.

Use the same design system as the main screens:
- Primary: Deep Blue (#1976D2)
- Secondary: Teal (#00796B)
- Background: Light Grey (#F5F5F5)
- Surface: White (#FFFFFF)
- Error: Red (#D32F2F)
- Success: Green (#388E3C)
- Warning: Orange (#F57C00)
- Professional, modern business aesthetic
- Material Design 3 principles

---

## 1. Contact Detail Screen

### Purpose
Full-page view showing complete contact information with action buttons.

### Layout Requirements
- **Header Section**:
  - Large avatar/profile image (left)
  - Contact name and title
  - Company name
  - Contact type badge (Lead/Customer/Partner)
  - Quick action buttons (Call, Email, Message)

- **Information Tabs**:
  - **Overview Tab**:
    - Contact Information card (phone, email, address)
    - Company Information card
    - Social Media links
    - Tags/Labels
  
  - **Activity Tab**:
    - Timeline of interactions
    - Recent emails
    - Call logs
    - Meeting history
  
  - **Deals Tab**:
    - Associated deals list
    - Total deal value
    - Deal progress indicators
  
  - **Notes Tab**:
    - Add note button
    - Chronological notes list
    - Note author and timestamp

- **Floating Action Button**: Edit contact

### Mobile Responsive
- Scrollable vertical layout
- Collapsible header on scroll
- Tab navigation below header

---

## 2. Deal Detail Screen

### Purpose
Comprehensive view of a deal with pipeline management capabilities.

### Layout Requirements
- **Header Section**:
  - Deal name (large, bold)
  - Company and contact associated
  - Deal value (prominent)
  - Current stage indicator
  - Close probability percentage

- **Pipeline Progress**:
  - Visual pipeline stages (horizontal)
  - Current stage highlighted
  - Clickable stages to update
  - Stage completion dates

- **Information Cards**:
  - **Deal Summary**:
    - Expected close date
    - Deal owner
    - Category/Type
    - Priority level
  
  - **Contact Information**:
    - Primary contact card
    - Decision makers list
    - Stakeholders
  
  - **Products/Services**:
    - Line items with quantities
    - Individual prices
    - Total calculation

- **Activity Section**:
  - Activity timeline
  - Add activity button
  - Filter by activity type

- **Action Buttons**:
  - Update Stage
  - Add Note
  - Schedule Meeting
  - Mark as Won/Lost

---

## 3. Task Detail Screen

### Purpose
Detailed task view with all related information and actions.

### Layout Requirements
- **Header**:
  - Task title (editable inline)
  - Checkbox for completion
  - Priority indicator (High/Medium/Low)
  - Due date and time

- **Main Content**:
  - **Description Section**:
    - Rich text description
    - Edit button
  
  - **Details Card**:
    - Assigned to
    - Created by
    - Category/Type
    - Related to (Contact/Deal)
  
  - **Subtasks**:
    - Add subtask button
    - Checklist of subtasks
    - Progress indicator
  
  - **Attachments**:
    - File upload area
    - Attached files list
    - Preview capability

- **Comments Section**:
  - Comment thread
  - Add comment input
  - User avatars and timestamps

- **Action Bar**:
  - Save changes
  - Delete task
  - Duplicate task
  - Convert to meeting

---

## 4. Meeting Detail Screen

### Purpose
Complete meeting information with participant management.

### Layout Requirements
- **Header**:
  - Meeting title
  - Date and time (with timezone)
  - Duration
  - Meeting type (Call/Video/In-person)
  - Status badge (Scheduled/Completed/Cancelled)

- **Meeting Details**:
  - **Location/Link Card**:
    - Physical address or
    - Video conference link
    - Join button (if virtual)
    - Map preview (if physical)
  
  - **Participants Section**:
    - Organizer info
    - Required attendees list
    - Optional attendees
    - Add participant button
    - RSVP status indicators
  
  - **Agenda Card**:
    - Meeting agenda
    - Talking points
    - Objectives

- **Related Information**:
  - Related deal
  - Related contacts
  - Attached documents

- **Notes Section**:
  - Meeting notes area
  - Action items from meeting
  - Follow-up tasks

- **Actions**:
  - Reschedule
  - Cancel meeting
  - Send reminder
  - Export to calendar

---

## 5. Add/Edit Contact Modal

### Purpose
Form for creating new contacts or editing existing ones.

### Layout Requirements
- **Modal Header**:
  - Title: "New Contact" or "Edit Contact"
  - Close button (X)
  - Save button

- **Form Sections**:
  - **Basic Information**:
    - Profile photo upload
    - First name*
    - Last name*
    - Job title
    - Company
    - Contact type dropdown (Lead/Customer/Partner)
  
  - **Contact Details**:
    - Email*
    - Phone number
    - Mobile number
    - Website
  
  - **Address**:
    - Street address
    - City
    - State/Province
    - Postal code
    - Country dropdown
  
  - **Additional Info**:
    - Tags input
    - Lead source dropdown
    - Assigned to (user selector)
    - Notes textarea

- **Footer**:
  - Cancel button
  - Save & New button
  - Save button

### Validation
- Required field indicators (*)
- Email format validation
- Phone number formatting
- Duplicate contact check

---

## 6. Add/Edit Deal Modal

### Purpose
Form for creating and editing deals.

### Layout Requirements
- **Modal Header**:
  - Title: "New Deal" or "Edit Deal"
  - Deal value input (prominent)

- **Form Fields**:
  - **Deal Information**:
    - Deal name*
    - Company/Account*
    - Primary contact dropdown*
    - Deal value*
    - Currency selector
  
  - **Pipeline Settings**:
    - Pipeline dropdown
    - Current stage selector
    - Probability percentage
    - Expected close date
  
  - **Details**:
    - Deal type dropdown
    - Lead source
    - Competitors field
    - Description textarea
  
  - **Assignment**:
    - Deal owner
    - Team members
    - Commission split (if applicable)

- **Products/Services Section**:
  - Add line item button
  - Product/service rows
  - Quantity and price inputs
  - Total calculation

- **Action Buttons**:
  - Cancel
  - Save as draft
  - Save & close

---

## 7. Add/Edit Meeting Modal

### Purpose
Schedule and edit meetings with intelligent scheduling.

### Layout Requirements
- **Header**:
  - Meeting type toggle (Call/Video/In-person)
  - Title input field

- **Date & Time Section**:
  - Date picker
  - Start time selector
  - End time selector
  - Timezone dropdown
  - Duration display
  - Recurring meeting options

- **Location/Platform**:
  - For in-person: Address input with map
  - For virtual: Platform selector (Zoom/Teams/Meet)
  - Auto-generate link option

- **Participants**:
  - Add participants search
  - Selected participants list
  - Required/Optional toggle
  - Send invites checkbox

- **Meeting Details**:
  - Related to (Deal/Contact selector)
  - Agenda textarea
  - Attachments upload
  - Reminder settings

- **Footer Actions**:
  - Cancel
  - Save draft
  - Schedule meeting

---

## 8. Add/Edit Task Modal

### Purpose
Quick task creation with smart defaults.

### Layout Requirements
- **Simplified Header**:
  - Task title input (large)
  - Priority selector (High/Medium/Low)

- **Quick Settings Bar**:
  - Due date picker
  - Time selector
  - Assign to dropdown
  - Category selector

- **Details Section** (Collapsible):
  - Description textarea
  - Related to (Contact/Deal)
  - Subtasks input
  - Repeat settings

- **Smart Suggestions**:
  - Suggested due dates (Today/Tomorrow/Next Week)
  - Common task templates
  - Recent assignments

- **Action Bar**:
  - Cancel
  - Create & Add Another
  - Create Task

---

## 9. Settings Screen

### Purpose
Application and user preferences management.

### Layout Requirements
- **Settings Categories** (List with icons):
  - **Account Settings**:
    - Profile information
    - Password change
    - Two-factor authentication
  
  - **Notifications**:
    - Email notifications toggle
    - Push notifications
    - Notification schedule
    - Alert preferences
  
  - **Display**:
    - Theme selection (Light/Dark/Auto)
    - Language selection
    - Date format
    - Currency default
  
  - **Calendar & Tasks**:
    - Default view
    - Working hours
    - Task reminders
    - Calendar sync
  
  - **Data & Privacy**:
    - Export data
    - Delete account
    - Privacy settings
    - Data retention

- **Each Setting Item**:
  - Icon
  - Title
  - Description
  - Toggle/Dropdown/Button

- **Save Mechanism**:
  - Auto-save with confirmation toast
  - Or explicit Save button

---

## 10. Profile Screen

### Purpose
User profile management and activity overview.

### Layout Requirements
- **Profile Header**:
  - Large profile photo
  - Edit photo button
  - User name
  - Role/Title
  - Email
  - Member since date

- **Statistics Cards** (Grid):
  - Total deals closed
  - Tasks completed
  - Meetings this month
  - Response time average

- **Activity Graph**:
  - Weekly activity chart
  - Performance metrics
  - Goal progress

- **Recent Activity**:
  - Activity feed
  - Filter by type
  - Date range selector

- **Team Section** (if applicable):
  - Team members list
  - Reporting structure
  - Team performance

- **Actions**:
  - Edit profile
  - View as public
  - Download report

---

## 11. Search & Filter Screen

### Purpose
Advanced search and filtering across all data types.

### Layout Requirements
- **Search Bar**:
  - Large search input
  - Voice search icon
  - Recent searches dropdown

- **Quick Filters** (Chips):
  - All
  - Contacts
  - Deals
  - Tasks
  - Meetings

- **Advanced Filters** (Expandable sections):
  - **Date Range**:
    - Preset options (Today/Week/Month)
    - Custom date picker
  
  - **Status Filters**:
    - Active/Inactive
    - Open/Closed
    - Completed/Pending
  
  - **Type Filters**:
    - Contact types
    - Deal stages
    - Task priorities
  
  - **Owner/Assignment**:
    - Assigned to me
    - My team
    - Specific user

- **Saved Filters**:
  - Save current filter
  - Saved filters list
  - Quick apply buttons

- **Results Section**:
  - Result count
  - Sort options
  - View toggle (List/Grid)
  - Results list with type indicators

- **Actions**:
  - Clear all filters
  - Export results
  - Save search

---

## Design Guidelines for All Screens

### Consistency Requirements
1. Use the same color palette and typography as main screens
2. Maintain consistent spacing (8, 16, 24, 32px)
3. Unified button styles and hover states
4. Same card elevation and border radius (12px)
5. Consistent icon set (Material Icons)

### Mobile Responsiveness
1. All modals should be full-screen on mobile
2. Tablet: Modals as centered dialogs (max-width: 600px)
3. Touch targets minimum 48x48px
4. Scrollable content with fixed headers/footers

### Animations
1. Slide up animation for modals
2. Fade in for overlays
3. Smooth transitions between states
4. Loading skeletons for data fetching

### Accessibility
1. Clear focus indicators
2. Proper contrast ratios
3. Screen reader labels
4. Keyboard navigation support

### Error Handling
1. Inline validation messages
2. Toast notifications for actions
3. Empty states with helpful messages
4. Offline mode indicators

---

## Deliverable Format

For each screen, please provide:
1. Complete HTML/CSS implementation
2. Mobile and tablet responsive versions
3. Interactive states (hover, active, disabled)
4. Loading and error states
5. Empty state designs
6. PNG preview image

Maintain consistency with the existing 5 main screens while ensuring these detail screens and modals feel like natural extensions of the application.