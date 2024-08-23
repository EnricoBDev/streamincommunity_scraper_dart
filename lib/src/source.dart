import 'package:http/http.dart' as http;

class Source {
  final String? name;
  final Uri url;

  const Source({this.name, required this.url});

  // Future<bool> isActive() async {
  //   try {
  //     http.Response response = await http.get(url);
  //     return response.statusCode == 200;
  //   } on http.ClientException {
  //     rethrow;
  //   }
  // }
}
