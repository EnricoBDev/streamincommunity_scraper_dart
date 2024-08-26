import 'package:http/http.dart' as http;

class Source {
  final String? name;
  final Uri url;
  final String fileName;

  const Source({this.name, required this.url, required this.fileName});

  // Future<bool> isActive() async {
  //   try {
  //     http.Response response = await http.get(url);
  //     return response.statusCode == 200;
  //   } on http.ClientException {
  //     rethrow;
  //   }
  // }
}
