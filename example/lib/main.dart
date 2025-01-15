import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tawk_to_chat/flutter_tawk_to_chat.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TawkController? _controller;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messangerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Tawk.to'),
          elevation: 0,
          actions: [
            OutlinedButton(
              onPressed: _controller == null
                  ? null
                  : () async {
                      if (await _controller!.isChatOngoing()) {
                        bool? confirm = await showAlert();
                        if (confirm == true) {
                          _controller!.endChat();
                        }
                      } else {
                        _messangerKey.currentState!.showSnackBar(const SnackBar(
                          content: Text('No ongoing chat'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    },
              child: const Text('End Chat'),
            )
          ],
        ),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/615847b0d326717cb68462c7', //'YOUR_DIRECT_CHAT_LINK',
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
          onControllerChanged: (value) {
            setState(() {
              _controller = value;
            });
          },
        ),
      ),
    );
  }

  Future<bool?> showAlert() async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('End Chat'),
            content: const Text('Are you sure you want to end the chat?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('End Chat'),
              ),
            ],
          );
        });
  }
}
