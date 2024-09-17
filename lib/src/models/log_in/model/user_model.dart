import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? email;
  final String? name;
  final String? photoUrl;
  final DateTime? createdAt;
  final List<dynamic>? playlist;

  UserModel({
    this.userId,
    this.email,
    this.name,
    this.photoUrl,
    this.createdAt,
    this.playlist,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data, String userId) {
    return UserModel(
      userId: userId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photo_url'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      playlist: List<dynamic>.from(data['playlist'] ?? []),
    );
  }

  // Convert UserModel to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'playlist': playlist,
      'user_id': userId,
    };
  }
}
