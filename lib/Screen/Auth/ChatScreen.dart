// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//
// class ChatScreen extends StatefulWidget {
//   final String recipientId;
//   final String recipientName;
//
//   const ChatScreen({required this.recipientId, required this.recipientName});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<types.Message> _messages = [];
//   late types.User _currentUser;
//   late types.User _recipientUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeUsers();
//     _subscribeToMessages();
//   }
//
//   void _initializeUsers() {
//     final user = _auth.currentUser!;
//     _currentUser = types.User(id: user.uid);
//     _recipientUser = types.User(id: widget.recipientId, firstName: widget.recipientName);
//   }
//
//   void _subscribeToMessages() {
//     // Listen for real-time updates of messages
//     _firestore
//         .collection('messages')
//         .where('senderId', whereIn: [_auth.currentUser!.uid, widget.recipientId])
//         .where('recipientId', whereIn: [_auth.currentUser!.uid, widget.recipientId])
//         .orderBy('timestamp', descending: true) // Fetch latest messages first
//         .snapshots()
//         .listen((snapshot) {
//       final messages = snapshot.docs.map((doc) {
//         final data = doc.data();
//         final senderId = data['senderId'];
//         final createdAt = (data['timestamp'] as Timestamp).toDate().millisecondsSinceEpoch;
//
//         return types.TextMessage(
//           id: doc.id,
//           author: senderId == _auth.currentUser!.uid ? _currentUser : _recipientUser,
//           text: data['text'],
//           createdAt: createdAt,
//         );
//       }).toList();
//
//       setState(() {
//         _messages = messages.reversed.toList(); // Reverse for correct order
//       });
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     _firestore.collection('messages').add({
//       'text': message.text,
//       'senderId': _auth.currentUser!.uid,
//       'recipientId': widget.recipientId,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.recipientName),
//       ),
//       body: SafeArea(
//         child: Chat(
//           messages: _messages,
//           onSendPressed: _handleSendPressed,
//           user: _currentUser,
//         ),
//       ),
//     );
//   }
// }
