enum OrderPaymentMethod {
  vodafoneCash,
  instaPay,
}

enum OrderStatus {
  pendingReview,
  confirmed,
  readyForPickup,
  completed,
  cancelled,
}

extension OrderPaymentMethodX on OrderPaymentMethod {
  String get label {
    switch (this) {
      case OrderPaymentMethod.vodafoneCash:
        return 'Vodafone Cash';
      case OrderPaymentMethod.instaPay:
        return 'InstaPay';
    }
  }
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pendingReview:
        return 'Pending Review';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class CavoOrderItem {
  final String productId;
  final String title;
  final String brand;
  final String? size;
  final int unitPrice;
  final int quantity;

  const CavoOrderItem({
    required this.productId,
    required this.title,
    required this.brand,
    required this.size,
    required this.unitPrice,
    required this.quantity,
  });

  int get total => unitPrice * quantity;
}

class CavoOrder {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String city;
  final String area;
  final String notes;
  final OrderPaymentMethod paymentMethod;
  final List<CavoOrderItem> items;
  final int subtotal;
  final int pickupFee;
  final int total;
  final String pickupType;
  final OrderStatus status;
  final DateTime createdAt;

  const CavoOrder({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.city,
    required this.area,
    required this.notes,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    required this.pickupFee,
    required this.total,
    required this.pickupType,
    required this.status,
    required this.createdAt,
  });
}