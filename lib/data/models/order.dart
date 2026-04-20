import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderPaymentMethod { instaPay }

enum OrderPaymentStatus { pending, confirmed, failed }

enum OrderFulfillmentType { delivery, branchPickup }

enum OrderStatus {
  pending,
  approved,
  processing,
  shipped,
  delivered,
  rejected,
  cancelled,
}

extension OrderPaymentMethodX on OrderPaymentMethod {
  String get key => 'instaPay';

  String get label => labelForLocale('en');

  String labelForLocale(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'إنستا باي';
      default:
        return 'InstaPay';
    }
  }

  static OrderPaymentMethod fromKey(String? value) => OrderPaymentMethod.instaPay;
}

extension OrderPaymentStatusX on OrderPaymentStatus {
  String get key {
    switch (this) {
      case OrderPaymentStatus.pending:
        return 'pending';
      case OrderPaymentStatus.confirmed:
        return 'confirmed';
      case OrderPaymentStatus.failed:
        return 'failed';
    }
  }

  String labelForLocale(String languageCode) {
    switch (this) {
      case OrderPaymentStatus.pending:
        return languageCode == 'ar' ? 'قيد الانتظار' : 'Pending';
      case OrderPaymentStatus.confirmed:
        return languageCode == 'ar' ? 'مؤكد' : 'Confirmed';
      case OrderPaymentStatus.failed:
        return languageCode == 'ar' ? 'فشل' : 'Failed';
    }
  }

  static OrderPaymentStatus fromKey(String? value) {
    switch (value) {
      case 'confirmed':
        return OrderPaymentStatus.confirmed;
      case 'failed':
        return OrderPaymentStatus.failed;
      case 'pending':
      default:
        return OrderPaymentStatus.pending;
    }
  }
}

extension OrderFulfillmentTypeX on OrderFulfillmentType {
  String get key {
    switch (this) {
      case OrderFulfillmentType.delivery:
        return 'delivery';
      case OrderFulfillmentType.branchPickup:
        return 'branch_pickup';
    }
  }

  String labelForLocale(String languageCode) {
    switch (this) {
      case OrderFulfillmentType.delivery:
        return languageCode == 'ar' ? 'توصيل' : 'Delivery';
      case OrderFulfillmentType.branchPickup:
        return languageCode == 'ar' ? 'استلام من الفرع' : 'Branch pickup';
    }
  }

  static OrderFulfillmentType fromKey(String? value) {
    switch (value) {
      case 'branch_pickup':
        return OrderFulfillmentType.branchPickup;
      case 'delivery':
      default:
        return OrderFulfillmentType.delivery;
    }
  }
}

extension OrderStatusX on OrderStatus {
  String get key {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.approved:
        return 'approved';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.rejected:
        return 'rejected';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String labelForLocale(String languageCode) {
    switch (this) {
      case OrderStatus.pending:
        return languageCode == 'ar' ? 'قيد الانتظار' : 'Pending';
      case OrderStatus.approved:
        return languageCode == 'ar' ? 'تمت الموافقة' : 'Approved';
      case OrderStatus.processing:
        return languageCode == 'ar' ? 'قيد التجهيز' : 'Processing';
      case OrderStatus.shipped:
        return languageCode == 'ar' ? 'تم الشحن' : 'Shipped';
      case OrderStatus.delivered:
        return languageCode == 'ar' ? 'تم التسليم' : 'Delivered';
      case OrderStatus.rejected:
        return languageCode == 'ar' ? 'مرفوض' : 'Rejected';
      case OrderStatus.cancelled:
        return languageCode == 'ar' ? 'ملغي' : 'Cancelled';
    }
  }

  static OrderStatus fromKey(String? value) {
    switch (value) {
      case 'approved':
        return OrderStatus.approved;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'rejected':
        return OrderStatus.rejected;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pendingReview':
      case 'pending':
      default:
        return OrderStatus.pending;
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

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'brand': brand,
        'size': size,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'total': total,
      };

  factory CavoOrderItem.fromMap(Map<String, dynamic> map) {
    return CavoOrderItem(
      productId: (map['productId'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      brand: (map['brand'] ?? '').toString(),
      size: map['size']?.toString(),
      unitPrice: (map['unitPrice'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

class OrderUserNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  const OrderUserNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt,
      };

  factory OrderUserNotification.fromMap(Map<String, dynamic> map) {
    return OrderUserNotification(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: (map['body'] ?? '').toString(),
      createdAt: _readDate(map['createdAt']) ?? DateTime.now(),
    );
  }
}

DateTime? _readDate(dynamic raw) {
  if (raw is Timestamp) return raw.toDate();
  if (raw is DateTime) return raw;
  if (raw is String) return DateTime.tryParse(raw);
  return null;
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
  final OrderPaymentStatus paymentStatus;
  final OrderFulfillmentType fulfillmentType;
  final String pickupBranchArabic;
  final String pickupBranchEnglish;
  final List<CavoOrderItem> items;
  final int subtotal;
  final int pickupFee;
  final int total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String adminNote;
  final String rejectionReason;
  final List<OrderUserNotification> userNotifications;
  final int? rating;
  final List<String> ratingTags;
  final DateTime? ratedAt;

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
    required this.paymentStatus,
    required this.fulfillmentType,
    required this.pickupBranchArabic,
    required this.pickupBranchEnglish,
    required this.items,
    required this.subtotal,
    required this.pickupFee,
    required this.total,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.adminNote = '',
    this.rejectionReason = '',
    this.userNotifications = const <OrderUserNotification>[],
    this.rating,
    this.ratingTags = const <String>[],
    this.ratedAt,
  });

  bool get isRated => rating != null && (rating ?? 0) > 0;

  Map<String, dynamic> toMap() {
    final now = FieldValue.serverTimestamp();
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
      'paymentStatus': paymentStatus.key,
      'pickupType': fulfillmentType.key,
      'status': status.key,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'pickupFee': pickupFee,
      'total': total,
      'createdAt': createdAt,
      'updatedAt': now,
      'adminNote': adminNote,
      'rejectionReason': rejectionReason,
      'userNotifications': userNotifications.map((item) => item.toMap()).toList(),
      'rating': rating,
      'ratingTags': ratingTags,
      'ratedAt': ratedAt,
      'source': 'flutter_app',
      'schemaVersion': 2,
      'customer': {
        'name': customerName,
        'phone': phoneNumber,
        'email': userEmail,
      },
      'shipping': {
        'city': city,
        'area': area,
        'addressLine': addressLine,
        'notes': notes,
      },
      'fulfillment': {
        'type': fulfillmentType.key,
        'branch': {
          'ar': pickupBranchArabic,
          'en': pickupBranchEnglish,
        },
      },
      'payment': {
        'method': paymentMethod.key,
        'status': paymentStatus.key,
      },
      'amounts': {
        'subtotal': subtotal,
        'deliveryFee': pickupFee,
        'total': total,
        'currency': 'EGP',
      },
    };
  }

  factory CavoOrder.fromMap(Map<String, dynamic> map) {
    final itemsRaw = map['items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map>()
            .map((item) => CavoOrderItem.fromMap(Map<String, dynamic>.from(item)))
            .toList(growable: false)
        : const <CavoOrderItem>[];

    final ratingTagsRaw = map['ratingTags'];
    final ratingTags = ratingTagsRaw is List
        ? ratingTagsRaw.map((tag) => tag.toString()).toList(growable: false)
        : const <String>[];

    final payment = map['payment'] is Map<String, dynamic>
        ? map['payment'] as Map<String, dynamic>
        : <String, dynamic>{};
    final fulfillment = map['fulfillment'] is Map<String, dynamic>
        ? map['fulfillment'] as Map<String, dynamic>
        : <String, dynamic>{};
    final branch = fulfillment['branch'] is Map<String, dynamic>
        ? fulfillment['branch'] as Map<String, dynamic>
        : <String, dynamic>{};
    final notificationsRaw = map['userNotifications'];
    final userNotifications = notificationsRaw is List
        ? notificationsRaw
            .whereType<Map>()
            .map((item) => OrderUserNotification.fromMap(Map<String, dynamic>.from(item)))
            .toList(growable: false)
        : const <OrderUserNotification>[];

    return CavoOrder(
      id: (map['id'] ?? '').toString(),
      userId: map['userId']?.toString(),
      userEmail: map['userEmail']?.toString(),
      customerName: (map['customerName'] ?? map['customer']?['name'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? map['customer']?['phone'] ?? '').toString(),
      city: (map['city'] ?? map['shipping']?['city'] ?? '').toString(),
      area: (map['area'] ?? map['shipping']?['area'] ?? '').toString(),
      addressLine: (map['addressLine'] ?? map['shipping']?['addressLine'] ?? '').toString(),
      notes: (map['notes'] ?? map['shipping']?['notes'] ?? '').toString(),
      paymentMethod: OrderPaymentMethodX.fromKey(
        map['paymentMethod']?.toString() ?? payment['method']?.toString(),
      ),
      paymentStatus: OrderPaymentStatusX.fromKey(
        map['paymentStatus']?.toString() ?? payment['status']?.toString(),
      ),
      fulfillmentType: OrderFulfillmentTypeX.fromKey(
        map['pickupType']?.toString() ?? fulfillment['type']?.toString(),
      ),
      pickupBranchArabic: (branch['ar'] ?? 'مول سيتي سنتر طريق عربيا').toString(),
      pickupBranchEnglish: (branch['en'] ?? 'Mall City Center, Arabeya Road').toString(),
      items: items,
      subtotal: (map['subtotal'] as num?)?.toInt() ?? (map['amounts']?['subtotal'] as num?)?.toInt() ?? 0,
      pickupFee: (map['pickupFee'] as num?)?.toInt() ?? (map['amounts']?['deliveryFee'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toInt() ?? (map['amounts']?['total'] as num?)?.toInt() ?? 0,
      status: OrderStatusX.fromKey(map['status']?.toString()),
      createdAt: _readDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _readDate(map['updatedAt']),
      adminNote: (map['adminNote'] ?? '').toString(),
      rejectionReason: (map['rejectionReason'] ?? '').toString(),
      userNotifications: userNotifications,
      rating: (map['rating'] as num?)?.toInt(),
      ratingTags: ratingTags,
      ratedAt: _readDate(map['ratedAt']),
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
    OrderPaymentStatus? paymentStatus,
    OrderFulfillmentType? fulfillmentType,
    String? pickupBranchArabic,
    String? pickupBranchEnglish,
    List<CavoOrderItem>? items,
    int? subtotal,
    int? pickupFee,
    int? total,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? adminNote,
    String? rejectionReason,
    List<OrderUserNotification>? userNotifications,
    int? rating,
    List<String>? ratingTags,
    DateTime? ratedAt,
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
      paymentStatus: paymentStatus ?? this.paymentStatus,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      pickupBranchArabic: pickupBranchArabic ?? this.pickupBranchArabic,
      pickupBranchEnglish: pickupBranchEnglish ?? this.pickupBranchEnglish,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      pickupFee: pickupFee ?? this.pickupFee,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      adminNote: adminNote ?? this.adminNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      userNotifications: userNotifications ?? this.userNotifications,
      rating: rating ?? this.rating,
      ratingTags: ratingTags ?? this.ratingTags,
      ratedAt: ratedAt ?? this.ratedAt,
    );
  }
}
