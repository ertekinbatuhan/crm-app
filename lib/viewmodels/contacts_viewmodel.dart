import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/contact_model.dart';
import '../core/repositories/contact_repository.dart';
import '../core/mixins/view_state_mixin.dart';

class ContactsViewModel extends ChangeNotifier with ViewStateMixin {
  final ContactRepository _contactRepository;
  
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  StreamSubscription<List<Contact>>? _contactsSubscription;

  ContactsViewModel(this._contactRepository) {
    _listenToContacts();
  }

  // Getters
  List<Contact> get contacts => _filteredContacts;
  List<Contact> get allContacts => _allContacts;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  int get totalContactsCount => _allContacts.length;

  void _listenToContacts() {
    setLoading();
    notifyListeners();
    
    _contactsSubscription = _contactRepository.getContactsStream().listen(
      (contacts) {
        _allContacts = contacts;
        _applyFilters();
        
        if (_allContacts.isEmpty) {
          setEmpty();
        } else {
          setSuccess();
        }
        notifyListeners();
      },
      onError: (error) {
        setError(error.toString());
        notifyListeners();
      },
    );
  }

  void _applyFilters() {
    List<Contact> filtered = _allContacts;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((contact) {
        return contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (contact.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
               (contact.company?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

   
    if (_selectedFilter != 'All') {
    }

    _filteredContacts = filtered;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    
    if (_filteredContacts.isEmpty && query.isNotEmpty) {
      setEmpty();
    } else if (_filteredContacts.isNotEmpty) {
      setSuccess();
    }
    notifyListeners();
  }

  void updateFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
    
    if (_filteredContacts.isEmpty) {
      setEmpty();
    } else {
      setSuccess();
    }
    notifyListeners();
  }

  Future<bool> createContact(Contact contact) async {
    try {
      await _contactRepository.createContact(contact);
      return true;
    } catch (e) {
      setError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      await _contactRepository.updateContact(contact);
      return true;
    } catch (e) {
      setError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      await _contactRepository.deleteContact(contactId);
      return true;
    } catch (e) {
      setError(e.toString());
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _contactsSubscription?.cancel();
    super.dispose();
  }
}