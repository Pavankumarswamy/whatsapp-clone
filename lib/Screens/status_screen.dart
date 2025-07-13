import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _statusController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _database = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future<void> _postStatus() async {
    if (_imageUrlController.text.trim().isEmpty) return;
    final status = {
      'userId': _auth.currentUser!.uid,
      'imageUrl': _imageUrlController.text.trim(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _database.child('statuses').push().set(status);
    _imageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(hintText: 'Enter status image URL'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.post_add),
                  onPressed: _postStatus,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _database.child('statuses').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No statuses yet'));
                }
                final statuses = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                final statusList = statuses.entries
                    .map((entry) => {
                          'id': entry.key,
                          ...Map<String, dynamic>.from(entry.value),
                        })
                    .toList()
                  ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

                return ListView.builder(
                  itemCount: statusList.length,
                  itemBuilder: (context, index) {
                    final status = statusList[index];
                    return FutureBuilder(
                      future: _database
                          .child('users')
                          .child(status['userId'])
                          .get()
                          .then((snapshot) => snapshot.value as Map<dynamic, dynamic>?),
                      builder: (context, AsyncSnapshot<Map<dynamic, dynamic>?> userSnapshot) {
                        final userName = userSnapshot.data?['name'] ?? 'Unknown';
                        return ListTile(
                          leading: Image.network(
                            status['imageUrl'],
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                          title: Text('$userName\'s Status'),
                          subtitle: Text(
                            DateTime.fromMillisecondsSinceEpoch(status['timestamp'])
                                .toString(),
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
      ),
    );
  }
}