import 'notification_center_controller.dart';
import 'notification_types.dart';

class NotificationDeliveryRequest {
  final CavoNotificationItem notification;
  final Set<NotificationChannel> channels;

  const NotificationDeliveryRequest({
    required this.notification,
    this.channels = const {NotificationChannel.inApp},
  });
}

abstract class NotificationDeliveryService {
  const NotificationDeliveryService();

  Future<void> deliver(NotificationDeliveryRequest request);
}

class InAppOnlyNotificationDeliveryService extends NotificationDeliveryService {
  const InAppOnlyNotificationDeliveryService();

  @override
  Future<void> deliver(NotificationDeliveryRequest request) async {
    // In-app delivery is already handled by NotificationCenterController.syncFromOrders.
    // TODO(phase-fcm): Add FCM channel handling when push infrastructure is wired.
  }
}
