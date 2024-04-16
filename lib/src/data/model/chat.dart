import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String prompt;
  final String response;
  final Timestamp? createdAt; // Add this field

  Chat({required this.prompt, required this.response, this.createdAt}); // Update constructor

  // Factory method to create a Chat object from a DocumentSnapshot
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      prompt: json['prompt'],
      response: json['response'],
      createdAt: json['createdAt'], // Add this line
    );
  }

  // Convert Chat object to JSON
  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'response': response,
      'createdAt': createdAt, // Add this line
    };
  }
}
