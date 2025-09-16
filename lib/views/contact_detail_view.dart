import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../core/components/layout/section_header.dart';
import '../core/components/base/base_card.dart';
import '../core/components/base/base_avatar.dart';
import '../core/components/base/base_button.dart';
import '../core/components/base/base_badge.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class ContactDetailView extends StatefulWidget {
  final Contact contact;

  const ContactDetailView({
    super.key,
    required this.contact,
  });

  @override
  State<ContactDetailView> createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const double threshold = 200.0;
    bool shouldCollapse = _scrollController.offset > threshold;
    if (shouldCollapse != _isHeaderCollapsed) {
      setState(() {
        _isHeaderCollapsed = shouldCollapse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // Header with back button and title
            SliverAppBar(
              backgroundColor: AppColors.backgroundPrimary,
              elevation: 0,
              pinned: false,
              floating: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Contact Details',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: _showMoreOptions,
                ),
              ],
            ),
            
            // Contact Header
            SliverToBoxAdapter(
              child: _buildContactHeader(),
            ),
            
            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                Container(
                  color: AppColors.backgroundSecondary,
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: AppColors.primary700,
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: AppTypography.labelMedium,
                    dividerColor: AppColors.border,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Activity'),
                      Tab(text: 'Deals'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildActivityTab(),
            _buildDealsTab(),
            _buildNotesTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editContact,
        backgroundColor: AppColors.primary700,
        foregroundColor: AppColors.textInverse,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildContactHeader() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.gapV2,
          
          // Avatar with badge
          Stack(
            children: [
              BaseAvatar(
                text: widget.contact.name,
                size: AvatarSize.extraLarge,
                backgroundColor: AppColors.primary100,
                foregroundColor: AppColors.primary700,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: BaseBadge(
                  text: 'VIP',
                  variant: BadgeVariant.info,
                  size: BadgeSize.small,
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV4,
          
          // Contact name and details - centered
          Column(
            children: [
              Text(
                widget.contact.name,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapV1,
              if (widget.contact.company != null)
                Text(
                  'Senior Account Manager at ${widget.contact.company}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          
          AppSpacing.gapV6,
          
          // Quick action buttons - equal width
          Row(
            children: [
              Expanded(
                child: BaseButton(
                  text: 'Call',
                  variant: ButtonVariant.secondary,
                  leadingIcon: Icons.call,
                  onPressed: widget.contact.phone != null 
                    ? () => _makeCall(widget.contact.phone!) 
                    : null,
                ),
              ),
              AppSpacing.gapH3,
              Expanded(
                child: BaseButton(
                  text: 'Email',
                  variant: ButtonVariant.secondary,
                  leadingIcon: Icons.mail,
                  onPressed: widget.contact.email != null 
                    ? () => _sendEmail(widget.contact.email!) 
                    : null,
                ),
              ),
              AppSpacing.gapH3,
              Expanded(
                child: BaseButton(
                  text: 'Message',
                  variant: ButtonVariant.secondary,
                  leadingIcon: Icons.chat_bubble,
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV4,
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          // Contact Info Card
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Info',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapV4,
                _buildInfoRow('Email', widget.contact.email ?? 'Not provided'),
                _buildInfoRow('Phone', widget.contact.phone ?? 'Not provided'),
                _buildInfoRow('Location', 'New York, NY'),
              ],
            ),
          ),
          
          AppSpacing.gapV6,
          
          // Company Card
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapV4,
                _buildInfoRow('Name', widget.contact.company ?? 'Not provided'),
                _buildInfoRow('Industry', 'Technology'),
              ],
            ),
          ),
          
          AppSpacing.gapV6,
          
          // Social Media Card
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social Media',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapV4,
                _buildLinkRow('LinkedIn', 'linkedin.com/in/sophia-carter'),
                _buildLinkRow('Twitter', 'twitter.com/sophia_carter'),
              ],
            ),
          ),
          
          AppSpacing.gapV6,
          
          // Tags Card
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapV4,
                Wrap(
                  spacing: AppSpacing.sp2,
                  runSpacing: AppSpacing.sp2,
                  children: _getMockTags().map((tag) => _buildTagBadge(tag)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Recent Activity',
                  padding: EdgeInsets.zero,
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addActivity,
                  ),
                ),
                AppSpacing.gapV3,
                ..._getMockActivities().map((activity) => _buildActivityItem(activity)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealsTab() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          // Summary Card
          BaseCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Deal Value',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapV1,
                      Text(
                        '\$45,000',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Deals',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapV1,
                      Text(
                        '3',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Deals List
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Associated Deals',
                  padding: EdgeInsets.zero,
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addDeal,
                  ),
                ),
                AppSpacing.gapV3,
                ..._getMockDeals().map((deal) => _buildDealItem(deal)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Notes',
                  padding: EdgeInsets.zero,
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNote,
                  ),
                ),
                AppSpacing.gapV3,
                ..._getMockNotes().map((note) => _buildNoteItem(note)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLinkRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _openLink(value),
              child: Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTagBadge(String tag) {
    Color backgroundColor;
    Color textColor;
    
    switch (tag.toLowerCase()) {
      case 'high priority':
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      case 'sales':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'new lead':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      default:
        backgroundColor = AppColors.primary100;
        textColor = AppColors.primary700;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: AppTypography.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: AppSpacing.iconSizeS,
            ),
          ),
          AppSpacing.gapH3,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.gapV1,
                Text(
                  activity['subtitle'],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealItem(Map<String, dynamic> deal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal['name'],
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.gapV1,
                Text(
                  deal['stage'],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                deal['value'],
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
              AppSpacing.gapV1,
              Text(
                deal['probability'],
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BaseAvatar(
                text: note['author'],
                size: AvatarSize.small,
                backgroundColor: AppColors.primary100,
                foregroundColor: AppColors.primary700,
              ),
              AppSpacing.gapH2,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['author'],
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      note['timestamp'],
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV2,
          Text(
            note['content'],
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getContactType() {
    // This would be based on actual contact data
    return 'Customer';
  }

  BadgeVariant _getContactTypeVariant() {
    switch (_getContactType().toLowerCase()) {
      case 'lead':
        return BadgeVariant.warning;
      case 'customer':
        return BadgeVariant.success;
      case 'partner':
        return BadgeVariant.info;
      default:
        return BadgeVariant.secondary;
    }
  }

  List<String> _getMockTags() {
    return ['High Priority', 'Sales', 'New Lead'];
  }

  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'icon': Icons.email,
        'color': AppColors.info,
        'title': 'Email sent',
        'subtitle': 'Follow-up email about proposal',
        'time': '2h ago',
      },
      {
        'icon': Icons.phone,
        'color': AppColors.success,
        'title': 'Call completed',
        'subtitle': 'Discussed project requirements',
        'time': '1d ago',
      },
      {
        'icon': Icons.meeting_room,
        'color': AppColors.warning,
        'title': 'Meeting scheduled',
        'subtitle': 'Product demo next week',
        'time': '2d ago',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDeals() {
    return [
      {
        'name': 'Software License Deal',
        'stage': 'Negotiation',
        'value': '\$25,000',
        'probability': '80%',
      },
      {
        'name': 'Consulting Services',
        'stage': 'Proposal',
        'value': '\$15,000',
        'probability': '60%',
      },
      {
        'name': 'Support Package',
        'stage': 'Qualified',
        'value': '\$5,000',
        'probability': '40%',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockNotes() {
    return [
      {
        'author': 'John Doe',
        'timestamp': '2 hours ago',
        'content': 'Had a great conversation about their upcoming project. They seem very interested in our enterprise solution.',
      },
      {
        'author': 'Jane Smith',
        'timestamp': '1 day ago',
        'content': 'Contact expressed concerns about implementation timeline. Need to follow up with technical team.',
      },
      {
        'author': 'Mike Wilson',
        'timestamp': '3 days ago',
        'content': 'Initial meeting went well. Contact is the decision maker for technology purchases.',
      },
    ];
  }

  // Action methods
  void _editContact() {
    print('Edit contact: ${widget.contact.name}');
    // TODO: Navigate to edit contact screen or show modal
  }

  void _makeCall(String phone) {
    print('Make call to: $phone');
    // TODO: Implement phone call functionality
  }

  void _sendEmail(String email) {
    print('Send email to: $email');
    // TODO: Implement email functionality
  }

  void _sendMessage() {
    print('Send message to: ${widget.contact.name}');
    // TODO: Implement messaging functionality
  }

  void _addTag() {
    print('Add tag to: ${widget.contact.name}');
    // TODO: Implement tag addition
  }

  void _addActivity() {
    print('Add activity for: ${widget.contact.name}');
    // TODO: Implement activity addition
  }

  void _addDeal() {
    print('Add deal for: ${widget.contact.name}');
    // TODO: Implement deal creation
  }

  void _addNote() {
    print('Add note for: ${widget.contact.name}');
    // TODO: Implement note creation
  }
  
  void _showMoreOptions() {
    print('Show more options for: ${widget.contact.name}');
    // TODO: Implement more options menu
  }
  
  void _openLink(String url) {
    print('Open link: $url');
    // TODO: Implement URL launching
  }
}

// Custom delegate for persistent tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate(this.child);

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
