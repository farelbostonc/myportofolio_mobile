import 'package:flutter/material.dart';

class ItemHomepage {
  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.pageBuilder,
    this.showTapMessage = true,
  });

  final String name;
  final IconData icon;
  final Color color;
  final WidgetBuilder? pageBuilder;
  final bool showTapMessage;
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
        onTap: () {
          final messenger = ScaffoldMessenger.of(context);
          messenger.removeCurrentSnackBar();
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
