import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Daftar proyek dapat dibuka tanpa login', (tester) async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/v1/projects/');
      expect(request.headers['Authorization'], isNull);
      return http.Response('[]', 200);
    });
    await tester.pumpWidget(MyApp(apiClient: ApiClient(client: client)));
    expect(find.text('2506548490'), findsOneWidget);
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada proyek.'), findsOneWidget);
  });

  testWidgets('Form proyek meminta login dan mengirim token', (tester) async {
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/auth/token/')) {
        return http.Response('{"token":"test-token"}', 200);
      }
      expect(request.url.path, '/api/v1/projects/');
      expect(request.headers['Authorization'], 'Token test-token');
      expect(request.body, contains('"tech_stack":"Flutter"'));
      return http.Response('{}', 201);
    });
    await tester.pumpWidget(MyApp(apiClient: ApiClient(client: client)));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'owner');
    await tester.enterText(fields.at(1), 'test-password');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    for (final (index, value) in [
      'Portofolio',
      'Deskripsi',
      'Flutter',
      'https://example.com',
    ].indexed) {
      await tester.enterText(fields.at(index), value);
    }
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek tersimpan'), findsOneWidget);
  });
}
