import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemini_chatbot/src/constraints/api_keys.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../data/model/chat.dart';
import '../../data/model/chat_collection.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final fireStore = FirebaseFirestore.instance;

  String selectedChatCollection = '';

  RxBool isGenerateResponse = false.obs;

  saveDataToFirebase(String prompt, String response) async {
    final newChat = Chat(
      prompt: prompt,
      response: response,
      createdAt: Timestamp.now(), // Add timestamp here
    );
    final chatCollectionRef = fireStore
        .collection('ChatCollection')
        .doc(selectedChatCollection)
        .collection('Chats');

    await chatCollectionRef.add(newChat.toJson());

    final chatCollectionDoc = await fireStore
        .collection('ChatCollection')
        .doc(selectedChatCollection)
        .get();

    if (chatCollectionDoc.exists &&
        chatCollectionDoc.data()!['title'].toString().isEmpty) {
      await fireStore
          .collection('ChatCollection')
          .doc(selectedChatCollection)
          .update({'title': prompt});
    }
  }

  Future<void> getGeminiResponse(String prompt) async {
    isGenerateResponse.value = true;
    if (selectedChatCollection.isEmpty) {
      selectedChatCollection = await createNewCollection();
    }

    final model = GenerativeModel(model: 'gemini-pro', apiKey: APIKey.apiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    saveDataToFirebase(prompt, response.text!);
    isGenerateResponse.value = false;
  }

  Future<String> createNewCollection() async {
    final newCollection = ChatCollection(
      title: '',
      createdAt: Timestamp.now(), // Add timestamp here
    );
    final DocumentReference docRef = await fireStore
        .collection('ChatCollection')
        .add(newCollection.toJson());
    selectedChatCollection = docRef.id;
    update();
    return selectedChatCollection;
  }

  Stream<QuerySnapshot> getAllCollection() {
    return fireStore
        .collection('ChatCollection')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteSelectedChatCollection(String selectedId) async {
    await fireStore.collection('ChatCollection').doc(selectedId).delete();
  }
}
