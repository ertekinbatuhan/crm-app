import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
  Stream<List<Contact>> getContactsStream();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
}

// Mock implementation for when Firebase is not available
class MockContactService implements ContactService {
  final List<Contact> _contacts = [
    Contact(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1 234 567 8900',
      company: 'Tech Corp',
    ),
    Contact(
      id: '2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      phone: '+1 234 567 8901',
      company: 'Design Studio',
    ),
  ];

  @override
  Future<List<Contact>> getContacts() async {
    
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_contacts);
  }

  @override
  Stream<List<Contact>> getContactsStream() {
    
    return Stream.periodic(const Duration(seconds: 1), (count) => List.from(_contacts));
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newContact = Contact(
      id: const Uuid().v4(),
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      company: contact.company,
    );
    _contacts.add(newContact);
    return newContact;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
    }
    return contact;
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contacts.removeWhere((contact) => contact.id == contactId);
  }
}


class FirebaseContactService implements ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'contacts';

  @override
  Future<List<Contact>> getContacts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return Contact.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error loading contacts: $e');
    }
  }

  @override
  Stream<List<Contact>> getContactsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return Contact.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Error streaming contacts: $e');
    }
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    try {
      final contactId = const Uuid().v4();

      final contactWithId = Contact(
        id: contactId,
        name: contact.name,
        email: contact.email,
        phone: contact.phone,
        company: contact.company,
      );
      
      await _firestore
          .collection(_collection)
          .doc(contactId)
          .set(contactWithId.toMap());
      
      return contactWithId;
    } catch (e) {
      throw Exception('Error creating contact: $e');
    }
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    try {
      if (contact.id.isEmpty) {
        throw Exception('Contact ID cannot be empty');
      }
      
      final contactData = contact.toMap();
      contactData.remove('id'); 
      
      await _firestore
          .collection(_collection)
          .doc(contact.id)
          .update(contactData);
      
      return contact;
    } catch (e) {
      throw Exception('Error updating contact: $e');
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      if (contactId.isEmpty) {
        throw Exception('Contact ID cannot be empty');
      }
      
      await _firestore
          .collection(_collection)
          .doc(contactId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting contact: $e');
    }
  }
}
