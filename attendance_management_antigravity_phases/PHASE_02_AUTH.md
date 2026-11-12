# PHASE 02 — Login & Registration UI

## Context

Phase 1 has created the Flutter project, theme, folder structure, and splash screen.

Now implement the authentication UI only.

## Goal

Create polished mobile Login and Registration screens inspired by the provided reference image.

The login screen should visually resemble:

```text
        [person icon]

       Welcome Back

   Sign in to your account

EMAIL ADDRESS
[ test@test.com ]

PASSWORD
[ •••••••• ]

[       Sign In       ]

────────────────────────

Don't have an account?
       Create one
```

## Important Rules

1. Inspect and preserve Phase 1.
2. Do not remove the existing theme.
3. Do not add Firebase yet.
4. Do not create real authentication yet.
5. Use local/mock authentication only for navigation testing.
6. Keep the implementation beginner-friendly.
7. Do not expose passwords in plain text.
8. Use form validation.
9. The UI must be mobile-first and responsive.

## Files

Implement:

```text
lib/screens/auth/
├── login_screen.dart
└── register_screen.dart
```

Use reusable:

```text
lib/widgets/custom_button.dart
lib/widgets/custom_text_field.dart
```

Update routes if needed:

```text
lib/routes/app_routes.dart
```

## Login Screen

Requirements:

- App/person icon near the top.
- "Welcome Back" heading.
- "Sign in to your account" subtitle.
- Email field.
- Password field.
- Password visibility toggle.
- Blue Sign In button.
- Divider.
- "Don't have an account? Create one".
- Clean white rounded card or centered mobile layout.
- Adequate spacing.
- Keyboard should not cover the form.
- Use `SingleChildScrollView` where appropriate.

## Validation

Email:
- required
- valid email format

Password:
- required
- minimum reasonable length

Show friendly validation messages.

## Mock Login

For now, clicking Sign In can accept valid form input and navigate to a temporary dashboard placeholder.

Do NOT hard-code a fake Firebase login.

The purpose is only to test navigation.

## Register Screen

Include:

- Full Name
- Email
- Password
- Confirm Password
- Register button
- Link back to Login

Validation:
- required fields
- email format
- password length
- confirm password must match

After successful mock registration, return to Login.

## UI Details

Use:
- rounded input fields
- blue primary button
- subtle border
- clean typography
- consistent margins
- Material icons where appropriate

Do not use excessive gradients, animations, or decorative elements.

## Acceptance Criteria

- Login screen works.
- Registration screen works.
- Form validation works.
- Password can be shown/hidden.
- Login navigation works.
- Register navigation works.
- Back navigation works.
- No Firebase is required.
- `flutter analyze` has no new errors.
- Existing Phase 1 functionality remains intact.

## Final Response

Report:
- files changed
- screens completed
- validation implemented
- navigation implemented
- test credentials if you created any mock behavior
- analyzer/build status

Do not start Phase 3 automatically.
