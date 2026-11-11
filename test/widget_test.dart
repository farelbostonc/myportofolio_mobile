import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Menu menampilkan identitas dan respons setiap tombol', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Burhan'), findsOneWidget);
    expect(find.text('2406000001'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);

    for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
