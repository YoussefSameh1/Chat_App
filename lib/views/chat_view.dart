import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/my_chat_buble.dart';
import 'package:chat_app/widgets/your_chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ChatView extends StatelessWidget {
  ChatView({super.key});
  static String id = 'chat_view';
  TextEditingController controller = TextEditingController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kTime, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (var message in snapshot.data!.docs) {
            messagesList.add(MessageModel.fromJson(message.data()));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogo, width: 60, height: 60),
                  SizedBox(width: 10),
                  Text(
                    'Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messagesList.length,
                    controller: _controller,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return messagesList[index].user == email
                          ? MyChatBuble(message: messagesList[index])
                          : YourChatBuble(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Send a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          messages.add({
                            kMessage: controller.text,
                            kTime: DateTime.now(),
                            kUser: email,
                          });
                          controller.clear();
                          _controller.animateTo(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.send, color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
