# PHASE 03 — Dashboard & Bottom Navigation

## Context

Phase 1 and Phase 2 are complete.

Now create the main application dashboard.

## Goal

Create a polished mobile dashboard for an Attendance Management System.

The dashboard should feel like a real college/teacher attendance application, while remaining simple enough for a lab project.

## Main Navigation

Create four main destinations:

```text
Home
Attendance
Students
Reports
```

Use a bottom navigation bar.

Files:

```text
lib/screens/dashboard/dashboard_screen.dart
lib/widgets/bottom_nav_bar.dart
lib/widgets/app_header.dart
lib/widgets/statistic_card.dart
```

You may create a simple main shell/navigation screen if necessary.

## Dashboard Layout

Recommended layout:

```text
Good Morning 👋
Manage your attendance

Attendance Overview

┌──────────────────────────┐
│      Overall Attendance  │
│             86%          │
│     This month           │
└──────────────────────────┘

┌────────────┐  ┌────────────┐
│     42     │  │      5     │
│  Students  │  │   Absent   │
└────────────┘  └────────────┘

Today's Classes

08:30 AM
Data Structures

10:30 AM
Database Management

01:30 PM
Computer Networks
```

## Mock Data

Use clearly separated local mock data.

Example:
- total students: 42
- present: 37
- absent: 5
- overall attendance: 88%

These values are temporary and will be replaced by Firebase data later.

## UI

Use the Phase 1 theme.

Cards:
- white
- rounded
- subtle shadow
- consistent padding

Primary action:
- blue

Present:
- green

Absent:
- red

## Bottom Navigation

Implement working navigation between:
- Dashboard
- Attendance placeholder
- Students placeholder
- Reports placeholder

The placeholders should have polished empty/coming-soon states rather than blank screens.

Example:

```text
Attendance
Mark and manage today's attendance

[ Open Attendance ]
```

## Header

Create a reusable app header with:
- title
- optional subtitle
- optional profile/avatar icon

Avoid overly large headers because this is a mobile app.

## Responsive Requirements

- No horizontal overflow.
- Works on small Android screens.
- Safe area respected.
- Bottom navigation does not overlap content.
- Long content scrolls correctly.

## Acceptance Criteria

- Dashboard launches after mock login.
- Bottom navigation works.
- Four destinations are reachable.
- Dashboard statistics are displayed.
- Mock data is clearly separated.
- UI matches the established theme.
- No Firebase yet.
- `flutter analyze` has no new errors.
- Existing login/register flow still works.

## Final Response

Report:
1. Files changed.
2. Dashboard features.
3. Navigation behavior.
4. Mock data used.
5. Analyzer/build status.

Do not implement student database or Firebase yet.
