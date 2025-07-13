import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref().child('users');
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: database.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('No users found'));
        }

        final users = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        final userList = users.entries
            .where((entry) => entry.key != currentUser!.uid)
            .map((entry) => {
                  'uid': entry.key,
                  'name': entry.value['name'],
                  'profileUrl': entry.value['profileUrl'],
                })
            .toList();

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final user = userList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['profileUrl'] ?? ''),
              ),
              title: Text(user['name'] ?? 'Unknown'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverId: user['uid'],
                      receiverName: user['name'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}