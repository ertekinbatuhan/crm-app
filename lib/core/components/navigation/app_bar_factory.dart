import 'package:flutter/material.dart';
import 'app_header.dart';

class AppBarFactory {
  static const List<String> _titles = [
    'Dashboard',
    'Contacts', 
    'Deals',
    'Tasks',
    'Reports'
  ];

  static PreferredSizeWidget create({
    required int selectedIndex,
    VoidCallback? onContactsAdd,
    VoidCallback? onDealsAdd,
    VoidCallback? onTasksAdd,
  }) {
    switch (selectedIndex) {
      case 1: // Contacts
        return _createContactsAppBar(onContactsAdd);
      case 2: // Deals
        return _createDealsAppBar(onDealsAdd);
      case 3: // Tasks
        return _createTasksAppBar(onTasksAdd);
      default: // Dashboard and Reports
        return _createDefaultAppBar(selectedIndex);
    }
  }

  static AppHeader _createContactsAppBar(VoidCallback? onAdd) {
    return AppHeader(
      title: _titles[1],
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF34C759),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  static AppHeader _createDealsAppBar(VoidCallback? onAdd) {
    return AppHeader(
      title: _titles[2],
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFFF9500),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  static AppHeader _createTasksAppBar(VoidCallback? onAdd) {
    return AppHeader(
      title: _titles[3],
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  static AppHeader _createDefaultAppBar(int selectedIndex) {
    return AppHeader(
      title: _titles[selectedIndex],
      automaticallyImplyLeading: false,
    );
  }
}