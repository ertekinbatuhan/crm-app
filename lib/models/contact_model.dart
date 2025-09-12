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

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        company.hashCode;
  }
}
