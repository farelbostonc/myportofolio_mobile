import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../services/api_client.dart';
import '../services/auth_state.dart';
import '../widgets/auth_guard.dart';
import '../widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  static const routeName = '/add-project';

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _key = GlobalKey<FormState>();
  final _fields = List.generate(5, (_) => TextEditingController());
  bool _busy = false;

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final auth = context.read<AuthState>();
      String value(int index) => _fields[index].text.trim();
      await context.read<ApiClient>().createProject(
        Project(
          title: value(0),
          description: value(1),
          techStack: value(2),
          projectUrl: value(3),
          projectImageUrl: value(4),
        ),
        token: auth.token!,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Proyek tersimpan'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) {
        for (final field in _fields) {
          field.clear();
        }
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        context.read<AuthState>().clear();
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _validate(int index, String? input) {
    final value = input!.trim();
    if (value.isEmpty) return index == 4 ? null : 'Kolom wajib diisi.';
    if (index < 3) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Masukkan URL HTTP atau HTTPS yang valid.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Judul',
      'Deskripsi',
      'Tech Stack',
      'URL Proyek',
      'URL Gambar (opsional)',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project Form')),
      drawer: const LeftDrawer(currentRoute: ProjectFormPage.routeName),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (var index = 0; index < labels.length; index++)
              TextFormField(
                controller: _fields[index],
                decoration: InputDecoration(labelText: labels[index]),
                validator: (input) => _validate(index, input),
              ),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
