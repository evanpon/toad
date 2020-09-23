import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  Widget _displayTag(String tagName, Map metadata) {
    String display = "$tagName";
    if (metadata["collaborators"].isNotEmpty) {
      display += " ${metadata['collaborators']}";
    }
    return Text(display);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where("name", isEqualTo: "Evan")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading');
            Map tags = snapshot.data.documents.first.data()["tags"];
            Set tagNames = tags.keys.toSet();
            return ListView.builder(
                itemExtent: 80,
                itemCount: tagNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Row(
                    children: [
                      Expanded(
                        child: _displayTag(tagNames.elementAt(index),
                            tags[tagNames.elementAt(index)]),
                      )
                    ],
                  ));
                });
          }),
    );
  }
}
