import 'package:flutter/foundation.dart';
import '../../models/contact_model.dart';
import '../../services/contact_service.dart';

enum ContactsViewState { initial, loading, loaded, error }

class ContactsViewModel extends ChangeNotifier {
  final ContactService _contactService;

  ContactsViewModel({required ContactService contactService})
    : _contactService = contactService;

  // State
  ContactsViewState _state = ContactsViewState.initial;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';
  String _errorMessage = '';
  String _selectedFilter = 'All'; // All, Recent, Favorites

  // Getters
  ContactsViewState get state => _state;
  List<Contact> get contacts => _filteredContacts;
  List<Contact> get allContacts => _contacts;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == ContactsViewState.loading;
  bool get hasError => _state == ContactsViewState.error;
  bool get isLoaded => _state == ContactsViewState.loaded;

  // Business Logic Methods
  Future<void> loadContacts() async {
    _setState(ContactsViewState.loading);
    try {
      _contacts = await _contactService.getContacts();
      _applyFilters();
      _setState(ContactsViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> createContact(Contact contact) async {
    try {
      final newContact = await _contactService.createContact(contact);
      _contacts.add(newContact);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _contactService.updateContact(contact);
      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = contact;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      await _contactService.deleteContact(contactId);
      _contacts.removeWhere((contact) => contact.id == contactId);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Search and Filter functionality
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    setSearchQuery(query);
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void changeFilter(String filter) {
    setFilter(filter);
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Contact> filtered = List.from(_contacts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((contact) {
        return contact.name.toLowerCase().contains(_searchQuery) ||
            (contact.email?.toLowerCase().contains(_searchQuery) ?? false) ||
            (contact.company?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }

    // Apply category filter
    switch (_selectedFilter) {
      case 'Recent':
        // For demo purposes, just take the last 10
        filtered = filtered.take(10).toList();
        break;
      case 'Favorites':
        // This would require a favorite field in the model
        // For now, just return all
        break;
      case 'All':
      default:
        // No additional filtering
        break;
    }

    _filteredContacts = filtered;
  }

  // Helper methods
  void _setState(ContactsViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = ContactsViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Contacts specific business logic
  Contact? getContactById(String id) {
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Contact> getContactsByCompany(String company) {
    return _contacts
        .where(
          (contact) => contact.company?.toLowerCase() == company.toLowerCase(),
        )
        .toList();
  }

  int get totalContacts => _contacts.length;
  int get recentContacts => 5; // Mock implementation
  int get totalContactsCount => _contacts.length;
  int get filteredContactsCount => _filteredContacts.length;

  List<String> get allCompanies {
    return _contacts
        .where(
          (contact) => contact.company != null && contact.company!.isNotEmpty,
        )
        .map((contact) => contact.company!)
        .toSet()
        .toList()
      ..sort();
  }

  Map<String, int> get contactsByCompany {
    final Map<String, int> companyCount = {};
    for (final contact in _contacts) {
      if (contact.company != null && contact.company!.isNotEmpty) {
        companyCount[contact.company!] =
            (companyCount[contact.company!] ?? 0) + 1;
      }
    }
    return companyCount;
  }
}
