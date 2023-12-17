import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'http://127.0.0.1:8000/api/';

  postData(data, apiUrl,{headers}) async {
    final fullUrl = _url + apiUrl;
    final uri = Uri.parse(fullUrl);
    Future<http.Response> response;
    if(headers != null){
      response =
          http.post(uri, body: jsonEncode(data), headers: headers).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return throw TimeoutException("Error");
        },
      );

    }else{
      response =
          http.post(uri, body: jsonEncode(data), headers: _setHeaders()).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return throw TimeoutException("Error");
        },
      );

    }

  print(response);
    return response;
  }

  getData(apiUrl,{headers}) async {
    final fullUrl = _url + apiUrl;
    final uri = Uri.parse(fullUrl);
    if(headers != null){
      return await http.get(uri, headers: headers);
    }
    else{
      return await http.get(uri, headers: _setHeaders());
    }
    // return await http.get(uri, headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
