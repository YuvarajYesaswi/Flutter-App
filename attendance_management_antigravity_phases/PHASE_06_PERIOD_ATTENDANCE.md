# PHASE 06 — Period-wise Attendance & Attendance Calculations

## Context

The core daily attendance screen is working locally.

Now extend it with period-wise attendance inspired by the user's reference screenshot.

## Goal

Allow attendance to be recorded for multiple periods in a day.

Example:

```text
Period 1   ✓
Period 2   ✓
Period 3   ✓
Period 4   ✓
Period 5   ✓
Period 6   ✓
Period 7   ✕
```

Show:

```text
Attendance: 6 / 7
```

## Mobile UI

Do NOT create a wide 7-column table.

Use compact period cards/chips:

```text
Period Attendance

┌──────┐ ┌──────┐ ┌──────┐
│ P1 ✓ │ │ P2 ✓ │ │ P3 ✓ │
└──────┘ └──────┘ └──────┘

┌──────┐ ┌──────┐ ┌──────┐
│ P4 ✓ │ │ P5 ✓ │ │ P6 ✓ │
└──────┘ └──────┘ └──────┘

┌──────┐
│ P7 ✕ │
└──────┘
```

Tapping a period should toggle its attendance state.

## Data Model

Update `attendance_model.dart` if needed.

Represent:
- student
- date
- period
- status

Do not duplicate business logic unnecessarily.

## Calculations

Implement reusable calculations for:

### Student daily attendance

```text
present periods / total periods
```

Example:

```text
6 / 7 = 85.71%
```

Display a rounded value such as:

```text
86%
```

### Overall summary

For all students:
- total present records
- total absent records
- total records
- attendance percentage

Formula:

```text
attendance percentage =
present records / total records * 100
```

Handle zero records safely.

## UI

For each student, show:

```text
Yuvaraj
23CS101

Period Attendance
P1 ✓   P2 ✓   P3 ✓   P4 ✓
P5 ✓   P6 ✓   P7 ✕

Attendance
6 / 7
86%
```

The design should remain compact.

## Save

The existing Save Attendance action should save all period states to local/mock data.

Do not connect Firebase in this phase.

## UX

Use clear states:
- Present = green
- Absent = red
- Unmarked = neutral gray

If attendance has not been marked, do not incorrectly show it as present.

## Acceptance Criteria

- Seven periods are supported.
- Each period can be toggled.
- Daily percentage is calculated correctly.
- Summary counts are correct.
- Save includes period states.
- Existing student/date attendance still works.
- No Firebase yet.
- No unnecessary state-management package.
- No overflow on mobile.
- `flutter analyze` has no new errors.

## Final Response

Report:
- data model changes
- period UI
- calculation formulas
- save behavior
- analyzer/build status

Do not implement Firebase yet.
