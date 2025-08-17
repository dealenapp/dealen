import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final List<String> options;

  const MenuList({required this.options, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(options[index]),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Откроется: ${options[index]}')),
            );
          },
        );
      },
    );
  }
}
