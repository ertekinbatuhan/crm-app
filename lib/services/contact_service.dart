import '../models/contact_model.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
}

class ContactServiceImpl implements ContactService {
  final List<Contact> _contacts = [
    const Contact(
      id: '1',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@example.com',
      phone: '+1 555-0101',
      company: 'Tech Solutions Inc.',
    ),
    const Contact(
      id: '2',
      name: 'Alex Thompson',
      email: 'alex.thompson@example.com',
      phone: '+1 555-0102',
      company: 'Digital Marketing Pro',
    ),
    const Contact(
      id: '3',
      name: 'Jessica Chen',
      email: 'jessica.chen@example.com',
      phone: '+1 555-0103',
      company: 'Creative Designs LLC',
    ),
    const Contact(
      id: '4',
      name: 'Emily Davis',
      email: 'emily.davis@example.com',
      phone: '+1 555-0104',
      company: 'Startup Hub',
    ),
    const Contact(
      id: '5',
      name: 'David Miller',
      email: 'david.miller@example.com',
      phone: '+1 555-0105',
      company: 'Innovation Labs',
    ),
  ];

  @override
  Future<List<Contact>> getContacts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_contacts);
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newContact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      return contact;
    }
    throw Exception('Contact not found');
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contacts.removeWhere((contact) => contact.id == contactId);
  }
}
