// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

// Google Sign In step
final GoogleSignIn _googleSignIn = new GoogleSignIn();

// Auth step
final FirebaseAuth _auth = FirebaseAuth.instance;

// Analytics step
final FirebaseAnalytics _analytics = new FirebaseAnalytics();

// Database step
final DatabaseReference _reference =
    FirebaseDatabase.instance.reference().child('messages');

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

@override
class ChatMessage extends StatelessWidget {
  // Changed in Database step
  ChatMessage({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              // Removed in GoogleSignIn step
              // child: new CircleAvatar(child: new Text(_name[0])),

              // Added in GoogleSignIn step
              // child: new GoogleUserCircleAvatar(_googleSignIn.currentUser.photoUrl),

              // Changed in Database step
              child: new GoogleUserCircleAvatar(snapshot.value['senderPhotoUrl']),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                // Changed in Database step
                  snapshot.value['senderName'],
                  style: Theme.of(context).textTheme.subhead
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  // Changed in Database step
                  // child: new Text(snapshot.value['text']),

                  // Changed in Storage step
                  child: snapshot.value['imageUrl'] != null ?
                         new Image.network(
                           snapshot.value['imageUrl'],
                           width: 250.0,
                         ) :
                         new Text(snapshot.value['text'])
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // From previous codelab
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  // Removed in Database step
  //  final Map<String, AnimationController> _controllers =
  //      <String, AnimationController>{};

  @override
  void initState() {
    super.initState();
    // Auth step
    _auth.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : 4,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            // Removed in Database step
            //            child: new Flexible(
            //                child: new ListView.builder(
            //                    padding: new EdgeInsets.all(8.0),
            //                    reverse: true,
            //                    itemBuilder: (_, int index) => _messages[index],
            //                    itemCount: _messages.length,
            //                )),

            // Added in Database step
            child: new FirebaseAnimatedList(
              query: _reference,
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
                return new ChatMessage(snapshot: snapshot, animation: animation);
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            // Added in Storage step
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.photo),
                onPressed: () async {
                  await _ensureLoggedIn();
                  File imageFile = await ImagePicker.pickImage();
                  int random = new Random().nextInt(100000);
                  StorageReference ref =
                      FirebaseStorage.instance.ref().child("image_$random.jpg");
                  StorageUploadTask uploadTask = ref.put(imageFile);
                  Uri downloadUrl = (await uploadTask.future).downloadUrl;
                  _sendMessage(imageUrl: downloadUrl.toString());
                },
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<Null> _ensureLoggedIn() async {
    // GoogleSignIn step
    GoogleSignInAccount user = await _googleSignIn.currentUser;
    if (user == null)
      user = await _googleSignIn.signInSilently();
    if (user == null)
      await _googleSignIn.signIn();

    // Auth step
    if (_auth.currentUser == null || _auth.currentUser.isAnonymous) {
      GoogleSignInAuthentication credentials =
        await _googleSignIn.currentUser.authentication;
      await _auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
      // Analytics step
      _analytics.logLogin();
    }
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    // GoogleSignIn step
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  Future<Null> _sendMessage({ String text, String imageUrl }) async {
    // Removed in Database step
    //    ChatMessage message = new ChatMessage(
    //        text: text,
    //        animationController: new AnimationController(
    //            duration: new Duration(milliseconds: 700),
    //            vsync: this,
    //        ),
    //    );
    //    setState(() {
    //      _messages.insert(0, message);
    //    });
    //    message.animationController.forward();

    // Added in Database step
    _reference.push().set({
      'text': text,
      'imageUrl': imageUrl,
      'senderName': _googleSignIn.currentUser.displayName,
      'senderPhotoUrl': _googleSignIn.currentUser.photoUrl,
    });
    // Analytics step
    _analytics.logEvent(name: 'send_message');
  }

  // Removed in Database step
  //  @override
  //  void dispose() {
  //    for (AnimationController controller in _controllers.values)
  //      controller.dispose();
  //    super.dispose();
  //  }
}
