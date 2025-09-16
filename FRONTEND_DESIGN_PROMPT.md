# Flutter CRM Application - Complete Frontend Redesign Prompt

## Project Overview
Design a modern, professional CRM (Customer Relationship Management) mobile application using Flutter. The app manages contacts, deals, tasks, and meetings with a clean, intuitive interface following Material Design 3 principles with a contemporary business aesthetic.

## Design Requirements

### Core Design Principles
1. **Minimal and Clean**: Views should have minimal body code - all UI logic should be in reusable components
2. **Component-Based Architecture**: Create generic, reusable components that can be composed together
3. **Consistent Design System**: Unified color scheme, typography, spacing, and interaction patterns
4. **Mobile-First**: Optimized for mobile devices with responsive layouts
5. **Professional Business Look**: Modern enterprise software aesthetic with subtle animations

### Color Palette Suggestion
- Primary: Deep Blue (#1976D2) - Trust and professionalism
- Secondary: Teal (#00796B) - Success and growth
- Background: Light Grey (#F5F5F5) - Clean canvas
- Surface: White (#FFFFFF) - Card backgrounds
- Error: Red (#D32F2F)
- Success: Green (#388E3C)
- Warning: Orange (#F57C00)
- Text Primary: Dark Grey (#212121)
- Text Secondary: Medium Grey (#757575)

## Complete Project Structure

```
lib/
├── app/
│   └── app.dart                 # [NO CHANGE] MultiProvider setup
├── main.dart                    # [NO CHANGE] Entry point
├── models/                      # [NO CHANGE] Data models
│   ├── contact_model.dart
│   ├── deal_model.dart
│   ├── meeting_model.dart
│   ├── task_model.dart
│   ├── notification_model.dart
│   ├── pipeline_model.dart
│   ├── reminder_model.dart
│   └── stat_model.dart
├── services/                    # [NO CHANGE] Service layer
│   ├── contact_service.dart
│   ├── deal_service.dart
│   ├── meeting_service.dart
│   └── task_service.dart
├── viewmodels/                  # [NO CHANGE] Business logic
│   ├── dashboard_viewmodel.dart
│   ├── contacts_viewmodel.dart
│   ├── deals_viewmodel.dart
│   ├── reports_viewmodel.dart
│   └── tasks_viewmodel.dart
├── views/                       # [REDESIGN] Minimal view files
│   ├── dashboard_view.dart     # Simple scaffold with component composition
│   ├── contacts_view.dart      
│   ├── deals_view.dart         
│   ├── reports_view.dart       
│   └── tasks_view.dart         
└── core/
    ├── theme/                   # [NEW] Centralized theming
    │   ├── app_theme.dart       # Complete theme definition
    │   ├── app_colors.dart      # Color constants
    │   ├── app_typography.dart  # Text styles
    │   └── app_spacing.dart     # Spacing constants
    └── components/              # [REDESIGN] Generic reusable components
        ├── base/                # [NEW] Base components
        │   ├── base_card.dart   # Generic card wrapper
        │   ├── base_button.dart # Generic button with variants
        │   ├── base_input.dart  # Generic input field
        │   ├── base_avatar.dart # Generic avatar component
        │   └── base_badge.dart  # Generic badge component
        ├── layout/              # [NEW] Layout components
        │   ├── app_scaffold.dart    # Custom scaffold wrapper
        │   ├── page_container.dart  # Standard page container
        │   ├── section_header.dart  # Section headers
        │   └── empty_state.dart     # Empty state component
        ├── navigation/          # Navigation components
        │   ├── app_header.dart      # Top app bar
        │   ├── bottom_nav_bar.dart  # Bottom navigation
        │   └── tab_bar.dart         # Tab navigation
        ├── cards/               # Specific card types
        │   ├── stat_card.dart       # Statistics display card
        │   ├── contact_card.dart    # Contact list item card
        │   ├── deal_card.dart       # Deal display card
        │   ├── task_card.dart       # Task item card
        │   ├── meeting_card.dart    # Meeting display card
        │   └── summary_card.dart    # Summary information card
        ├── lists/               # List components
        │   ├── generic_list.dart    # Generic list with builder
        │   ├── grouped_list.dart    # Grouped list view
        │   └── searchable_list.dart # List with search
        ├── charts/              # Data visualization
        │   ├── bar_chart.dart       # Bar chart component
        │   ├── line_chart.dart      # Line chart component
        │   ├── pie_chart.dart       # Pie chart component
        │   └── progress_chart.dart  # Progress indicators
        ├── forms/               # Form components
        │   ├── form_field.dart      # Generic form field
        │   ├── dropdown_field.dart  # Dropdown selector
        │   ├── date_picker.dart     # Date selection
        │   ├── time_picker.dart     # Time selection
        │   └── search_field.dart    # Search input
        ├── dialogs/             # Dialog components
        │   ├── confirmation_dialog.dart
        │   ├── info_dialog.dart
        │   ├── form_dialog.dart
        │   └── bottom_sheet.dart
        ├── feedback/            # User feedback components
        │   ├── loading_indicator.dart
        │   ├── error_widget.dart
        │   ├── success_message.dart
        │   └── snackbar.dart
        └── composite/           # Complex composed components
            ├── dashboard_stats.dart     # Dashboard statistics section
            ├── pipeline_view.dart       # Sales pipeline visualization
            ├── calendar_view.dart       # Calendar component
            ├── activity_timeline.dart   # Activity feed
            └── quick_actions.dart       # Quick action buttons
```

## Component Specifications

### Base Components (Generic, Reusable)

#### BaseCard
```dart
// Generic card container with customizable:
- elevation (default: 2)
- padding (default: 16)
- borderRadius (default: 12)
- backgroundColor (default: white)
- onTap callback (optional)
- child widget
```

#### BaseButton
```dart
// Generic button with variants:
- variant: primary, secondary, text, outlined
- size: small, medium, large
- isLoading state
- icon support (leading/trailing)
- fullWidth option
```

#### BaseInput
```dart
// Generic input field:
- label, hint, helper text
- prefix/suffix icons
- validation
- input formatters
- keyboard type
```

### View Structure Requirements

Each view should follow this minimal pattern:

```dart
class ExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'View Title',
      body: PageContainer(
        child: Consumer<ExampleViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return LoadingIndicator();
            }
            if (viewModel.hasError) {
              return ErrorWidget(message: viewModel.error);
            }
            return ExampleContent(data: viewModel.data);
          },
        ),
      ),
    );
  }
}
```

## Specific Screen Designs

### 1. Dashboard View
**Components needed:**
- `DashboardStats` - Grid of stat cards showing KPIs
- `PipelineView` - Visual sales pipeline
- `ActivityTimeline` - Recent activities
- `QuickActions` - Floating action buttons for common tasks

**Layout:**
- Scrollable column
- Stats at top (2x2 grid)
- Pipeline chart below stats
- Activity feed at bottom

### 2. Contacts View
**Components needed:**
- `SearchField` - Top search bar
- `FilterChips` - Category filters (Lead, Customer, Partner)
- `ContactCard` - List item for each contact
- `FloatingActionButton` - Add new contact

**Features:**
- Alphabetical grouping with section headers
- Swipe actions (call, email, delete)
- Pull to refresh
- Avatar with initials

### 3. Deals View
**Components needed:**
- `TabBar` - Pipeline stages as tabs
- `DealCard` - Card for each deal
- `SummaryCard` - Total value and count
- `ProgressChart` - Stage progression

**Features:**
- Kanban-style board view
- Drag and drop between stages
- Deal value prominently displayed
- Color coding by priority

### 4. Tasks View
**Components needed:**
- `CalendarView` - Month/week view toggle
- `TaskCard` - Task list items
- `FilterChips` - Status filters
- `DatePicker` - Jump to date

**Features:**
- Today, Tomorrow, Upcoming sections
- Checkbox for completion
- Priority indicators
- Due date/time display

### 5. Reports View
**Components needed:**
- `StatCard` - KPI cards
- `LineChart` - Revenue trends
- `BarChart` - Deal distribution
- `PieChart` - Lead sources

**Features:**
- Date range selector
- Export functionality indicator
- Comparative metrics
- Drill-down capability

## Animation and Interaction Guidelines

### Transitions
- Page transitions: Slide from right (iOS) or fade up (Android)
- Card interactions: Subtle scale on tap (0.98)
- List items: Slide in from bottom on load (staggered)

### Micro-interactions
- Button press: Ripple effect
- Checkbox: Smooth check animation
- Tab switch: Slide indicator
- Pull to refresh: Custom branded animation

### Loading States
- Skeleton screens for lists
- Shimmer effect for cards
- Circular progress for actions
- Linear progress for multi-step processes

## Responsive Design Considerations

### Breakpoints
- Mobile: < 600px (default)
- Tablet: 600px - 1024px
- Desktop: > 1024px (if needed)

### Adaptations
- Navigation: Bottom nav (mobile) → Side rail (tablet)
- Grid: 2 columns (mobile) → 3-4 columns (tablet)
- Cards: Full width (mobile) → Fixed width (tablet)

## Accessibility Requirements

1. **Semantic Labels**: All interactive elements must have semantic labels
2. **Contrast Ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
3. **Touch Targets**: Minimum 48x48 dp
4. **Screen Reader Support**: Proper announcements for state changes
5. **Keyboard Navigation**: Support for external keyboards

## State Management Integration Points

Components should accept data via constructor parameters and callbacks:

```dart
class ExampleComponent extends StatelessWidget {
  final List<DataModel> data;
  final VoidCallback onRefresh;
  final Function(DataModel) onItemTap;
  
  // Pure presentation component, no business logic
}
```

## Performance Optimization Guidelines

1. Use `const` constructors wherever possible
2. Implement `ListView.builder` for long lists
3. Cache images with appropriate sizing
4. Lazy load data on scroll
5. Minimize widget rebuilds with proper state management

## Design System Documentation

Create a style guide showing:
1. All color variations and their use cases
2. Typography scale with examples
3. Spacing system (4, 8, 12, 16, 24, 32, 48)
4. Component states (default, hover, pressed, disabled)
5. Icon set (Material Icons recommended)

## Deliverables Expected

1. Complete theme configuration in `app_theme.dart`
2. All base components fully implemented and documented
3. Each view redesigned with minimal body code
4. Consistent styling across all screens
5. Smooth animations and transitions
6. Proper error and loading states
7. Responsive layout support

## Additional Notes

- Maintain existing MVVM architecture with Provider
- Keep services and ViewModels unchanged
- Focus on presentation layer only
- Ensure backwards compatibility with existing models
- Test on both iOS and Android platforms
- Consider dark mode support as future enhancement

---

This design should create a professional, modern CRM application that is both visually appealing and highly functional, while maintaining clean code architecture with reusable components.