import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<dynamic> _request(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse(
      '${baseUrl.replaceFirst(RegExp(r"/+$"), "")}/api/v1/$path',
    );
    final headers = {
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
    final http.Response response;
    try {
      response =
          await (body == null
                  ? _client.get(uri, headers: headers)
                  : _client.post(uri, headers: headers, body: jsonEncode(body)))
              .timeout(const Duration(seconds: 15));
    } on http.ClientException {
      throw const ApiException(0, 'Server tidak dapat dijangkau.');
    } on TimeoutException {
      throw const ApiException(0, 'Waktu tunggu server habis.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        'Permintaan gagal (${response.statusCode}).',
      );
    }
    try {
      return response.bodyBytes.isEmpty
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiException(0, 'Respons server tidak valid.');
    }
  }

  Future<List<Project>> getProjects() async {
    final data = await _request('projects/') as List<dynamic>;
    return data
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createProject(Project project, {required String token}) async {
    await _request('projects/', body: project.toJson(), token: token);
  }

  Future<String> obtainToken(String username, String password) async {
    final data = await _request(
      'auth/token/',
      body: {'username': username, 'password': password},
    );
    if (data is Map &&
        data['token'] is String &&
        (data['token'] as String).isNotEmpty) {
      return data['token'] as String;
    }
    throw const ApiException(0, 'Token tidak tersedia.');
  }

  Future<void> logout({required String token}) async {
    await _request('auth/logout/', body: {}, token: token);
  }

  void close() => _client.close();
}
