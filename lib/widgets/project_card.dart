import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';
import 'auth_guard.dart';

import 'package:flutter/material.dart';

class ItemHomepage {
  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.pageBuilder,
    this.showTapMessage = true,
    this.requiresLogin = false,
  });

  final String name;
  final IconData icon;
  final Color color;
  final WidgetBuilder? pageBuilder;
  final bool showTapMessage;
  final bool requiresLogin;
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          messenger.removeCurrentSnackBar();
          if (item.name == 'Logout') {
            try {
              await context.read<AuthState>().logout();
              if (context.mounted) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Sesi lokal berakhir.')),
                );
              }
            } on ApiException catch (error) {
              if (context.mounted) {
                messenger.showSnackBar(SnackBar(content: Text(error.message)));
              }
            }
            return;
          }
          if (item.requiresLogin &&
              (!await ensureLoggedIn(context) || !context.mounted)) {
            return;
          }
          if (item.showTapMessage) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
              ),
            );
          }
          final builder = item.pageBuilder;
          if (builder != null) {
            Navigator.of(context)
                .push<void>(MaterialPageRoute(builder: builder));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
