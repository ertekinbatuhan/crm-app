# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Flutter CRM (Customer Relationship Management) application built with an MVVM architecture pattern. The app currently uses mock data implementations in the service layer and is designed for managing contacts, deals, tasks, and meetings.

## Common Development Commands

### Running and Building
```bash
# Run the app in debug mode (Windows/Android/iOS)
flutter run

# Build for Android
flutter build apk        # APK for distribution
flutter build appbundle  # AAB for Play Store

# Build for iOS (macOS only)
flutter build ios

# Build for Windows
flutter build windows

# Run on specific device
flutter run -d <device_id>
```

### Testing and Quality
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Analyze code for issues
flutter analyze

# Check for outdated dependencies
flutter pub outdated
```

### Dependency Management
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies to latest compatible versions
flutter pub upgrade

# Upgrade to latest versions (may break compatibility)
flutter pub upgrade --major-versions
```

## Architecture

### MVVM Pattern with Provider

The application follows Model-View-ViewModel (MVVM) architecture:

1. **Dependency Injection**: `lib/app/app.dart` configures MultiProvider with all services and ViewModels
   - Services are provided as singletons
   - ViewModels use ChangeNotifierProxyProvider for reactive dependency updates

2. **Service Layer**: Abstract interfaces with mock implementations
   - Each service defines a contract (abstract class) and implementation
   - Currently using in-memory data with simulated delays
   - Services: TaskService, ContactService, DealService, MeetingService

3. **ViewModels**: Business logic and state management
   - Extend ChangeNotifier for reactive UI updates
   - Handle loading states, error states, and data transformations
   - Coordinate between multiple services when needed
   - Example: DashboardViewModel loads data from all services in parallel

4. **Provider State Management Flow**:
   - ViewModels are injected via Provider at the app root
   - Views access ViewModels using `context.read<>()` or `context.watch<>()`
   - State changes trigger UI rebuilds through notifyListeners()

## Project Structure

```
lib/
├── app/
│   └── app.dart              # MultiProvider setup and app configuration
├── main.dart                  # Entry point
├── models/                    # Data models with Equatable for value equality
│   ├── contact_model.dart    # Contact with categories (lead, customer, partner)
│   ├── deal_model.dart       # Deal with stages and pipeline tracking
│   ├── meeting_model.dart    # Meeting with participants and types
│   ├── task_model.dart       # Task with priority levels and associations
│   └── [other models]        # Notification, Pipeline, Reminder, Stat models
├── services/                  # Data layer abstractions
│   ├── contact_service.dart  # Contact CRUD operations
│   ├── deal_service.dart     # Deal management and pipeline operations
│   ├── meeting_service.dart  # Meeting scheduling and management
│   └── task_service.dart     # Task CRUD with date filtering
├── viewmodels/                # Business logic layer
│   ├── dashboard_viewmodel.dart  # Aggregates data from all services
│   ├── contacts_viewmodel.dart   # Contact list management
│   ├── deals_viewmodel.dart      # Deal pipeline management
│   ├── reports_viewmodel.dart    # Analytics from all services
│   └── tasks_viewmodel.dart      # Task and meeting coordination
├── views/                     # UI screens
│   ├── dashboard_view.dart   # Main dashboard with stats
│   ├── contacts_view.dart    # Contact management screen
│   ├── deals_view.dart       # Deal pipeline view
│   ├── reports_view.dart     # Analytics and reports
│   └── tasks_view.dart       # Task and calendar view
└── core/
    └── components/            # Reusable UI components
        ├── avatar/           # User avatar components
        ├── button/           # Custom buttons
        ├── calendar/         # Calendar widgets
        ├── card/             # Various card components
        ├── dashboard/        # Dashboard-specific components
        ├── list-view/        # List item templates
        ├── meeting/          # Meeting-related UI
        ├── modal/            # Dialog and modal components
        ├── navigation/       # Header and navigation
        ├── reminder/         # Reminder UI elements
        └── task/             # Task-specific components
```

## Key Dependencies

- **provider: ^6.1.2** - State management and dependency injection
- **equatable: ^2.0.5** - Value equality for model classes (used in all models for comparison)
- **flutter_lints: ^5.0.0** - Enforces Flutter best practices and code quality

## Development Specifications

- **Flutter SDK**: ^3.9.0 required
- **Dart SDK**: Included with Flutter
- **Material Design**: Uses Material Design components throughout
- **Package name**: `flutterprojects` (as defined in pubspec.yaml)

## Testing Approach

The project includes widget tests in `test/widget_test.dart` that verify:
- Dashboard renders correctly
- Navigation items are present (Home, Contacts, Deals, Tasks, Reports)
- Stat cards display expected data

When adding new features:
1. Add unit tests for new service methods
2. Add widget tests for new UI components
3. Test ViewModel business logic separately
4. Verify Provider dependencies are correctly configured

## Mock Data Implementation

All services currently use mock data with simulated network delays:
- `Future.delayed(Duration(milliseconds: 300-500))` simulates API calls
- Data is stored in-memory as List collections
- IDs are generated using `DateTime.now().millisecondsSinceEpoch`

To transition to real backend:
1. Keep the abstract service interfaces unchanged
2. Create new implementations that call actual APIs
3. Update provider configuration in `app/app.dart`
4. Services already handle async operations appropriately