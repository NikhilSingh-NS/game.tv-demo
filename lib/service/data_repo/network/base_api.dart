import 'api.dart';

enum RequestType { PUT, POST, GET }

class BaseApi {
  BaseApi(this.url, this.requestType, {this.map}) {
    client = ApiClient();
  }

  ApiClient client;

  String url;
  final RequestType requestType;
  dynamic response;
  final dynamic map;

  Future<dynamic> makeRequest() async {
    switch (requestType) {
      case RequestType.PUT:
        response = await client.put(url, map);
        if (response['status'] == 200 || response['status'] == 201)
          return response;
        else
          return await handleFailure(response);
        break;
      case RequestType.POST:
        response = await client.post(url, map);
        if (response['status'] == 200 || response['status'] == 201)
          return response;
        else
          return await handleFailure(response);
        break;
      case RequestType.GET:
        response = await client.get(url);
        if (response['status'] == 200 || response['status'] == 201)
          return response;
        else
          return await handleFailure(response);
        break;
    }
  }

  Future<dynamic> handleFailure(dynamic response) async {
    //can handle different status codes...
    switch (response['status']) {
      default:
        return response;
    }
  }
}
