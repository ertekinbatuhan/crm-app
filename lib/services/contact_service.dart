import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';

abstract class ContactService {
  Stream<List<Contact>> getContactsStream();
  Future<List<Contact>> getContactsOnce();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
}

class FirebaseContactService implements ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'contacts';

  @override
  Stream<List<Contact>> getContactsStream() {
    try {
      return _firestore.collection(_collection).orderBy('name').snapshots().map(
        (QuerySnapshot snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Contact.fromMap(data);
          }).toList();
        },
      );
    } catch (e) {
      throw Exception('Error streaming contacts: $e');
    }
  }

  @override
  Future<List<Contact>> getContactsOnce() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Contact.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching contacts: $e');
    }
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    try {
      final contactId = const Uuid().v4();
      final now = DateTime.now();

      final contactWithId = contact.copyWith(
        id: contactId,
        createdAt: now,
        updatedAt: now,
      );

      final contactData = contactWithId.toMap();
      contactData.remove('id');

      await _firestore.collection(_collection).doc(contactId).set(contactData);

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

      final now = DateTime.now();
      final updatedContact = contact.copyWith(updatedAt: now);
      final contactData = updatedContact.toMap();
      contactData.remove('id');

      await _firestore
          .collection(_collection)
          .doc(contact.id)
          .update(contactData);

      return updatedContact;
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

      await _firestore.collection(_collection).doc(contactId).delete();
    } catch (e) {
      throw Exception('Error deleting contact: $e');
    }
  }
}
