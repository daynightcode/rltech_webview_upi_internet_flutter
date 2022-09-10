import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../backevent_notifier.dart';
import '../constants/string.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  final GlobalKey _globalKey=GlobalKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () => _onBack(),
      child: Scaffold(
        key: _globalKey,
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            if (request.url
                .startsWith(whatsAppRedirectsCheck)) {
              await _launchURL(request.url);
              return NavigationDecision.prevent;
            }else if (request.url
                .startsWith(phoneRedirectsCheck)) {
              await _launchURL(request.url);
              return NavigationDecision.prevent;
            }else if (request.url
                .startsWith(upiRedirectsCheck)) {
              await _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },

          javascriptChannels: {
            _toasterJavascriptChannel(context),
          },

          onWebViewCreated: (WebViewController webViewController) {
            _controller=webViewController;
          },

          gestureNavigationEnabled: true,


        ),
      )
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }


  _launchURL(String newUrl) async {
    Uri uri = Uri.parse(newUrl);
    if(await canLaunchUrl(uri))
      {
        await launchUrl(uri,
            mode: LaunchMode.externalApplication);
      }
    else
      {

      }
  }


  Future<bool> _onBack() async {
    print("-----------------------------------------------------------------------");
    bool goBack;
    var value = await _controller.canGoBack();  // check webview can go back
    if (value) {
      _controller.goBack(); // perform webview back operation
      return false;
    } else {
      late BackEventNotifier notifier;
      await showDialog(
          context: _globalKey.currentState!.context,
          builder: (context) => Consumer(
              builder: (context,BackEventNotifier event, child) {
                notifier= event;
                return AlertDialog(
                  title: const Text(
                      'Confirmation ', style: TextStyle(color: Colors.purple)),
                  content: new Text('Do you want exit app ? '),

                  actions: [

                    TextButton(

                      onPressed: () {
                        Navigator.of(context).pop(false);
                        event.add(false);
                      },

                      child: new Text("No"), // No

                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        event.add(true);
                      },
                      child: Text("Yes"), // Yes
                    ),
                  ],
                );
              }
          )
      );

      //Navigator.pop(_globalKey.currentState!.context);
      print("_notifier.isBack ${notifier.isBack}");
      return notifier.isBack;
    }
  }
}