import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:music_api/utils/utils.dart';
import 'package:universal_io/io.dart';

class Http {
  static Future<HttpClientResponse> get(String url, {Map<String, dynamic>? params, Map<String, String>? headers, bool followRedirects = true}) {
    if (kIsWeb) {
      var tmp = <String, String>{};
      url = "http://localhost:3001/" + url;
      headers?.forEach((key, value) {
        tmp["x-proxy-$key"] = value;
      });
      headers = tmp;
    }
    url += "${params?.isNotEmpty == true ? "?" : ""}${toParamsString(LinkedHashMap.from(params ?? {}))}";
    print(url);
    return HttpClient().getUrl(Uri.parse(url)).then((request) {
      request.followRedirects = followRedirects;
      headers?.forEach(request.headers.add);
      return request.close();
    });
  }

  static Future<HttpClientResponse> post(String url, {Map<String, dynamic>? params, Map<String, String>? headers, bool followRedirects = true}) async {
    if (kIsWeb) {
      url = "http://localhost:3001/" + url;
      var tmp = <String, String>{};
      url = "http://localhost:3001/" + url;
      headers?.forEach((key, value) {
        tmp["x-proxy-$key"] = value;
      });
      headers = tmp;
    }
    return HttpClient().postUrl(Uri.parse(url)).then((request) {
      request.followRedirects = followRedirects;
      headers?.forEach(request.headers.add);
      request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
      request.write(Uri(queryParameters: (params ?? {}).map((key, value) => MapEntry(key, value.toString())).cast()).query);
      return request.close();
    });
  }

  static Future<HttpClientResponse> request(String url, {required String method, Map<String, dynamic>? params, Map<String, String>? headers}) async {
    if (method == "POST") {
      return post(url, headers: headers, params: params);
    } else {
      return get(url, headers: headers, params: params);
    }
  }
}
