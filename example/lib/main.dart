import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_tawk_to/flutter_tawk_to.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Tawk.to'),
          elevation: 0,
        ),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/615847b0d326717cb68462c7/', //'YOUR_DIRECT_CHAT_LINK',
          visitor: TawkVisitor(
            name: 'Username',
            email: 'example@gmail.com',
          ),
          onLoad: () {
            log('Hello Tawk!', name: 'TawkTo');
          },
          onLinkTap: (String url) {
            log(url, name: 'Tap url');
          },
          placeholder: const Center(
            child: Text('Loading...'),
          ),
        ),
      ),
    );
  }
}
