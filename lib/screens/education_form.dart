import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  static const routeName = '/add-education';

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '', _description = '', _start = '', _end = '';

  void _showSummary() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ringkasan pendidikan'),
        scrollable: true,
        content: Text(
          '$_title\n$_description\nTahun mulai: $_start\nTahun selesai: $_end',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    ValueChanged<String> save, {
    int? maxLength,
    int lines = 1,
    String? hint,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        maxLength: maxLength,
        maxLines: lines,
        keyboardType: keyboard,
        validator: (value) =>
            (value ?? '').trim().isEmpty ? '$label wajib diisi.' : null,
        onSaved: (value) => save(value!.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pendidikan'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(currentRoute: EducationFormPage.routeName),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field('Judul pendidikan', (v) => _title = v, maxLength: 255),
                _field('Deskripsi', (v) => _description = v, lines: 3),
                _field(
                  'Tahun mulai',
                  (v) => _start = v,
                  keyboard: TextInputType.number,
                ),
                _field(
                  'Tahun selesai',
                  (v) => _end = v,
                  hint: 'Contoh: 2026 atau Sekarang',
                ),
                FilledButton(
                  onPressed: _showSummary,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
