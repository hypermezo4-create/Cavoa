class CavoUserProfile {
  const CavoUserProfile({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.area,
    required this.addressLine,
    required this.bio,
    required this.gender,
    required this.age,
    required this.visitedBefore,
    required this.avatarPath,
    required this.updatedAt,
  });

  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String city;
  final String area;
  final String addressLine;
  final String bio;
  final String gender;
  final int? age;
  final bool visitedBefore;
  final String? avatarPath;
  final DateTime? updatedAt;

  factory CavoUserProfile.empty({String uid = '', String email = ''}) {
    return CavoUserProfile(
      uid: uid,
      email: email,
      fullName: '',
      phone: '',
      city: 'Hurghada',
      area: '',
      addressLine: '',
      bio: 'Premium CAVO member',
      gender: 'male',
      age: null,
      visitedBefore: false,
      avatarPath: null,
      updatedAt: DateTime.now(),
    );
  }

  CavoUserProfile copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    String? city,
    String? area,
    String? addressLine,
    String? bio,
    String? gender,
    int? age,
    bool? visitedBefore,
    String? avatarPath,
    bool clearAvatar = false,
    DateTime? updatedAt,
  }) {
    return CavoUserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      area: area ?? this.area,
      addressLine: addressLine ?? this.addressLine,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      visitedBefore: visitedBefore ?? this.visitedBefore,
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'area': area,
      'addressLine': addressLine,
      'bio': bio,
      'gender': gender,
      'age': age,
      'visitedBefore': visitedBefore,
      'avatarPath': avatarPath,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'area': area,
      'addressLine': addressLine,
      'bio': bio,
      'gender': gender,
      'age': age,
      'visitedBefore': visitedBefore,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory CavoUserProfile.fromMap(Map<String, dynamic> map) {
    return CavoUserProfile(
      uid: (map['uid'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      city: (map['city'] ?? 'Hurghada').toString(),
      area: (map['area'] ?? '').toString(),
      addressLine: (map['addressLine'] ?? '').toString(),
      bio: (map['bio'] ?? 'Premium CAVO member').toString(),
      gender: (map['gender'] ?? 'male').toString(),
      age: (map['age'] as num?)?.toInt(),
      visitedBefore: map['visitedBefore'] == true,
      avatarPath: map['avatarPath']?.toString(),
      updatedAt: DateTime.tryParse((map['updatedAt'] ?? '').toString()),
    );
  }
}
