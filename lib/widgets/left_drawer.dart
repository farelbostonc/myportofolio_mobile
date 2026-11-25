import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';
import 'auth_guard.dart';

import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.currentRoute});

  final String currentRoute;

  void _openRoute(BuildContext context, String route) {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (route == currentRoute) return;

    if (route == '/' && navigator.canPop()) {
      navigator.popUntil(ModalRoute.withName('/'));
      return;
    }
    navigator.pushReplacementNamed<void, void>(route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: currentRoute == '/',
            onTap: () => _openRoute(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            selected: currentRoute == '/add-project',
            onTap: () async {
              if (await ensureLoggedIn(context) && context.mounted) {
                _openRoute(context, '/add-project');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_outlined),
            title: const Text('Lihat Proyek'),
            onTap: () => _openRoute(context, '/projects'),
          ),
          ListTile(
            leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
            title: Text(auth.isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              if (!auth.isLoggedIn) {
                if (await ensureLoggedIn(context) && context.mounted) {
                  Navigator.pop(context);
                }
                return;
              }
              try {
                await auth.logout();
              } on ApiException catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.message)));
                }
              }
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Tambah Pendidikan'),
            selected: currentRoute == '/add-education',
            onTap: () => _openRoute(context, '/add-education'),
          ),
        ],
      ),
    );
  }
}
