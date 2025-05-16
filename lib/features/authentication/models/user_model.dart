import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  String profilePicture;
  // New fields for media
  final List<String> mediaUrls;
  final Map<String, dynamic> mediaMetadata;
  final DateTime updatedAt;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.mediaUrls = const [],
    this.mediaMetadata = const {},
    DateTime? updatedAt,
    DateTime? createdAt,
  })  : this.updatedAt = updatedAt ?? DateTime.now(),
        this.createdAt = createdAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => formatPhoneNumber(phoneNumber);

  static List<String> nameParts(fullName) => fullName.split(' ');

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : '';
    String camelCaseUsername = '$firstName$lastName';
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
      );

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }

  static String formatInternationalPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return digitsOnly;
  }

  // Convert model to JSON for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'MediaUrls': mediaUrls,
      'MediaMetadata': mediaMetadata,
      'UpdatedAt': Timestamp.fromDate(updatedAt),
      'CreatedAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy of this user with updated fields
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    List<String>? mediaUrls,
    Map<String, dynamic>? mediaMetadata,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaMetadata: mediaMetadata ?? this.mediaMetadata,
      updatedAt: updatedAt ?? DateTime.now(),
      createdAt: this.createdAt,
    );
  }

  // Method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) {
      return UserModel.empty();
    }

    final data = document.data()!;

    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      username: data['Username'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      mediaUrls: List<String>.from(data['MediaUrls'] ?? []),
      mediaMetadata: Map<String, dynamic>.from(data['MediaMetadata'] ?? {}),
      updatedAt: (data['UpdatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['CreatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
