import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Menu menampilkan identitas dan respons setiap tombol', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 650));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    expect(find.text('Farel Boston Corinthians Nadeak'), findsOneWidget);
    expect(find.text('2506548490'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);

    for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
      if (label == 'Tambah Proyek') {
        expect(find.text('Add Project Form'), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Drawer opens form, validates, previews, resets and returns home',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      final save = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

      await tester.enterText(fields.at(0), 'Portofolio Flutter');
      await tester.enterText(fields.at(1), 'Aplikasi portofolio pribadi');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mobile Development').last);
      await tester.pumpAndSettle();
      await tester.enterText(fields.at(2), 'Flutter');
      await tester.enterText(fields.at(3), 'https://example.com');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();

      for (final value in [
        'Nama Proyek: Portofolio Flutter',
        'Deskripsi: Aplikasi portofolio pribadi',
        'Kategori: Mobile Development',
        'Teknologi: Flutter',
        'Tautan: https://example.com',
      ]) {
        expect(find.text(value), findsOneWidget);
      }
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      for (final field in tester.widgetList<EditableText>(
        find.byType(EditableText),
      )) {
        expect(field.controller.text, isEmpty);
      }
      expect(find.text('Web Development'), findsOneWidget);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('MyPortfolio'), findsOneWidget);
    },
  );
}
