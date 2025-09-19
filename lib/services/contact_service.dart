import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
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
