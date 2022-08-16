import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lifter_life_restaurant_pos/config/constants.dart';
import '../exceptions/app_exceptions.dart';

class BaseClient {
  static const int timeOutDuration = 30;

  //GET
  Future get(String api) async {
    var baseUrl = Constants.baseUrl;
    var uri = Uri.parse(baseUrl + api);
    var header = {HttpHeaders.authorizationHeader: 'Bearer '+Constants.apiKey};

    try {
      var response = await http.get(uri, headers: header).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }

  //POST
  Future post(String api, dynamic payloadObj) async {
    var baseUrl = Constants.baseUrl;
    var uri = Uri.parse(baseUrl + api);
    var payload = payloadObj;
    var header = {HttpHeaders.authorizationHeader: 'Bearer '+Constants.apiKey};

    try {
      var response = await http.post(uri,  headers: header, body: payload).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }

  //POST JSON
  Future postJson(String api, dynamic payloadObj) async {
    var baseUrl = Constants.baseUrl;
    var uri = Uri.parse(baseUrl + api);
    var payload = payloadObj;
    var header = {HttpHeaders.authorizationHeader: 'Bearer '+Constants.apiKey, 'Content-Type': 'application/json'};

    try {
      var response = await http.post(uri,  headers: header, body: payload).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }

  _processResponse(http.Response response) {
    var ifErrorThanMessage = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
        var responseJson = (response.body);
        return responseJson;
        break;
      case 201:
        var responseJson = (response.body);
        return responseJson;
        break;
      case 400:
        throw BadRequestException(ifErrorThanMessage, response.request!.url.toString());
      case 401:
        throw UnAuthorizedException(ifErrorThanMessage, response.request!.url.toString());
      case 403:
        throw ForbiddenException(ifErrorThanMessage, response.request!.url.toString());
      case 422:
        throw BadRequestException(ifErrorThanMessage, response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occurred with code : ${response.statusCode}', response.request!.url.toString());
    }
  }
}