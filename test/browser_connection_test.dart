import 'package:puppeteer/puppeteer.dart';
import 'package:streamingcommunity_scraper/src/browser_connection.dart';
import 'package:streamingcommunity_scraper/src/constants.dart';
import 'package:test/test.dart';

void main() {
  group('BrowserConnection tests', () {
    test('Test singleton pattern', () async {
      Browser? firstBrowser = await BrowserConnection.getBrowser(SERVER_URL);
      Browser? secondBrowser = await BrowserConnection.getBrowser(SERVER_URL);

      expect(firstBrowser == secondBrowser, true);
    });

    test('Test connection closed for all browsers', () async {
      Browser? firstBrowser = await BrowserConnection.getBrowser(SERVER_URL);
      Browser? secondBrowser = await BrowserConnection.getBrowser(SERVER_URL);

      BrowserConnection.disconnect();

      expect(!firstBrowser!.isConnected && !secondBrowser!.isConnected, true);
    });
  });
}
