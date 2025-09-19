import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF34C759);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  

  static Color grey100 = Colors.grey[100]!;
  static Color grey600 = Colors.grey[600]!;
  static Color red600 = Colors.red[600]!;
  

  static Color shadowColor = Colors.black.withOpacity(0.05);
  

  static const Color backgroundColor = Colors.white;
  static const Color cardBackgroundColor = Colors.white;
  static const Color searchBarBackgroundColor = Color(0xFFF5F5F5);
}

class AppSizes {

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  

  static const double iconS = 16.0;
  static const double iconM = 18.0;
  static const double iconL = 24.0;
  static const double iconXL = 64.0;
  

  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 24.0;
  

  static const double elevationS = 1.0;
  static const double elevationM = 5.0;
  

  static const double dialogWidthFactor = 0.9;
}

class AppStrings {

  static const String contacts = 'Contacts';
  static const String addNewContact = 'Add New Contact';
  static const String editContact = 'Edit Contact';
  static const String deleteContact = 'Delete Contact';
  static const String searchContacts = 'Search contacts...';
  static const String totalContacts = 'Total Contacts';
  static const String noContactsFound = 'No contacts found';
  static const String startByAddingContact = 'Start by adding your first contact';
  static const String addContact = 'Add Contact';
  

  static const String name = 'Name';
  static const String nameRequired = 'Name *';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String phoneHint = '+90 5XX XXX XX XX';
  static const String company = 'Company';
  

  static const String add = 'Add';
  static const String update = 'Update';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String tryAgain = 'Try Again';
  static const String retry = 'Retry';
  

  static const String nameIsRequired = 'Name is required';
  static const String contactAddedSuccessfully = 'Contact added successfully';
  static const String contactUpdatedSuccessfully = 'Contact updated successfully';
  static const String contactDeletedSuccessfully = 'deleted successfully';
  static const String somethingWentWrong = 'Something went wrong';
  static const String loadingContacts = 'Loading contacts...';
  static const String deleteConfirmationMessage = 'Are you sure you want to delete "%s"? This action cannot be undone.';
}

class AppTextStyles {
  static const TextStyle cardTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: AppSizes.fontL,
  );
  
  static const TextStyle dialogTitle = TextStyle(
    fontSize: AppSizes.fontXXL,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle statTitle = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle statValue = TextStyle(
    fontSize: AppSizes.fontXXL,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: AppSizes.fontXL,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle emptyStateSubtitle = TextStyle(
    fontSize: AppSizes.fontM,
  );
  
  static const TextStyle errorTitle = TextStyle(
    fontSize: AppSizes.fontXL,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle errorMessage = TextStyle(
    fontSize: AppSizes.fontM,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: AppSizes.fontL,
  );
  
  static const TextStyle avatarText = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );
}