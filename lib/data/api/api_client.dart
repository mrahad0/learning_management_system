import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import '../../helper/prefs_helper.dart';
import '../../utils/app_constants.dart';
import 'api_constant.dart';

class ApiClient extends GetxService {
  static const String noInternetMessage =
      "Sorry! Something went wrong please try again";
  static const int timeoutInSeconds = 30;

  static String bearerToken = "";

  static Future<Response> getData(
      String uri, {
        Map<String, dynamic>? query,
        Map<String, String>? headers,
      }) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
    };

    // Use fresh client for each request to avoid caching issues
    final client = http.Client();

    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');

      http.Response response = await client
          .get(
        Uri.parse(ApiConstant.baseUrl + uri),
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      client.close();
      return handleResponse(response, uri);
    } catch (e) {
      client.close();
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> postData(
      String uri,
      dynamic body, {
        Map<String, String>? headers,
      }) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
    };

    // Use fresh client for each request to avoid caching issues
    final client = http.Client();

    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .post(
        Uri.parse(ApiConstant.baseUrl + uri),
        body: body is String ? body : jsonEncode(body),
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
        "==========> Response Post Method :------ : ${response.statusCode}",
      );
      client.close();
      return handleResponse(response, uri);
    } catch (e) {
      client.close();
      debugPrint('=====> API POST Error: $e');
      String errorMessage = noInternetMessage;
      if (e.toString().contains('TimeoutException')) {
        errorMessage =
        'Connection timed out. Please check your internet connection.';
      }
      return Response(statusCode: 1, statusText: errorMessage);
    }
  }

  /// POST multipart (keeps POST)
  /// [timeoutSeconds] defaults to 30s, increase for large file uploads
  static Future<Response> postMultipartData(
      String uri,
      Map<String, String> body, {
        required List<MultipartBody> multipartBody,
        Map<String, String>? headers,
        int timeoutSeconds = timeoutInSeconds,
      }) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = bearerToken.isNotEmpty 
          ? {'Authorization': 'Bearer $bearerToken'} 
          : <String, String>{};

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint(
        '====> API Body: $body with ${multipartBody.length} file(s)',
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstant.baseUrl + uri),
      );
      request.headers.addAll(headers ?? mainHeaders);

      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);

      http.Response response = await http.Response.fromStream(
        await request.send().timeout(Duration(seconds: timeoutSeconds)),
      );
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint("postMultipartData error: $e");
      String errorMessage = noInternetMessage;
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Upload timed out. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please check your network.';
      }
      return Response(statusCode: 1, statusText: errorMessage);
    }
  }

  /// PUT multipart - fixed (uses PUT and correct loop)
  static Future<Response> putMultipartData(
      String uri,
      Map<String, String> body, {
        required List<MultipartBody> multipartBody,
        Map<String, String>? headers,
      }) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = bearerToken.isNotEmpty 
          ? {'Authorization': 'Bearer $bearerToken'} 
          : <String, String>{};
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint(
        '====> API Body: $body with ${multipartBody.length} picture(s)',
      );

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConstant.baseUrl + uri),
      );
      request.headers.addAll(headers ?? mainHeaders);

      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }

      request.fields.addAll(body);

      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint("putMultipartData error: $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  /// PATCH multipart - NEW: supports multipart PATCH requests
  static Future<Response> patchMultipartData(
      String uri,
      Map<String, String> body, {
        required List<MultipartBody> multipartBody,
        Map<String, String>? headers,
      }) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = bearerToken.isNotEmpty 
          ? {'Authorization': 'Bearer $bearerToken'} 
          : <String, String>{};
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint(
        '====> API Body: $body with ${multipartBody.length} picture(s)',
      );

      // Note: http.MultipartRequest supports any method string
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(ApiConstant.baseUrl + uri),
      );
      request.headers.addAll(headers ?? mainHeaders);

      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }

      request.fields.addAll(body);

      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint("patchMultipartData error: $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> putData(
      String uri,
      dynamic body, {
        Map<String, String>? headers,
      }) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
        Uri.parse(ApiConstant.baseUrl + uri),
        body: body is String ? body : jsonEncode(body),
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(
      String uri, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Call: $uri\n Body: $body');

      http.Response response = await http
          .delete(
        Uri.parse(ApiConstant.baseUrl + uri),
        headers: headers ?? mainHeaders,
        body: body,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;

    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: response.request!.headers,
        method: response.request!.method,
        url: response.request!.url,
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    // Handle error responses (non-200 status codes or success=false)
    if (response0.body is Map) {
      final bodyMap = response0.body as Map;

      // Check if response indicates failure (either by status code or success flag)
      if ((response0.statusCode! < 200 || response0.statusCode! >= 300) || bodyMap["success"] == false) {
        // Extract message from response body
        String? errorMessage = bodyMap["message"]?.toString();

        // If no direct message, try to get from 'detail' field (Django REST Framework format)
        if ((errorMessage == null || errorMessage.isEmpty) &&
            bodyMap["detail"] != null) {
          final detail = bodyMap["detail"];
          if (detail is String) {
            errorMessage = detail;
          } else if (detail is List && detail.isNotEmpty) {
            errorMessage = detail.first.toString();
          }
        }

        // If no direct message, try to get from errors object
        if ((errorMessage == null || errorMessage.isEmpty) &&
            bodyMap["errors"] != null) {
          final errors = bodyMap["errors"];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            }
          }
        }
        
        // Fallback for DRF root-level validation errors like {"username": ["Already exists"]}
        if (errorMessage == null || errorMessage.isEmpty) {
          for (var value in bodyMap.values) {
            if (value is List && value.isNotEmpty) {
              errorMessage = value.first.toString();
              break;
            } else if (value is String && value.isNotEmpty) {
              errorMessage = value;
              break;
            }
          }
        }

        // Fallback message
        errorMessage ??= noInternetMessage;

        response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorMessage,
        );
        debugPrint(
          '====> API Error Response: [${response0.statusCode}] $uri\n${response0.statusText}',
        );
      }
    } else if ((response0.statusCode! < 200 || response0.statusCode! >= 300) && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    debugPrint(
      '====> API Response: [${response0.statusCode}] $uri\n${response0.body}',
    );
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}