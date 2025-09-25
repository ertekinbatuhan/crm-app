class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? company;

  const Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.company,
  });


  // Serialize to/from Map for easier storage and retrieval
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
    };
  }

// Deserialize from Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      company: map['company'],
    );
  }

// Create a copy of the contact with updated fields
  Contact copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
    );
  }


// Override equality and hashCode for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.company == company;
  }

// Override hashCode for proper comparison
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        company.hashCode;
  }

// Override toString for better debugging
  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, company: $company)';
  }
}
