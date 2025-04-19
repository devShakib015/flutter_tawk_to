import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'tawk_visitor.dart';

class TawkController {
  final InAppWebViewController _controller;
  TawkController(this._controller);

  Future<bool> isChatOngoing() async {
    String script = '''
var Tawk_API = Tawk_API || {};
Tawk_API.isChatOngoing();
''';
    return await _controller.evaluateJavascript(source: script);
  }

  Future<bool> isVisitorEngaged() async {
    String script = '''
var Tawk_API = Tawk_API || {};
Tawk_API.isVisitorEngaged();
''';
    return await _controller.evaluateJavascript(source: script);
  }

  void endChat() {
    String script = '''
var Tawk_API = Tawk_API || {};
Tawk_API.endChat();
''';
    _controller.evaluateJavascript(source: script);
  }

  Future<bool> canGoBack() => _controller.canGoBack();
  Future<void> goBack() => _controller.goBack();
}

/// [Tawk] Widget.
class Tawk extends StatefulWidget {
  /// Tawk direct chat link.
  final String directChatLink;

  /// Object used to set the visitor name and email.
  final TawkVisitor? visitor;

  /// Called right after the widget is rendered.
  final Function? onLoad;

  /// Called when a link pressed.
  final Function(String)? onLinkTap;

  /// Render your own loading widget.
  final Widget? placeholder;
  final ValueChanged<TawkController?>? onControllerChanged;

  final String? locale;

  const Tawk({
    Key? key,
    required this.directChatLink,
    this.visitor,
    this.onLoad,
    this.onLinkTap,
    this.placeholder,
    this.onControllerChanged,
    this.locale,
  }) : super(key: key);

  @override
  _TawkState createState() => _TawkState();
}

class _TawkState extends State<Tawk> {
  bool _isLoading = true;
  late CookieManager cookieManager;
  TawkController? _controller;

  @override
  void initState() {
    super.initState();
    cookieManager = CookieManager.instance();
  }

  Future<void> _setUser(TawkVisitor visitor) async {
    String javascriptString;

    if (Platform.isIOS) {
      javascriptString = '''
    var Tawk_API = Tawk_API || {}
    Tawk_API.setAttributes(${jsonEncode(visitor.toJson())})
      ''';
    } else {
      javascriptString = '''
var Tawk_API = Tawk_API || {};
Tawk_API.onLoad = function() {
  Tawk_API.setAttributes(${jsonEncode(visitor.toJson())})
};
      ''';
    }
    if (kDebugMode) {
      log(javascriptString.replaceAll('\n', ''), name: 'WebView JS');
    }
    await _controller?._controller.evaluateJavascript(source: javascriptString);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.directChatLink)),
              initialSettings: InAppWebViewSettings(supportZoom: false),
              onWebViewCreated: (InAppWebViewController webViewController) {
                setState(() {
                  _controller = TawkController(webViewController);
                });
                if (widget.onControllerChanged != null) {
                  widget.onControllerChanged!(_controller);
                }
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                URLRequest request = navigationAction.request;
                if (request.url == null ||
                    request.url.toString() == 'about:blank' ||
                    request.url!.toString().contains('tawk.to/chat')) {
                  return NavigationActionPolicy.ALLOW;
                }

                if (widget.onLinkTap != null) {
                  widget.onLinkTap!(request.url.toString());
                }

                return NavigationActionPolicy.CANCEL;
              },
              onLoadStop: (controller, url) async {
                // Set language first
                if (widget.locale != null) {
                  final localeScript = '''
      var Tawk_API = Tawk_API || {};
      Tawk_API.onLoad = function() {
        Tawk_API.setLanguage('${widget.locale}');
      };
    ''';
                  if (kDebugMode) {
                    log("Language Script: $localeScript", name: 'WebView JS');
                  }
                  await controller.evaluateJavascript(source: localeScript);
                }

                // Then set visitor info

                if (widget.visitor != null) {
                  _setUser(widget.visitor!);
                }

                if (widget.onLoad != null) {
                  widget.onLoad!();
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
            _isLoading
                ? widget.placeholder ??
                    const Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }
}
