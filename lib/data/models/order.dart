import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderPaymentMethod {
  vodafoneCash,
  instaPay,
}

enum OrderStatus {
  pendingReview,
  approved,
  rejected,
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderPaymentMethodX on OrderPaymentMethod {
  String get key {
    switch (this) {
      case OrderPaymentMethod.vodafoneCash:
        return 'vodafoneCash';
      case OrderPaymentMethod.instaPay:
        return 'instaPay';
    }
  }

  String get label {
    switch (this) {
      case OrderPaymentMethod.vodafoneCash:
        return 'Vodafone Cash';
      case OrderPaymentMethod.instaPay:
        return 'InstaPay';
    }
  }

  static OrderPaymentMethod fromKey(String? value) {
    switch (value) {
      case 'instaPay':
        return OrderPaymentMethod.instaPay;
      case 'vodafoneCash':
      default:
        return OrderPaymentMethod.vodafoneCash;
    }
  }
}

extension OrderStatusX on OrderStatus {
  String get key {
    switch (this) {
      case OrderStatus.pendingReview:
        return 'pendingReview';
      case OrderStatus.approved:
        return 'approved';
      case OrderStatus.rejected:
        return 'rejected';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pendingReview:
        return 'Pending Review';
      case OrderStatus.approved:
        return 'Approved';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromKey(String? value) {
    switch (value) {
      case 'approved':
        return OrderStatus.approved;
      case 'rejected':
        return OrderStatus.rejected;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pendingReview':
      default:
        return OrderStatus.pendingReview;
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

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'brand': brand,
      'size': size,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'total': total,
    };
  }

  factory CavoOrderItem.fromMap(Map<String, dynamic> map) {
    return CavoOrderItem(
      productId: (map['productId'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      brand: (map['brand'] ?? '').toString(),
      size: map['size']?.toString(),
      unitPrice: (map['unitPrice'] ?? 0) as int,
      quantity: (map['quantity'] ?? 0) as int,
    );
  }
}

class CavoOrder {
  final String id;
  final String? userId;
  final String? userEmail;
  final String customerName;
  final String phoneNumber;
  final String city;
  final String area;
  final String addressLine;
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
    this.userId,
    this.userEmail,
    required this.customerName,
    required this.phoneNumber,
    required this.city,
    required this.area,
    this.addressLine = '',
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'city': city,
      'area': area,
      'addressLine': addressLine,
      'notes': notes,
      'paymentMethod': paymentMethod.key,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'pickupFee': pickupFee,
      'total': total,
      'pickupType': pickupType,
      'status': status.key,
      'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
      'source': 'flutter_app',
    };
  }

  factory CavoOrder.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'];
    DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      createdAt = createdAtRaw;
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    final itemsRaw = map['items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map>()
            .map((item) => CavoOrderItem.fromMap(Map<String, dynamic>.from(item)))
            .toList()
        : const <CavoOrderItem>[];

    return CavoOrder(
      id: (map['id'] ?? '').toString(),
      userId: map['userId']?.toString(),
      userEmail: map['userEmail']?.toString(),
      customerName: (map['customerName'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      area: (map['area'] ?? '').toString(),
      addressLine: (map['addressLine'] ?? '').toString(),
      notes: (map['notes'] ?? '').toString(),
      paymentMethod: OrderPaymentMethodX.fromKey(map['paymentMethod']?.toString()),
      items: items,
      subtotal: (map['subtotal'] as num?)?.toInt() ?? 0,
      pickupFee: (map['pickupFee'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toInt() ?? 0,
      pickupType: (map['pickupType'] ?? '').toString(),
      status: OrderStatusX.fromKey(map['status']?.toString()),
      createdAt: createdAt,
    );
  }

  CavoOrder copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? customerName,
    String? phoneNumber,
    String? city,
    String? area,
    String? addressLine,
    String? notes,
    OrderPaymentMethod? paymentMethod,
    List<CavoOrderItem>? items,
    int? subtotal,
    int? pickupFee,
    int? total,
    String? pickupType,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return CavoOrder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      area: area ?? this.area,
      addressLine: addressLine ?? this.addressLine,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      pickupFee: pickupFee ?? this.pickupFee,
      total: total ?? this.total,
      pickupType: pickupType ?? this.pickupType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
