import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstaLogin extends StatefulWidget {
  const InstaLogin({super.key});

  @override
  InstaLoginState createState() => InstaLoginState();
}

class InstaLoginState extends State<InstaLogin> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    params = const PlatformWebViewControllerCreationParams();
    // }

    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url
                .startsWith('https://www.instagram.com/accounts/login/')) {
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.instagram.com/accounts/login/'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewWidget(controller: _controller),
    );
  }
}
