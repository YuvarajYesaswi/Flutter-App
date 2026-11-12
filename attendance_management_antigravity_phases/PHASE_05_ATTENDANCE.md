# PHASE 05 — Attendance Screen, Date Selection & Mark Attendance

## Context

The project now has:
- authentication UI
- dashboard
- student management
- local/mock student data

Now implement the core Attendance module.

## Goal

Create a mobile attendance experience inspired by the user's reference screenshots.

The desktop screenshot shows:
- blue header
- date navigation
- period columns
- student rows
- present/absent checkboxes
- total such as 6/7
- save attendance

For mobile, adapt this into cards and controls. Do NOT force a wide table onto a phone.

## Files

Implement:

```text
lib/screens/attendance/
├── attendance_screen.dart
└── date_picker_dialog.dart

lib/models/attendance_model.dart

lib/widgets/attendance_card.dart
```

Use existing student model/data.

## Attendance Screen

Top area:

```text
← Attendance

February 16, 2026

[ ‹ ]       Select Date       [ › ]
```

Then summary:

```text
Present     38
Absent       4
Total       42
```

Then:

```text
Students
```

Each student:

```text
┌──────────────────────────┐
│ 👤 Yuvaraj               │
│ 23CS101                  │
│                          │
│ [ ✓ Present ] [ Absent ] │
└──────────────────────────┘
```

Make the selected state visually obvious.

## Attendance Model

Create a model capable of representing:

```text
Attendance
- id
- studentId
- date
- period
- status
```

Status should be represented safely, preferably with an enum such as:

```text
present
absent
```

Avoid using magic strings everywhere.

## Date Selection

Implement a polished date picker.

Requirements:
- selected date
- month navigation
- previous month
- next month
- calendar grid
- close/cancel
- date selection

Use Flutter's built-in date picker if it can be styled sufficiently. If the reference requires a custom modal, implement a simple custom dialog.

The UI should resemble:

```text
┌────────────────────────────┐
│       Select Date       ×  │
│                            │
│    ‹   February 2026   ›   │
│                            │
│ Sun Mon Tue Wed Thu Fri Sat│
│                            │
│  1   2   3   4   5   6   7 │
│  8   9  10  11  12  13  14│
│ 15  [16] 17  18  19  20 21│
│ 22  23  24  25  26  27 28│
└────────────────────────────┘
```

## Date Navigation

The attendance screen should support:
- previous date
- next date
- tapping the date to open calendar
- changing date updates the displayed date

## Attendance Logic

For each student:
- Present
- Absent

When status changes:
- update local state
- update present/absent counts
- update total

Example:

```text
Total: 42
Present: 38
Absent: 4
```

## Save Button

At the bottom:

```text
[        Save Attendance        ]
```

For this phase, saving means updating local/mock state.

Show:

```text
Attendance saved successfully
```

with a SnackBar.

Do not write to Firebase yet.

## UX Requirements

- Clear touch targets.
- No tiny checkboxes.
- Cards should be easy to tap.
- Avoid clutter.
- Keep save action visible.
- Use confirmation/feedback after save.

## Acceptance Criteria

- Attendance screen works.
- Date selection works.
- Previous/next date works.
- Student list appears.
- Present/Absent selection works.
- Counts update correctly.
- Save action works locally.
- Date-specific local state is preserved during the current app session where practical.
- No Firebase.
- `flutter analyze` has no new errors.
- Mobile UI has no overflow.

## Final Response

Report:
- attendance screen files
- date picker behavior
- attendance calculation logic
- save behavior
- analyzer/build result

Do not implement Firebase yet.
