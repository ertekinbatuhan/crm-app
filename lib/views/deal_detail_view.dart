import 'package:flutter/material.dart';
import '../models/deal_model.dart';
import '../core/components/base/base_card.dart';
import '../core/components/base/base_avatar.dart';
import '../core/components/base/base_button.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class DealDetailView extends StatefulWidget {
  final Deal deal;

  const DealDetailView({
    super.key,
    required this.deal,
  });

  @override
  State<DealDetailView> createState() => _DealDetailViewState();
}

class _DealDetailViewState extends State<DealDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Deal Details',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  // Deal Overview Card
                  _buildDealOverviewCard(),
                  
                  AppSpacing.gapV6,
                  
                  // Pipeline Progress Card
                  _buildPipelineProgressCard(),
                  
                  AppSpacing.gapV6,
                  
                  // Deal Summary Card
                  _buildDealSummaryCard(),
                  
                  AppSpacing.gapV6,
                  
                  // Contact Information Card
                  _buildContactInformationCard(),
                  
                  AppSpacing.gapV6,
                  
                  // Products/Services Card
                  _buildProductsServicesCard(),
                  
                  AppSpacing.gapV6,
                  
                  // Activity Timeline Card
                  _buildActivityTimelineCard(),
                  
                  // Extra bottom padding for fixed action bar
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          
          // Fixed bottom action bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildDealOverviewCard() {
    return BaseCard(
      child: Row(
        children: [
          // Company logo/avatar
          BaseAvatar(
            text: 'Acme Corp',
            size: AvatarSize.large,
            backgroundColor: AppColors.primary100,
            foregroundColor: AppColors.primary700,
          ),
          
          AppSpacing.gapH4,
          
          // Deal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deal.title,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapV1,
                Text(
                  'Value: \$${widget.deal.value.toStringAsFixed(0)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.gapV1,
                Text(
                  'Stage: ${widget.deal.status.displayName}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineProgressCard() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pipeline Progress',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          AppSpacing.gapV3,
          
          // Progress bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDisabled,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _getProgressPercent(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapH4,
              Text(
                '${(_getProgressPercent() * 100).toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV2,
          
          // Stage labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _getStageLabels().map((stage) => 
              Text(
                stage['name'],
                style: AppTypography.bodySmall.copyWith(
                  color: stage['active'] ? AppColors.primary700 : AppColors.textSecondary,
                  fontWeight: stage['active'] ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDealSummaryCard() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deal Summary',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          AppSpacing.gapV2,
          
          Text(
            'This deal involves providing enterprise software solutions to Acme Corp, a leading technology company. The deal is currently in the ${widget.deal.status.displayName.toLowerCase()} stage with a high probability of closing.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformationCard() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Primary contact
          _buildContactItem(
            avatar: BaseAvatar(
              text: 'Ethan Carter',
              size: AvatarSize.medium,
              backgroundColor: AppColors.primary100,
              foregroundColor: AppColors.primary700,
            ),
            name: 'Ethan Carter',
            title: 'CEO',
          ),
          
          AppSpacing.gapV4,
          
          // Email contact
          _buildContactItem(
            avatar: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceDisabled,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email,
                color: AppColors.textSecondary,
              ),
            ),
            name: 'Email',
            title: 'ethan.carter@acmecorp.com',
            isClickable: true,
            onTap: () => _sendEmail('ethan.carter@acmecorp.com'),
          ),
          
          AppSpacing.gapV4,
          
          // Phone contact
          _buildContactItem(
            avatar: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceDisabled,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone,
                color: AppColors.textSecondary,
              ),
            ),
            name: 'Phone',
            title: '+1 (555) 123-4567',
            isClickable: true,
            onTap: () => _makeCall('+1 (555) 123-4567'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required Widget avatar,
    required String name,
    required String title,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    Widget child = Row(
      children: [
        avatar,
        AppSpacing.gapH4,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: isClickable ? AppColors.primary700 : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isClickable && onTap != null) {
      child = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: child,
      );
    }

    return child;
  }

  Widget _buildProductsServicesCard() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products/Services',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          AppSpacing.gapV4,
          
          _buildProductServiceItem(
            icon: Icons.inventory_2,
            name: 'Enterprise Software License',
          ),
          
          AppSpacing.gapV3,
          
          _buildProductServiceItem(
            icon: Icons.construction,
            name: 'Implementation Services',
          ),
        ],
      ),
    );
  }

  Widget _buildProductServiceItem({
    required IconData icon,
    required String name,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceDisabled,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapH4,
        Expanded(
          child: Text(
            name,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTimelineCard() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              BaseButton(
                text: 'Add Activity',
                variant: ButtonVariant.primary,
                leadingIcon: Icons.add,
                size: ButtonSize.small,
                onPressed: _addActivity,
              ),
            ],
          ),
          
          AppSpacing.gapV4,
          
          // Timeline
          Container(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: [
                // Timeline line
                Stack(
                  children: [
                    // Vertical line
                    Positioned(
                      left: 12,
                      top: 12,
                      bottom: 12,
                      child: Container(
                        width: 2,
                        color: AppColors.borderLight,
                      ),
                    ),
                    
                    // Timeline items
                    Column(
                      children: _getActivityItems().map((activity) => 
                        _buildTimelineItem(
                          icon: activity['icon'],
                          title: activity['title'],
                          time: activity['time'],
                        )
                      ).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Timeline circle with icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary700,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.textInverse,
              size: 14,
            ),
          ),
          
          AppSpacing.gapH3,
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: AppSpacing.screenPadding,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: BaseButton(
                    text: 'Add Note',
                    variant: ButtonVariant.secondary,
                    leadingIcon: Icons.edit_note,
                    onPressed: _addNote,
                  ),
                ),
                AppSpacing.gapH4,
                Expanded(
                  child: BaseButton(
                    text: 'Schedule',
                    variant: ButtonVariant.secondary,
                    leadingIcon: Icons.event,
                    onPressed: _schedule,
                  ),
                ),
              ],
            ),
            AppSpacing.gapV4,
            Row(
              children: [
                Expanded(
                  child: BaseButton(
                    text: 'Update Stage',
                    variant: ButtonVariant.secondary,
                    leadingIcon: Icons.layers,
                    onPressed: _updateStage,
                  ),
                ),
                AppSpacing.gapH4,
                Expanded(
                  child: BaseButton(
                    text: 'Mark as Won',
                    variant: ButtonVariant.primary,
                    leadingIcon: Icons.emoji_events,
                    onPressed: _markAsWon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  double _getProgressPercent() {
    switch (widget.deal.status) {
      case DealStatus.qualified:
        return 0.25;
      case DealStatus.proposal:
        return 0.5;
      case DealStatus.negotiation:
        return 0.8;
      case DealStatus.closed:
        return 1.0;
      default:
        return 0.1;
    }
  }

  List<Map<String, dynamic>> _getStageLabels() {
    final currentStatus = widget.deal.status;
    return [
      {'name': 'Qualification', 'active': currentStatus == DealStatus.qualified},
      {'name': 'Proposal', 'active': currentStatus == DealStatus.proposal},
      {'name': 'Negotiation', 'active': currentStatus == DealStatus.negotiation},
      {'name': 'Closed', 'active': currentStatus == DealStatus.closed},
    ];
  }

  List<Map<String, dynamic>> _getActivityItems() {
    return [
      {
        'icon': Icons.event,
        'title': 'Meeting with Ethan Carter',
        'time': '2 days ago',
      },
      {
        'icon': Icons.email,
        'title': 'Proposal Sent',
        'time': '1 week ago',
      },
      {
        'icon': Icons.phone,
        'title': 'Initial Contact',
        'time': '2 weeks ago',
      },
    ];
  }

  // Action methods
  void _sendEmail(String email) {
    print('Send email to: $email');
    // TODO: Implement email functionality
  }

  void _makeCall(String phone) {
    print('Make call to: $phone');
    // TODO: Implement phone call functionality
  }

  void _addActivity() {
    print('Add activity for deal: ${widget.deal.title}');
    // TODO: Implement add activity
  }

  void _addNote() {
    print('Add note for deal: ${widget.deal.title}');
    // TODO: Implement add note
  }

  void _schedule() {
    print('Schedule meeting for deal: ${widget.deal.title}');
    // TODO: Implement scheduling
  }

  void _updateStage() {
    print('Update stage for deal: ${widget.deal.title}');
    // TODO: Implement stage update
  }

  void _markAsWon() {
    print('Mark deal as won: ${widget.deal.title}');
    // TODO: Implement mark as won
  }
}