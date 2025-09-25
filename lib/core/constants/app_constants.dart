import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF34C759);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  
  // Extended color palette
  static const Color accent = Color(0xFF007AFF);
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);
  
  static Color grey50 = Colors.grey[50]!;
  static Color grey100 = Colors.grey[100]!;
  static Color grey200 = Colors.grey[200]!;
  static Color grey300 = Colors.grey[300]!;
  static Color grey600 = Colors.grey[600]!;
  static Color red600 = Colors.red[600]!;
  
  static Color shadowColor = Colors.black.withOpacity(0.05);
  static const Color textOnPrimary = Colors.white;
  
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
  // Contacts
  static const String contacts = 'Contacts';
  static const String addNewContact = 'Add New Contact';
  static const String editContact = 'Edit Contact';
  static const String deleteContact = 'Delete Contact';
  static const String searchContacts = 'Search contacts...';
  static const String totalContacts = 'Total Contacts';
  static const String noContactsFound = 'No contacts found';
  static const String startByAddingContact = 'Start by adding your first contact';
  static const String addContact = 'Add Contact';
  
  // Deals
  static const String deals = 'Deals';
  static const String addNewDeal = 'Add New Deal';
  static const String editDeal = 'Edit Deal';
  static const String deleteDeal = 'Delete Deal';
  static const String searchDeals = 'Search deals...';
  static const String totalDeals = 'Total Deals';
  static const String totalValue = 'Total Value';
  static const String noDealsFound = 'No deals found';
  static const String startByAddingDeal = 'Start by adding your first deal';
  static const String addDeal = 'Add Deal';
  static const String title = 'Title';
  static const String value = 'Value';
  static const String status = 'Status';
  static const String description = 'Description';
  
  // Form Fields
  static const String name = 'Name';
  static const String nameRequired = 'Name *';
  static const String titleRequired = 'Title *';
  static const String valueRequired = 'Value *';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String phoneHint = '+90 5XX XXX XX XX';
  static const String company = 'Company';
  
  // Actions
  static const String add = 'Add';
  static const String update = 'Update';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String tryAgain = 'Try Again';
  static const String retry = 'Retry';
  
  // Messages
  static const String nameIsRequired = 'Name is required';
  static const String titleIsRequired = 'Title is required';
  static const String valueIsRequired = 'Value is required';
  static const String contactAddedSuccessfully = 'Contact added successfully';
  static const String contactUpdatedSuccessfully = 'Contact updated successfully';
  static const String contactDeletedSuccessfully = 'deleted successfully';
  static const String dealAddedSuccessfully = 'Deal added successfully';
  static const String dealUpdatedSuccessfully = 'Deal updated successfully';
  static const String dealDeletedSuccessfully = 'Deal deleted successfully';
  static const String somethingWentWrong = 'Something went wrong';
  static const String loadingContacts = 'Loading contacts...';
  static const String loadingDeals = 'Loading deals...';
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
  
  // Additional text styles
  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppSizes.fontM,
    color: AppColors.black,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: AppSizes.fontS,
    color: AppColors.black,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle chipText = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w500,
  );
}

class AppDecorations {
  static BoxDecoration get modal => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppSizes.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get card => BoxDecoration(
    color: AppColors.cardBackgroundColor,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 5,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ],
  );
  
  static BoxDecoration get input => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppSizes.radiusS),
    border: Border.all(
      color: AppColors.grey200,
      width: 1,
    ),
  );
  
  static BoxDecoration get chip => BoxDecoration(
    borderRadius: BorderRadius.circular(AppSizes.radiusS),
    border: Border.all(
      color: AppColors.grey200,
      width: 1,
    ),
  );
  
  static BoxDecoration get statusOpen => BoxDecoration(
    color: AppColors.success.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppSizes.radiusS),
    border: Border.all(
      color: AppColors.success,
      width: 1,
    ),
  );
}

class AppInputDecorations {
  static InputDecoration get standard => InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: AppColors.grey200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: AppColors.grey200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.all(AppSizes.paddingM),
  );
}