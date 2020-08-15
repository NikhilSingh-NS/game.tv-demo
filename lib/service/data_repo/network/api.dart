import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  final String _apiBaseUrl = '';

  Map<String, String> _getRequestHeaderContentTypeOnly() {
    return <String, String>{'Content-Type': 'application/json'};
  }

  Future<Map<String, dynamic>> get(String endPoint) async {
    debugPrint('endPoint:$endPoint');
    http.Response response;
    try {
      response = await http
          .get(_apiBaseUrl + endPoint,
              headers: _getRequestHeaderContentTypeOnly())
          .timeout(const Duration(seconds: 30));
      return handleResponse(response, endPoint);
    } on SocketException catch (_) {
      debugPrint('Socket timeout Exception!');
    } on TimeoutException catch (_) {
      debugPrint('Timeout Exception!');
    } catch (e) {
      debugPrint(e);
      debugPrint('Some other exception!');
    }
    //Socket timeout Exception!
    final Map<String, dynamic> map = <String, dynamic>{
      'status': 501,
      'message': 'Failure!'
    };
    return Future<Map<String, dynamic>>.value(map);
  }

  Future<Map<String, dynamic>> post(String endPoint, dynamic data) async {
    debugPrint('endPoint:$endPoint');
    http.Response response;

    try {
      debugPrint('body${json.encode(data)}');
      response = await http
          .post(_apiBaseUrl + endPoint,
              body: json.encode(data),
              headers: _getRequestHeaderContentTypeOnly())
          .timeout(const Duration(seconds: 30));

      return handleResponse(response, endPoint);
    } on SocketException catch (_) {
      debugPrint('Socket timeout Exception!');
    } on TimeoutException catch (_) {
      debugPrint('Timeout Exception!');
    } catch (e) {
      debugPrint(e);
      debugPrint('Some other exception!');
    }
    //Socket timeout Exception!
    final Map<String, dynamic> map = <String, dynamic>{
      'status': 501,
      'message': 'Failure!'
    };

    return Future<Map<String, dynamic>>.value(map);
  }

  Future<Map<String, dynamic>> put(String endPoint, dynamic data,
      {bool withoutHeaders = false}) async {
    debugPrint('endPoint:$endPoint');
    http.Response response;

    try {
      debugPrint('body${json.encode(data)}');
      response = await http
          .put(_apiBaseUrl + endPoint,
              body: json.encode(data),
              headers: _getRequestHeaderContentTypeOnly())
          .timeout(const Duration(seconds: 30));

      return handleResponse(response, endPoint);
    } on SocketException catch (_) {
      debugPrint('Socket timeout Exception!');
    } on TimeoutException catch (_) {
      debugPrint('Timeout Exception!');
    } catch (e) {
      debugPrint(e);
      debugPrint('Some other exception!');
    }

    //Socket timeout Exception!
    final Map<String, dynamic> map = <String, dynamic>{
      'status': 501,
      'message': 'Failure!'
    };

    return Future<Map<String, dynamic>>.value(map);
  }

  Future<Map<String, dynamic>> handleResponse(
      dynamic response, String url) async {
    debugPrint('url:' + url);
    debugPrint('responseStatusCode:' + response.statusCode.toString());
    debugPrint('responseBody:' + response.body);
    final Map<String, String> responseHeader = response.headers;
    debugPrint('responseHeaders: ${responseHeader.toString()}');

    Map<String, dynamic> responseBody = <String, dynamic>{
      'status': response.statusCode
    };
    if (response.body != '' &&
        (responseHeader['content-type'].startsWith('application/json')))
      responseBody.addAll(jsonDecode(response.body));

    else if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      responseBody.addAll(<String, dynamic>{'message': 'Something went wrong'});
    }

    return Future<Map<String, dynamic>>.value(responseBody);
  }
}
