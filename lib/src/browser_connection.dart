import 'package:http/http.dart';
import 'package:puppeteer/plugins/stealth.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:streamingcommunity_scraper/src/exceptions.dart';

class BrowserConnection {
  static Browser? _browser;

  static Future<Browser?> getBrowser(String browserUrl) async {
    try {
      _browser ??= await puppeteer
          .connect(browserUrl: browserUrl, plugins: [StealthPlugin()]);
      return _browser;
    } on ClientException {
      rethrow;
    }
  }

  static Future<void> disconnect() async {
    if (_browser == null) {
      throw ConnectionNotExistentException(
          cause: "Connection to remote chromium has not been created");
    } else {
      _browser?.disconnect();
      _browser = null;
    }
  }
}
