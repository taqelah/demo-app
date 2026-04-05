import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/test_keys.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  final _urlController = TextEditingController(text: 'https://www.taqelah.sg');
  bool _isLoading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          setState(() => _isLoading = true);
        },
        onProgress: (progress) {
          setState(() => _progress = progress / 100);
        },
        onPageFinished: (_) {
          setState(() => _isLoading = false);
        },
      ))
      ..loadRequest(Uri.parse('https://www.taqelah.sg'));
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadUrl() {
    var url = _urlController.text.trim();
    if (url.isEmpty) return;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: TestKeys.webviewUrlField,
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    keyboardType: TextInputType.url,
                    onSubmitted: (_) => _loadUrl(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: TestKeys.webviewGoButton,
                  onPressed: _loadUrl,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(60, 42),
                  ),
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            LinearProgressIndicator(
              key: TestKeys.webviewLoadingIndicator,
              value: _progress > 0 ? _progress : null,
            ),
          Expanded(
            child: WebViewWidget(
              key: TestKeys.webviewContent,
              controller: _controller,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  key: TestKeys.webviewBackButton,
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => _controller.goBack(),
                ),
                IconButton(
                  key: TestKeys.webviewForwardButton,
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _controller.goForward(),
                ),
                IconButton(
                  key: TestKeys.webviewRefreshButton,
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _controller.reload(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
