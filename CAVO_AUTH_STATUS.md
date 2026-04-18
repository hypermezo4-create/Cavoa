# CAVO Auth Progress

## Current confirmed base
- Flutter project: CAVO
- Android package: `com.cavo.store`
- Firebase providers enabled: Email/Password, Phone, Google
- Release keystore alias: `cavo_release`
- New `google-services.json` already added

## What was changed now
- Added explicit Google server client ID config in `lib/core/config/auth_config.dart`
- Added centralized auth service in `lib/features/auth/data/auth_service.dart`
- Google Sign-In is initialized once on app startup
- Login screen no longer hides the real Google error behind `Google sign-in failed.`
- Google exceptions now surface detailed codes such as:
  - `clientConfigurationError`
  - `canceled`
  - `providerConfigurationError`
  - Firebase credential errors

## Why this matters
With `google_sign_in` 7.x, initialization timing and Android configuration clarity matter a lot. If the sign-in flow still fails after this update, the app should now reveal the exact error so the final remaining mismatch can be identified quickly.

## Most likely remaining real-world causes if device still fails
1. Device is running a debug build while Firebase only has the release SHA-1.
2. Android package / SHA / OAuth client mismatch in Firebase or Google Cloud.
3. The returned flow is being interpreted as `canceled` even though Android actually hit a configuration mismatch.

## Next planned auth steps after Google is confirmed
1. Full Phone Auth with OTP
2. Facebook Login
3. Session persistence verification after full app restart
4. Premium auth UI motion polish
5. Checkout polish and payment screenshot removal

## Premium auth vision
- Black layered background with soft gold volumetric glow
- Floating logo with slow breathing motion
- Email/password card enters with spring + blur fade
- Google / Phone / Facebook chips slide upward with stagger
- iOS-like field focus ring with liquid gold highlight
- Success transition that morphs into the home shell instead of a hard page jump
