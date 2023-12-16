import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'http://127.0.0.1:8000/api/';

  postData(data, apiUrl) async {
    final fullUrl = _url + apiUrl;
    final uri = Uri.parse(fullUrl);
    final Future<http.Response> response;
    response =
        http.post(uri, body: jsonEncode(data), headers: _setHeaders()).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return throw TimeoutException("Error");
      },
    );

    return response;
  }

  getData(apiUrl) async {
    final fullUrl = _url + apiUrl;
    final uri = Uri.parse(fullUrl);
    return await http.get(uri, headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
