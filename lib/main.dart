import 'package:flutter/material.dart';
import 'package:ratlambullionrates/constants/string.dart';
import 'package:ratlambullionrates/screens/web_view.dart';

/*void main() {
  runApp(const WebViewPage());
}*/

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'backevent_notifier.dart';

void main() {

  runApp(
      ChangeNotifierProvider(
        create: (context) => BackEventNotifier(),
        child:  MyApp(),
        //child: const WebViewPage(),
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewPage(),
    );
  }
}

/*
class We1bpage extends StatelessWidget{
  late WebViewController _controller;

  final GlobalKey _globalKey=GlobalKey();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key: _globalKey,
        //appBar: AppBar(title: Text( 'Webview Back Button '),),
        body: WebView(
          initialUrl: 'https://flutter.dev/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: ( webViewController) {
            _controller=webViewController;


          },
          onProgress: (int progress) {

            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: {
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
      ),
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

  Future<bool> _onBack() async {
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
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        event.add(true);
                      },
                      child: new Text("Yes"), // Yes
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

}*/
