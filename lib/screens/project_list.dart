import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../services/api_client.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});
  static const routeName = '/projects';

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = context.read<ApiClient>().getProjects();
  }

  Future<void> _refresh() async {
    setState(() => _projects = context.read<ApiClient>().getProjects());
    try {
      await _projects;
    } catch (_) {
      // FutureBuilder displays the error.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lihat Proyek')),
    body: FutureBuilder<List<Project>>(
      future: _projects,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _refresh,
              child: const Text('Gagal memuat proyek. Coba lagi'),
            ),
          );
        }
        final projects = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (projects.isEmpty)
                const ListTile(title: Text('Belum ada proyek.')),
              for (final project in projects)
                ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.description),
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: Text(project.title)),
                        body: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(project.description),
                            Text(project.techStack),
                            Text(project.projectUrl),
                            if (project.projectImageUrl.isNotEmpty)
                              Image.network(
                                project.projectImageUrl,
                                errorBuilder: (_, _, _) =>
                                    const Text('Gambar tidak tersedia.'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}
