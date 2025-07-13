import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  Future<void> _makeDummyCall(String userId, String userName) async {
    final database = FirebaseDatabase.instance.ref();
    final call = {
      'callerId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'type': 'Audio',
    };
    await database.child('calls').push().set(call);
  }

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref().child('users');
    final currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
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
                      })
                  .toList();

              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    title: Text(user['name'] ?? 'Unknown'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.teal),
                      onPressed: () => _makeDummyCall(user['uid'], user['name']),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref().child('calls').onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(child: Text('No call history'));
              }
              final calls = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
              final callList = calls.entries
                  .map((entry) => {
                        'id': entry.key,
                        ...Map<String, dynamic>.from(entry.value),
                      })
                  .toList()
                ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

              return ListView.builder(
                itemCount: callList.length,
                itemBuilder: (context, index) {
                  final call = callList[index];
                  final isCaller = call['callerId'] == currentUser!.uid;
                  final otherUserId = isCaller ? call['receiverId'] : call['callerId'];
                  return FutureBuilder(
                    future: database.child(otherUserId).get().then(
                        (snapshot) => snapshot.value as Map<dynamic, dynamic>?),
                    builder: (context, AsyncSnapshot<Map<dynamic, dynamic>?> userSnapshot) {
                      final userName = userSnapshot.data?['name'] ?? 'Unknown';
                      return ListTile(
                        title: Text(isCaller ? 'Outgoing: $userName' : 'Incoming: $userName'),
                        subtitle: Text(
                          DateTime.fromMillisecondsSinceEpoch(call['timestamp'])
                              .toString(),
                        ),
                        trailing: Icon(
                          call['type'] == 'Audio' ? Icons.call : Icons.videocam,
                          color: Colors.teal,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}