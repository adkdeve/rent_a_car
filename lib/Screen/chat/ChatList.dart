import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ChatScreen.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  ChatListScreen({required this.currentUserId});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatsStream() {
    return _firestore
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return DateFormat('MMM d, h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getChatsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading chats'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final data = chatDoc.data()! as Map<String, dynamic>;

              // Extract fields safely
              final lastMessage = data['lastMessage'] as String? ?? '';
              final lastMessageTime = data['lastMessageTime'] as Timestamp?;
              final participants = List<String>.from(data['participants'] ?? []);
              final participantInfo = Map<String, dynamic>.from(data['participantInfo'] ?? {});
              final unreadCountMap = Map<String, dynamic>.from(data['unreadCount'] ?? {});

              // Find the other participant(s)
              final otherParticipantIds = participants.where((id) => id != widget.currentUserId).toList();

              // For simplicity, show only first other participant info (usually 1-1 chat)
              String otherUserName = 'Unknown';
              String? otherUserAvatar;

              if (otherParticipantIds.isNotEmpty) {
                final otherId = otherParticipantIds.first;
                if (participantInfo.containsKey(otherId)) {
                  final info = participantInfo[otherId] as Map<String, dynamic>;
                  otherUserName = info['name'] ?? 'Unknown';
                  otherUserAvatar = info['avatar'];
                }
              }

              final unreadCount = unreadCountMap[widget.currentUserId] ?? 0;

              return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  },
                leading: otherUserAvatar != null && otherUserAvatar.isNotEmpty
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(otherUserAvatar),
                )
                    : CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  otherUserName,
                  style: TextStyle(fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTimestamp(lastMessageTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
