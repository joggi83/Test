import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';



Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID: '1:40471509456:ios:923fee00c47c5e8b',
      gcmSenderID: '40471509456',
      apiKey: 'AIzaSyBwi9cYl12PjhkAvnr7q0gh0s-7x--Rv08',
      projectID: 'delivranoo',
    ),
  );

  final Firestore firestore = new Firestore(app: app);

  runApp(new MaterialApp(
      title: 'LivranooZ', home: new FirstScreen(firestore: firestore)));
}


class MessageList extends StatelessWidget {
  MessageList({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {


    return new StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('restaurants').snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return new ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return new ListTile(


              isThreeLine: true,
              title: new Text(document['name'] ?? '<No message retrieved>'),
              subtitle: new Text(document['city'] ?? '<No message retrieved>'),
              trailing: CachedNetworkImage(placeholder: new CircularProgressIndicator(),imageUrl: document['photo'],height: 300.0,width: 200.0),
            );
          },
        );
      },
    );
  }
}

class FirstScreen extends StatelessWidget {

  FirstScreen({this.firestore});
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/fond.png"), fit: BoxFit.cover,),
              ),
            ),
            new Center(
                child: new Image.asset("assets/images/big-burger.png",height: 200.0,fit: BoxFit.fitHeight,),
               )
          ]
        ),
    );
  }
}



class MyHomePage extends StatelessWidget {
  MyHomePage({this.firestore});
  final Firestore firestore;
  CollectionReference get messages => firestore.collection('restaurants');

  Future<Null> _addMessage() async {
    final DocumentReference document = messages.document();
    document.setData(<String, dynamic>{
      'message': 'Hello world!',
    });



  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Livranoo'),
      ),
      body: new MessageList(firestore: firestore),

    floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
