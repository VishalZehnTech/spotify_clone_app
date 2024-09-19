import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId; // User's unique identifier
  final String? email; // User's email address
  final String? name; // User's name
  final String? photoUrl; // URL to user's profile photo
  final DateTime? createdAt; // Date when the user account was created
  final List<dynamic>? playlist; // User's playlist

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
      userId: userId, // Assign userId from parameters
      email: data['email'] ?? '', // Extract email from Firestore data or default to empty string
      name: data['name'] ?? '', // Extract name from Firestore data or default to empty string
      photoUrl: data['photo_url'] ??
          '', // Extract photoUrl from Firestore data or default to empty string
      createdAt: (data['created_at'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      playlist: List<dynamic>.from(
          data['playlist'] ?? []), // Extract playlist or default to an empty list
    );
  }

  // Convert UserModel to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'email': email, // Email address
      'name': name, // User's name
      'photo_url': photoUrl, // URL to user's profile photo
      'created_at': createdAt, // Date when the user account was created
      'playlist': playlist, // User's playlist
      'user_id': userId, // User's unique identifier
    };
  }
}
