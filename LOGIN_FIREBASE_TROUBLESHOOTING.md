# Login Fix + Firebase Troubleshooting

This repo was patched to make the auth flow more stable.

## What was fixed

### 1) Register no longer gets stuck forever after account creation
Before this patch, the register flow waited for extra profile steps after Firebase Auth had already created the account:
- `updateDisplayName(...)`
- `ProfileController.seedBasicProfile(...)`
- Firestore write to `users/{uid}`

If Firestore was slow, missing, blocked by rules, or the connection was unstable, the button could keep spinning even though the account had already been created.

Now the flow is:
1. Create the Firebase Auth account
2. Navigate into the app immediately
3. Finish profile sync in the background

So if Firebase Auth succeeds, the user is not blocked on profile sync anymore.

### 2) Password is no longer trimmed on login/register
The old code used `.trim()` on passwords. That can break login for users whose real password begins or ends with a space.

Patched:
- `lib/features/auth/presentation/login_screen.dart`
- `lib/features/auth/presentation/register_screen.dart`

### 3) Profile loading and Firestore sync now use timeouts
Firestore reads/writes can hang long enough to make the app feel stuck.

Patched:
- `lib/features/profile/data/profile_controller.dart`

Timeouts were added so the app can recover faster when Firestore is slow or misconfigured.

---

## Important note about this project

This build is currently **email-only**.
Google sign-in is intentionally disabled in:
- `lib/features/auth/data/auth_service.dart`

So for this repo:
- Email/password should work
- Password reset should work
- Google sign-in is expected to fail because it is disabled by design
- Phone OTP is present in the codebase but not ready as the main login flow

---

## If the problem is from Firebase, check these first

## A. Authentication provider
Open Firebase Console for this project and make sure:
- Project ID matches this repo: `cavo-4c0e6`
- Android package matches this repo: `com.cavo.store`
- **Authentication > Sign-in method > Email/Password** is enabled

If Email/Password is disabled, login and register will fail immediately.

---

## B. Firestore database exists
This app writes user profile data to:
- collection: `users`
- document id: current Firebase UID

If Firestore has not been created yet, the profile sync step can fail.

In Firebase Console:
1. Open **Firestore Database**
2. Create the database if it does not exist yet
3. Start in test mode for quick validation, or configure proper rules first

Example starter rules for development:

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

That allows each signed-in user to read/write only their own user profile document.

---

## C. `google-services.json`
This repo already contains:
- `android/app/google-services.json`

Verify it still belongs to the same Firebase project and package:
- package name should be `com.cavo.store`
- project should be `cavo-4c0e6`

If you changed the package name in Android but did not download a new `google-services.json`, Firebase Auth may fail or initialize incorrectly.

---

## D. If register works but profile data does not save
Symptoms:
- account gets created
- user is logged in
- profile data is empty or partially missing

Usually this means Firebase Auth is fine, but Firestore is the broken part.

Check:
- Firestore database exists
- Firestore rules allow the signed-in user to write `users/{uid}`
- Internet connection on the test device is stable
- Project is pointing to the correct Firebase backend

---

## E. If login still fails after this patch
Use this checklist:

1. Confirm the account exists in **Authentication > Users**
2. Confirm Email/Password provider is enabled
3. Confirm the app package is `com.cavo.store`
4. Confirm `google-services.json` matches the same Firebase project
5. Make sure you are typing the exact password, including spaces if the original password used them
6. If you created the account before the password trim fix, try resetting the password once

---

## Files changed by this patch
- `lib/features/auth/presentation/login_screen.dart`
- `lib/features/auth/presentation/register_screen.dart`
- `lib/features/profile/data/profile_controller.dart`

---

## Recommended test order
1. Uninstall the old app from the device
2. Build and install this patched version
3. Create a new test account
4. Confirm it goes directly into the app without infinite loading
5. Force close the app
6. Reopen and confirm the session is still active
7. Edit profile and confirm data is saved

If step 4 works but step 7 fails, the remaining issue is probably Firestore rules or Firestore setup, not Firebase Auth itself.
