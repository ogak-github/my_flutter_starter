import 'package:dio/dio.dart';

class AppHttpException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  AppHttpException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class ApiErrorMapper {
  static AppHttpException fromDio(DioException e) {
    if (e.response != null) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      return AppHttpException(
        statusCode: status,
        message: _messageForStatus(status),
        data: data,
      );
    }
    return AppHttpException(message: e.message ?? "Network Error");
  }

  static String _messageForStatus(int? status) {
    switch (status) {
      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Forbidden";
      case 404:
        return "Not Found";
      case 500:
        return "Server Error";
      default:
        return "HTTP Error ($status)";
    }
  }
}
