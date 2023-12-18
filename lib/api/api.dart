import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../include/UserPreference.dart';

class CallApi {
  // final String _url = 'http://127.0.0.1:8000/api/';
  final String _url = 'http://8.218.123.95/api/';
  _setHeaders () async{
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await UserPreference.getToken()}'
    };
    return headers;
  }

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
          http.post(uri, body: jsonEncode(data), headers: await _setHeaders()).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return throw TimeoutException("Error");
        },
      );

    }

  // print(response);
    return response;
  }

  getData(apiUrl,{headers}) async {
    final fullUrl = _url + apiUrl;
    final uri = Uri.parse(fullUrl);
    if(headers != null){

      return await http.get(uri, headers: headers);
    }
    else{
      return await http.get(uri, headers: await _setHeaders());
    }
    // return await http.get(uri, headers: _setHeaders());
  }

  // _setHeaders() =>
  //     {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
