# PHASE 04 — Student Management

## Context

The Flutter Attendance Management System already has:
- project foundation
- theme
- splash
- login/register
- dashboard
- bottom navigation

Now implement Student Management using local in-memory/mock data.

## Goal

Create a clean student management module.

## Files

Implement:

```text
lib/screens/students/
├── students_screen.dart
└── add_student_screen.dart

lib/models/student_model.dart
```

Use/reuse:

```text
lib/widgets/student_card.dart
```

A temporary local student repository/service can be used, but do not connect Firebase yet.

## Student Model

Create a simple null-safe model:

```text
Student
- id
- name
- rollNumber
- email
- department
- attendancePercentage
```

Use appropriate Dart types.

## Students Screen

Design:

```text
Students                         +

Search students...

────────────────────────────

┌──────────────────────────┐
│ 👤 Yuvaraj               │
│ 23CS101                  │
│ CSE                      │
│                          │
│ Attendance       86%     │
└──────────────────────────┘

┌──────────────────────────┐
│ 👤 Rahul                 │
│ 23CS102                  │
│ CSE                      │
│                          │
│ Attendance       91%     │
└──────────────────────────┘
```

Requirements:
- page title
- add student button
- search field
- student cards
- empty state
- scrolling list

## Add Student

Create:

```text
Add Student

Student Name
[________________]

Roll Number
[________________]

Email
[________________]

Department
[________________]

[ Add Student ]
```

Validation:
- name required
- roll number required
- email valid if provided
- department required

After adding:
- return to Students screen
- show the new student immediately
- show a SnackBar confirmation

## Student Card Actions

Provide a simple way to:
- view basic student details
- delete a student

Confirm before deletion.

Do not add complex editing unless it is straightforward.

## Search

Search by:
- student name
- roll number

Search should update the list immediately.

## Mock Data

Start with 5–8 realistic sample students.

Do not use personal/private data.

## Architecture

Keep UI separate from model and data handling.

Do not add a state management package just for this.

Use `setState` or a simple repository pattern appropriate for a beginner.

## Acceptance Criteria

- Students tab works.
- Student list appears.
- Search works.
- Add Student works.
- Validation works.
- Delete works with confirmation.
- New students appear immediately.
- No Firebase required.
- No horizontal overflow.
- `flutter analyze` has no new errors.

## Final Response

Report:
- files created/changed
- model fields
- student CRUD behavior implemented
- search behavior
- analyzer/build result

Do not implement Firestore yet.
