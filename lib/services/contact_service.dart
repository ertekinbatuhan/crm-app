import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';
import '../core/constants/firestore_constants.dart';
import '../core/errors/exceptions.dart';

abstract class ContactService {
  Stream<List<Contact>> getContactsStream();
  Future<List<Contact>> getContactsOnce();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
}

class FirebaseContactService implements ContactService {
  final FirebaseFirestore _firestore;
  final String _collection = FirestoreCollections.contacts;

  FirebaseContactService([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Contact>> getContactsStream() {
    try {
      return _firestore.collection(_collection).orderBy('name').snapshots().map(
        (QuerySnapshot snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Contact.fromMap({...data, 'id': doc.id});
          }).toList();
        },
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Error streaming contacts',
        code: 'STREAM_ERROR',
        originalError: e,
      );
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
        return Contact.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Error fetching contacts',
        code: 'FETCH_ERROR',
        originalError: e,
      );
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
      throw FirestoreException(
        message: 'Error creating contact',
        code: 'CREATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    try {
      if (contact.id.isEmpty) {
        throw ValidationException.requiredField('contact.id');
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
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Error updating contact',
        code: 'UPDATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      if (contactId.isEmpty) {
        throw ValidationException.requiredField('contactId');
      }

      await _firestore.collection(_collection).doc(contactId).delete();
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Error deleting contact',
        code: 'DELETE_ERROR',
        originalError: e,
      );
    }
  }
}
