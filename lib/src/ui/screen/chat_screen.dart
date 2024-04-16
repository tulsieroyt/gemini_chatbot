import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../../data/model/chat.dart';
import '../../data/model/chat_collection.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _promptController = TextEditingController();
  final firebaseChatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    firebaseChatController.createNewCollection();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gemini ChatBot'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Center(child: Text('Thanks 🥰')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Feel free to ask me if you have any queries!'),
                            Text(
                              'tulsieroyt@gmail.com',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDrawerHeader(),
              _buildStartNewChatButton(),
              _buildChatCollectionList(),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildChatList(),
              _buildInputSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: 100,
      child: const Center(
        child: Text(
          'Gemini ChatBot',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildStartNewChatButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            firebaseChatController.createNewCollection();
            Get.back();
          },
          child: const Text(
            'Start New Chat',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildChatCollectionList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: firebaseChatController.getAllCollection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No collections found'));
          }

          List<ChatCollection> collections = snapshot.data!.docs
              .map((doc) =>
                  ChatCollection.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.separated(
            itemCount: collections.length,
            separatorBuilder: (_, __) {
              return const Divider(
                thickness: 1,
              );
            },
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  collections[index].title!.isEmpty
                      ? 'New Chat'
                      : collections[index].title!,
                  maxLines: 1,
                ),
                onTap: () {
                  String? documentId = snapshot.data!.docs[index].id;
                  if (documentId.isNotEmpty) {
                    setState(() {
                      firebaseChatController.selectedChatCollection =
                          documentId;
                    });
                  }
                  Navigator.pop(context);
                },
                trailing: IconButton(
                    onPressed: () {
                      firebaseChatController.deleteSelectedChatCollection(
                          snapshot.data!.docs[index].id);
                      setState(() {});
                    },
                    icon: const Icon(CupertinoIcons.delete)),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: firebaseChatController.selectedChatCollection.isEmpty
          ? const Center(
              child: Text('How can I help you today?'),
            )
          : GetBuilder<ChatController>(builder: (context) {
              return StreamBuilder<QuerySnapshot>(
                stream: firebaseChatController.fireStore
                    .collection('ChatCollection')
                    .doc(firebaseChatController.selectedChatCollection)
                    .collection('Chats')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: const Image(
                              height: 60,
                              width: 60,
                              image:
                                  AssetImage('assets/icon/gemini_chatbot.png'),
                            ),
                          ),
                          const Text(
                            'How can I help you today?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  List<Chat> chats = snapshot.data!.docs
                      .map((doc) =>
                          Chat.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.separated(
                    reverse: true,
                    itemCount: chats.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🔎  ${chats[index].prompt}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Markdown(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                data: '📌  ${chats[index].response}',
                              ),
                            ]),
                      );
                    },
                  );
                },
              );
            }),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        Obx(() {
          if (firebaseChatController.isGenerateResponse.value == true) {
            return const CircularProgressIndicator();
          }
          return Container();
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(30),
          ),
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _promptController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_promptController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please write something'),
                      ),
                    );
                  } else {
                    if (firebaseChatController.selectedChatCollection.isEmpty) {
                      firebaseChatController.createNewCollection();
                      firebaseChatController
                          .getGeminiResponse(_promptController.text);
                      _promptController.clear();
                      setState(() {});
                    } else {
                      firebaseChatController
                          .getGeminiResponse(_promptController.text);
                      _promptController.clear();
                      setState(() {});
                    }
                  }
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
