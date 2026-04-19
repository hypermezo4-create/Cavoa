# CAVO Email-Only Auth Patch

This patch switches the project to a stable email-first authentication flow.

Included:
- Login screen with email/password only
- External providers hidden from the UI
- Real password reset using Firebase Auth
- Expanded register flow with profile details saved to Firestore/ProfileController
- Main startup no longer warms up Google auth
- AuthService replaced with an email-only stub for stability

Apply on top of the saved stable base and run `flutter pub get`.
