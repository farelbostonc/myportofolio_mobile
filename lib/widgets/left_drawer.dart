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
            onTap: () => _openRoute(context, '/add-project'),
          ),
        ],
      ),
    );
  }
}
