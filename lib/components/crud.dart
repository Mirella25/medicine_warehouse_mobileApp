import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {
  String apiUrl = "http://10.0.0.2:8000/api";
  postRequest(
      {required String route,
      required Map<String, String> data,
      Map<String, String>? headers}) async {
    String url = apiUrl + route;
    return await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
  }

  getRequest({required String route, Map<String, String>? headers}) async {
    String url = apiUrl + route;
    return await http.get(Uri.parse(url), headers: headers);
  }
}
