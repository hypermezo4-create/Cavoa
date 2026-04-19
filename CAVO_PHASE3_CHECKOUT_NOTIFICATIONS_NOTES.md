# CAVO Phase 3 Patch

This patch continues from `CAVO_phase2_store_core_patch.zip` and focuses on the next agreed stage:

## Added / Improved
- Firebase-backed **order sync bootstrap** at app startup through `OrderController`
- **In-app notification center** built from order creation, status updates, and delivered-not-rated reminders
- **Notification badge** on the Home bell icon
- Notification entry in **Profile** with unread count
- Better **localized order/payment labels** for English, Arabic, German, and Russian
- Checkout polish:
  - prefill name / phone when available from Firebase Auth
  - localized success dialog and payment labels
  - no payment screenshot messaging kept in place
- Tracking polish:
  - localized status, payment, and key section labels

## Main files changed
- `lib/main.dart`
- `lib/data/models/order.dart`
- `lib/features/orders/data/order_controller.dart`
- `lib/features/home/presentation/home_screen.dart`
- `lib/features/profile/presentation/profile_screen.dart`
- `lib/features/checkout/presentation/checkout_screen.dart`
- `lib/features/orders/presentation/delivery_tracking_screen.dart`
- `lib/features/notifications/data/notification_center_controller.dart`
- `lib/features/notifications/presentation/notifications_screen.dart`

## What to test next
1. Create an order from checkout and confirm it appears in Firestore
2. Open the Home bell and confirm the new order notification appears
3. Change the order status in Firebase and confirm:
   - Profile order badge updates
   - notification center gets a new entry
   - tracking screen reflects the new status
4. Switch app language and verify checkout/tracking/order labels update

## Still for later phases
- push notifications (FCM) real delivery
- broader full-screen language cleanup across every remaining hardcoded user-facing string
- final performance trimming / visual reduction pass
