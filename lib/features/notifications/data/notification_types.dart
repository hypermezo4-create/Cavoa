enum NotificationChannel { inApp, push }

enum CavoNotificationType {
  orderCreated,
  orderApproved,
  orderRejected,
  orderProcessing,
  orderShipped,
  orderDelivered,
  orderCancelled,
  paymentConfirmed,
  paymentFailed,
  adminUpdate,
  ratingReminder,
}

extension CavoNotificationTypeX on CavoNotificationType {
  String get key {
    switch (this) {
      case CavoNotificationType.orderCreated:
        return 'order_created';
      case CavoNotificationType.orderApproved:
        return 'order_approved';
      case CavoNotificationType.orderRejected:
        return 'order_rejected';
      case CavoNotificationType.orderProcessing:
        return 'order_processing';
      case CavoNotificationType.orderShipped:
        return 'order_shipped';
      case CavoNotificationType.orderDelivered:
        return 'order_delivered';
      case CavoNotificationType.orderCancelled:
        return 'order_cancelled';
      case CavoNotificationType.paymentConfirmed:
        return 'payment_confirmed';
      case CavoNotificationType.paymentFailed:
        return 'payment_failed';
      case CavoNotificationType.adminUpdate:
        return 'admin_update';
      case CavoNotificationType.ratingReminder:
        return 'rating_reminder';
    }
  }

  static CavoNotificationType? tryFromKey(String? key) {
    switch (key) {
      case 'order_created':
        return CavoNotificationType.orderCreated;
      case 'order_approved':
        return CavoNotificationType.orderApproved;
      case 'order_rejected':
        return CavoNotificationType.orderRejected;
      case 'order_processing':
        return CavoNotificationType.orderProcessing;
      case 'order_shipped':
        return CavoNotificationType.orderShipped;
      case 'order_delivered':
        return CavoNotificationType.orderDelivered;
      case 'order_cancelled':
        return CavoNotificationType.orderCancelled;
      case 'payment_confirmed':
        return CavoNotificationType.paymentConfirmed;
      case 'payment_failed':
        return CavoNotificationType.paymentFailed;
      case 'admin_update':
        return CavoNotificationType.adminUpdate;
      case 'rating_reminder':
        return CavoNotificationType.ratingReminder;
      default:
        return null;
    }
  }
}
