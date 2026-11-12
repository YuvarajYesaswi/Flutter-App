# PHASE 07 — Firebase Authentication & Cloud Firestore Integration

## Context

The Attendance Management System is now functional with local/mock data.

Now replace mock authentication and persistence with Firebase.

## Important

Before making changes:
1. Inspect the entire current project.
2. Preserve working UI and functionality.
3. Do not redesign completed screens unnecessarily.
4. Do not remove features from earlier phases.
5. Make Firebase integration incremental.
6. Keep the code beginner-friendly.

## Firebase Services

Use:

```text
Firebase Authentication
Cloud Firestore
```

Do not add Firebase Storage unless genuinely needed.

## Packages

Add only the required compatible FlutterFire packages:
- firebase_core
- firebase_auth
- cloud_firestore

Use versions compatible with the current Flutter environment rather than blindly copying old versions.

## Firebase Configuration

Guide the developer through the normal FlutterFire configuration appropriate to the current environment.

Do NOT place private service-account credentials inside the Flutter mobile application.

Never commit:
- service account JSON
- private keys
- secrets
- API secrets that should not be public

## Initialization

Initialize Firebase before `runApp`.

Ensure the app shows a useful error instead of crashing if Firebase initialization fails.

## Authentication

Replace mock login/register behavior with Firebase Authentication.

### Register

Create Firebase Auth user with:
- email
- password

Then create a Firestore user document:

```text
users/{uid}
```

Fields:

```text
name
email
role
createdAt
```

Default role:

```text
teacher
```

### Login

Use Firebase Auth email/password.

Handle common errors:
- invalid email
- wrong password
- user not found
- email already in use
- weak password
- network failure

Show user-friendly SnackBars/messages.

### Logout

Implement real logout.

## Firestore Structure

Use a simple structure suitable for a college project:

```text
users/{uid}

students/{studentId}

attendance/{attendanceId}
```

Student document:

```text
name
rollNumber
email
department
createdAt
createdBy
```

Attendance document:

```text
studentId
date
period
status
createdBy
createdAt
```

Use consistent date storage. Prefer a Firestore Timestamp for actual date/time and a normalized date string such as `yyyy-MM-dd` when date-based querying is useful.

## Student Service

Implement:

```text
lib/services/student_service.dart
```

Functions should cover:
- add student
- get students
- update student if supported
- delete student

Use Firestore.

The Students screen should update from Firestore instead of only mock data.

## Attendance Service

Implement:

```text
lib/services/attendance_service.dart
```

Functions:
- save attendance
- get attendance for date
- get attendance for student
- get attendance for date + period

Avoid excessive reads.

## Loading/Error/Empty States

Every Firebase-backed screen needs:
- loading state
- error state
- empty state

Example:

```text
Loading students...
```

or:

```text
Unable to load students.
[ Retry ]
```

## Firestore Security

Create a basic secure Firestore rules strategy.

Users should not have unrestricted public write access.

At minimum:
- unauthenticated users cannot read/write application data
- authenticated users can access permitted application records

Keep rules simple enough for a lab project and explain them.

Do not put credentials in source code.

## Migration

Remove mock data from production paths after Firebase is confirmed working.

Do not delete mock logic until the real Firebase path is working.

## Acceptance Criteria

- Firebase initializes correctly.
- Register creates Auth account.
- Login works.
- Logout works.
- Students persist in Firestore.
- Attendance persists in Firestore.
- App reload does not lose students.
- Date-based attendance can be retrieved.
- Loading/error/empty states work.
- Firestore rules are not publicly writable.
- No secrets committed.
- `flutter analyze` has no new errors.
- App builds/runs successfully.

## Final Response

Report:
1. Firebase packages added.
2. Firebase configuration steps.
3. Auth implementation.
4. Firestore collections/documents.
5. Services created/changed.
6. Security rules approach.
7. Any Firebase console steps still required.
8. Analyzer/build status.

Do not proceed to Phase 8 automatically.
