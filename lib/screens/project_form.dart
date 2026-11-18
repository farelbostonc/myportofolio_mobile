import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  static const routeName = '/add-project';

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _description = '';
  String _category = _categories.first;
  String _technologies = '';
  String _projectLink = '';

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Proyek: $_projectName'),
            Text('Deskripsi: $_description'),
            Text('Kategori: $_category'),
            Text('Teknologi: $_technologies'),
            Text('Tautan: $_projectLink'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted && confirmed == true) {
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (ModalRoute.of(context)?.canPop == true)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
        ],
      ),
      drawer: const LeftDrawer(currentRoute: ProjectFormPage.routeName),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: _decoration('Nama Proyek'),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Nama proyek tidak boleh kosong!'
                          : null,
                      onSaved: (value) => _projectName = (value ?? '').trim(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _decoration('Deskripsi Proyek'),
                      maxLines: 5,
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Deskripsi proyek tidak boleh kosong!'
                          : null,
                      onSaved: (value) => _description = (value ?? '').trim(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: _decoration('Kategori Proyek'),
                      initialValue: _categories.first,
                      isExpanded: true,
                      items: [
                        for (final category in _categories)
                          DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                      ],
                      onChanged: (_) {},
                      onSaved: (value) =>
                          _category = value ?? _categories.first,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _decoration(
                        'Teknologi yang Digunakan',
                        hint: 'Contoh: Flutter, Django, Figma',
                      ),
                      onSaved: (value) => _technologies = (value ?? '').trim(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _decoration(
                        'Tautan Proyek',
                        hint: 'URL Proyek (opsional)',
                      ),
                      keyboardType: TextInputType.url,
                      onSaved: (value) => _projectLink = (value ?? '').trim(),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _submit,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
