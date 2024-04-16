import 'package:cloud_firestore/cloud_firestore.dart';

class ChatCollection {
  String? title;
  final Timestamp? createdAt; // Add this field

  ChatCollection({this.title, this.createdAt}); // Update constructor

  // Factory method to create a ChatCollection object from a JSON string
  factory ChatCollection.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Invalid JSON data');
    }
    return ChatCollection(
      title: json['title'] ?? 'New Chat',

      createdAt: json['createdAt'], // Add this line
    );
  }

  // Convert ChatCollection object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': createdAt, // Add this line
    };
  }
}
