import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../models/contact_model.dart';
import '../core/repositories/contact_repository.dart';

@immutable
class ContactsState extends Equatable {
  final ContactsViewState viewState;
  final List<Contact> contacts;
  final List<Contact> filteredContacts;
  final String searchQuery;
  final String errorMessage;
  final String selectedFilter;

  const ContactsState({
    required this.viewState,
    required this.contacts,
    required this.filteredContacts,
    required this.searchQuery,
    required this.errorMessage,
    required this.selectedFilter,
  });

  factory ContactsState.initial() {
    return const ContactsState(
      viewState: ContactsViewState.initial,
      contacts: [],
      filteredContacts: [],
      searchQuery: '',
      errorMessage: '',
      selectedFilter: 'All',
    );
  }

  ContactsState copyWith({
    ContactsViewState? viewState,
    List<Contact>? contacts,
    List<Contact>? filteredContacts,
    String? searchQuery,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return ContactsState(
      viewState: viewState ?? this.viewState,
      contacts: contacts ?? this.contacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  bool get isLoading => viewState == ContactsViewState.loading;
  bool get hasError => viewState == ContactsViewState.error;
  bool get isLoaded => viewState == ContactsViewState.loaded;
  int get totalContactsCount => contacts.length;

  @override
  List<Object?> get props => [
        viewState,
        contacts,
        filteredContacts,
        searchQuery,
        errorMessage,
        selectedFilter,
      ];
}

enum ContactsViewState { initial, loading, loaded, error }

class ContactsViewModel extends ChangeNotifier {
  final ContactRepository _contactRepository;
  ContactsState _state = ContactsState.initial();
  StreamSubscription<List<Contact>>? _contactsSubscription;

  ContactsViewModel(this._contactRepository) {
    _listenToContacts();
  }

  ContactsState get state => _state;

  List<Contact> get contacts => _state.filteredContacts;
  List<Contact> get allContacts => _state.contacts;
  String get searchQuery => _state.searchQuery;
  String get selectedFilter => _state.selectedFilter;
  String get errorMessage => _state.errorMessage;
  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  bool get isLoaded => _state.isLoaded;
  int get totalContactsCount => _state.totalContactsCount;

  void _updateState(ContactsState newState) {
    _state = newState;
    notifyListeners();
  }

  void _listenToContacts() {
    _updateState(_state.copyWith(viewState: ContactsViewState.loading));
    
    _contactsSubscription = _contactRepository.getContactsStream().listen(
      (contacts) {
        final filteredContacts = _applyFilters(contacts, _state.searchQuery, _state.selectedFilter);
        
        _updateState(_state.copyWith(
          viewState: ContactsViewState.loaded,
          contacts: contacts,
          filteredContacts: filteredContacts,
          errorMessage: '',
        ));
      },
      onError: (error) {
        _updateState(_state.copyWith(
          viewState: ContactsViewState.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  @override
  void dispose() {
    _contactsSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadContacts() async {
    // This method is kept for manual refresh scenarios
    // But now we primarily rely on the real-time stream
    _updateState(_state.copyWith(viewState: ContactsViewState.loading));
    
    try {
      final contacts = await _contactRepository.getContacts();
      final filteredContacts = _applyFilters(contacts, _state.searchQuery, _state.selectedFilter);
      
      _updateState(_state.copyWith(
        viewState: ContactsViewState.loaded,
        contacts: contacts,
        filteredContacts: filteredContacts,
        errorMessage: '',
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: ContactsViewState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<bool> createContact(Contact contact) async {
    try {
      await _contactRepository.createContact(contact);
      // Real-time stream will automatically update the state
      return true;
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: ContactsViewState.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      await _contactRepository.updateContact(contact);
      // Real-time stream will automatically update the state
      return true;
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: ContactsViewState.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      await _contactRepository.deleteContact(contactId);
      // Real-time stream will automatically update the state
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: ContactsViewState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateSearchQuery(String query) {
    final filteredContacts = _applyFilters(_state.contacts, query, _state.selectedFilter);
    
    _updateState(_state.copyWith(
      searchQuery: query,
      filteredContacts: filteredContacts,
    ));
  }

  void setFilter(String filter) {
    final filteredContacts = _applyFilters(_state.contacts, _state.searchQuery, filter);
    
    _updateState(_state.copyWith(
      selectedFilter: filter,
      filteredContacts: filteredContacts,
    ));
  }

  List<Contact> _applyFilters(List<Contact> contacts, String searchQuery, String selectedFilter) {
    List<Contact> filtered = List.from(contacts);

    if (searchQuery.isNotEmpty) {
      final lowercaseQuery = searchQuery.toLowerCase();
      filtered = filtered.where((contact) {
        return contact.name.toLowerCase().contains(lowercaseQuery) ||
               (contact.email?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (contact.phone?.contains(searchQuery) ?? false) ||
               (contact.company?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
    switch (selectedFilter) {
      case 'Recent':
        break;
      case 'Favorites':
        break;
      case 'All':
      default:
        break;
    }

    return filtered;
  }

  void clearCache() {
    _contactRepository.clearCache();
  }

  void refreshContacts() {
    // Cancel current subscription and restart listening
    _contactsSubscription?.cancel();
    clearCache();
    _listenToContacts();
  }
}