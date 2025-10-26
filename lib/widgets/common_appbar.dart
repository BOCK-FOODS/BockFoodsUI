import 'package:flutter/material.dart';

PreferredSizeWidget commonAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(title, style: const TextStyle(color: Colors.black)),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).maybePop(),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black54),
        onPressed: () => Navigator.of(context).pushNamed('/search'),
      ),
    ],
  );
}
