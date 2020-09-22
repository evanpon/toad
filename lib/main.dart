import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Text("Error. Missing GoogleService-Info.plist file?",
                textDirection: TextDirection.ltr);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: MyHomePage(title: 'Flutter Demo Home Page'),
            );
          }
          return const Text("Loading", textDirection: TextDirection.ltr);
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text(widget.title),
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
