import '../../models/contact_model.dart';
import '../../services/contact_service.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts();
  Stream<List<Contact>> getContactsStream();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
  Future<List<Contact>> searchContacts(String query);
  

  void clearCache();
  bool get hasCache;
}

class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data) : error = null, isSuccess = true;
  const Result.error(this.error) : data = null, isSuccess = false;
}


class ContactRepositoryImpl implements ContactRepository {
  final ContactService _contactService;
  List<Contact>? _cachedContacts;
  DateTime? _lastCacheTime;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  ContactRepositoryImpl(this._contactService);

  @override
  bool get hasCache => _cachedContacts != null && _isCacheValid();

  bool _isCacheValid() {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheTimeout;
  }

  @override
  void clearCache() {
    _cachedContacts = null;
    _lastCacheTime = null;
  }

  @override
  Future<List<Contact>> getContacts() async {

    if (hasCache) {
      return _cachedContacts!;
    }

    try {
      final contacts = await _contactService.getContacts();
      _cachedContacts = contacts;
      _lastCacheTime = DateTime.now();
      return contacts;
    } catch (e) {

      if (_cachedContacts != null) {
        return _cachedContacts!;
      }
      rethrow;
    }
  }

  @override
  Stream<List<Contact>> getContactsStream() {
    return _contactService.getContactsStream().map((contacts) {
      _cachedContacts = contacts;
      _lastCacheTime = DateTime.now();
      return contacts;
    });
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    final newContact = await _contactService.createContact(contact);
    clearCache();
    return newContact;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    final updatedContact = await _contactService.updateContact(contact);
    clearCache();
    return updatedContact;
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await _contactService.deleteContact(contactId);
    clearCache();
  }

  @override
  Future<List<Contact>> searchContacts(String query) async {
    final contacts = await getContacts();
    
    if (query.isEmpty) return contacts;
    
    final lowercaseQuery = query.toLowerCase();
    return contacts.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
             (contact.email?.toLowerCase().contains(lowercaseQuery) ?? false) ||
             (contact.phone?.contains(query) ?? false) ||
             (contact.company?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
}