import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController _chatController;

  final ChatUser currentUser = ChatUser(id: '1', name: 'Flutter');
  final ChatUser otherUser = ChatUser(id: '2', name: 'Simform');

  List<Message> messageList = [];

  @override
  void initState() {
    super.initState();

    // Initial messages for the chat
    messageList = [
      Message(
        id: '1',
        message: "Hi!",
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        sentBy: otherUser.id,
        messageType: MessageType.text,
      ),
      Message(
        id: '2',
        message: "Hello, how can I help you?",
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        sentBy: currentUser.id,
        messageType: MessageType.text,
      ),
    ];

    // Initialize ChatController with initial data
    _chatController = ChatController(
      initialMessageList: messageList,
      currentUser: currentUser,
      otherUsers: [otherUser],
      scrollController: ScrollController(),
    );
  }

  void onSendTap(String message, ReplyMessage replyMessage, MessageType messageType) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      createdAt: DateTime.now(),
      sentBy: currentUser.id,
      replyMessage: replyMessage,
      messageType: messageType,
    );

    _chatController.addMessage(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: isDark ? Colors.grey[900] : Colors.blue,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(
                titleLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.grey[300]),
              ),
            ),
            child: ChatViewAppBar(
              profilePicture: 'https://example.com/profile_image.png',
              chatTitle: 'Simform Chat',
              userStatus: 'online',
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      body: ChatView(
        chatController: _chatController,
        onSendTap: onSendTap,
        chatViewState: ChatViewState.hasMessages,

        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: isDark ? Colors.black : Colors.white,
        ),

        featureActiveConfig: const FeatureActiveConfig(
          enableSwipeToReply: true,
          enableSwipeToSeeTime: true,
        ),

        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            color: isDark ? Colors.blue.shade700 : Colors.blue,
            textStyle: const TextStyle(color: Colors.white),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          inComingChatBubbleConfig: ChatBubble(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            textStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),

        sendMessageConfig: SendMessageConfiguration(
          // Use these colors if your version supports backgroundColor for the input bar
          replyMessageColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          replyDialogColor: isDark ? Colors.blue.shade900 : Colors.blue.shade200,
          replyTitleColor: isDark ? Colors.white : Colors.black,
          closeIconColor: isDark ? Colors.white : Colors.black,
          textFieldConfig: TextFieldConfiguration(
            textStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            hintText: 'Type a message',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
}
