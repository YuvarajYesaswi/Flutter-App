# PHASE 01 — Flutter Attendance Management System: Project Setup & UI Foundation

## Role

You are an expert Flutter developer helping build a beginner-friendly but polished college laboratory project.

## Project

Build a mobile application named **Attendance Management System** using Flutter and Dart.

The app should have a clean, modern, professional UI inspired by the user's reference screenshots:
- white cards
- light gray/blue-gray background
- strong blue primary color
- rounded corners
- subtle shadows
- clear typography
- green for successful/present states
- red for absent/error states

The application is mobile-first. Do NOT copy the desktop table layout literally. Adapt the same visual language into responsive mobile cards.

## Important Development Rules

1. First inspect the existing Flutter project.
2. Do not delete working code unnecessarily.
3. Do not introduce unnecessary packages.
4. Use null-safe Dart.
5. Use Material 3.
6. Keep code beginner-friendly and readable.
7. Separate reusable widgets from screens.
8. Do not implement Firebase yet. Firebase will be handled in a later phase.
9. The project must compile and run after this phase.
10. Do not create fake functionality that looks implemented but does nothing.
11. Do not add authentication yet.
12. Do not add database functionality yet.

## Target Folder Structure

Create or organize the project like this:

```text
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   └── utils/
│       ├── validators.dart
│       └── date_utils.dart
│
├── models/
│   ├── student_model.dart
│   ├── attendance_model.dart
│   └── user_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── student_service.dart
│   └── attendance_service.dart
│
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── auth/
│   ├── dashboard/
│   ├── attendance/
│   ├── students/
│   └── reports/
│
├── widgets/
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── student_card.dart
│   ├── attendance_card.dart
│   ├── statistic_card.dart
│   ├── app_header.dart
│   └── bottom_nav_bar.dart
│
└── routes/
    └── app_routes.dart
```

Create folders now even if some files will be implemented later.

## Theme

Use a blue-centered visual system approximately based on:

- Primary blue: #2563EB
- Dark blue: #1E3A8A
- Background: #F5F7FB
- Card: #FFFFFF
- Success: #10B981
- Danger: #EF4444
- Main text: dark navy/charcoal
- Secondary text: gray

Do not hard-code colors repeatedly throughout screens. Store them in `app_colors.dart`.

## App Setup

Create:
- `main.dart`
- `app.dart`
- `app_theme.dart`
- `app_colors.dart`
- `app_strings.dart`
- `app_sizes.dart`
- `app_routes.dart`

Use Material 3 and a centralized theme.

## Splash Screen

Create a simple polished splash screen:

```text
[attendance/calendar icon]

Attendance Management
Manage attendance easily

Loading...
```

Use the application's primary blue and white.

The splash screen should automatically move to the login screen placeholder after a short delay. If the login screen does not exist yet, create a temporary placeholder route/screen so the project runs.

## Responsive Design

The app must work on:
- Android phone
- small phone
- large phone
- Flutter web preview if available

Avoid fixed widths that break on mobile.

## Reusable Widget Guidelines

Create reusable components with sensible parameters, but do not over-engineer.

Examples:
- CustomButton
- CustomTextField
- StatisticCard
- StudentCard
- AppHeader

Only create widgets that are useful in upcoming phases.

## Acceptance Criteria

Before finishing:
- `flutter analyze` should have no new errors.
- The application should launch successfully.
- Splash screen should appear.
- Navigation from splash to a placeholder/login screen should work.
- Theme should be applied globally.
- Folder structure should exist.
- No Firebase dependency/configuration should be required yet.

## Final Response

After implementing, report:
1. Files created/changed.
2. Features completed.
3. Any commands that need to be run.
4. Any warnings/errors that remain.
5. Confirm whether the app runs successfully.

Do not move to Phase 2 automatically.
