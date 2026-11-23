import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Kartu pendidikan membuka form dan Back kembali ke beranda', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Pendidikan'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(4));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('Form bisa dibuka dari drawer dan Home kembali ke beranda', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Tambah Pendidikan'));
    await tester.pumpAndSettle();
    expect(find.byType(Form), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets(
    'Isian wajib divalidasi dan ringkasan bisa dibuka di layar ponsel',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 640);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Tambah Pendidikan'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      final save = find.widgetWithText(FilledButton, 'Simpan');

      await tester.enterText(fields.at(0), '   ');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      for (final label in [
        'Judul pendidikan',
        'Deskripsi',
        'Tahun mulai',
        'Tahun selesai',
      ]) {
        expect(find.text('$label wajib diisi.'), findsOneWidget);
      }
      expect(find.byType(AlertDialog), findsNothing);

      const values = [
        'Universitas Indonesia',
        'Ilmu Komputer',
        '2025',
        'Sekarang',
      ];
      for (var i = 0; i < values.length; i++) {
        await tester.ensureVisible(fields.at(i));
        await tester.enterText(fields.at(i), values[i]);
      }
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      expect(save.hitTestable(), findsOneWidget);
      await tester.tap(save);
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      for (final value in values) {
        expect(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.textContaining(value),
          ),
          findsOneWidget,
        );
      }
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(fields, findsNWidgets(4));
    },
  );
}
