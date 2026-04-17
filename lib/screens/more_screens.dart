// ═══════════════════════════════════════════════════════════════════════════
// more_screens.dart  –  Marketplace, Facilities, Notices, Vendors, Profile
// ═══════════════════════════════════════════════════════════════════════════

import 'package:estate_app/screens/change_password_screen.dart';
import 'package:estate_app/screens/help_feedback_screen.dart';
import 'package:estate_app/screens/login_screen.dart';
import 'package:estate_app/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'due_payment_screen.dart';

// ── Notices / Announcements ───────────────────────────────────────────────
class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EstateAppBar(
        title: 'Notices & Announcements',
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        itemCount: DummyData.notices.length,
        itemBuilder: (_, i) => _NoticeCard(notice: DummyData.notices[i]),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard({required this.notice});

  Color _catColor() {
    switch (notice.category) {
      case 'Finance': return AppTheme.accent;
      case 'Maintenance': return AppTheme.error;
      case 'Meeting': return AppTheme.secondary;
      case 'Community': return AppTheme.success;
      default: return AppTheme.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _catColor();
    return GestureDetector(
      onTap: () => showNoticeOverlay(context, notice),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: notice.isPinned ? color.withOpacity(0.4) : AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  if (notice.isPinned) ...[
                    const Icon(Icons.push_pin_rounded, size: 14, color: AppTheme.accent),
                    const SizedBox(width: 4),
                  ],
                  StatusBadge(label: notice.category, color: color),
                  const Spacer(),
                  Text(
                    DateFormat('dd MMM, h:mm a').format(notice.postedAt),
                    style: const TextStyle(fontSize: 10, color: AppTheme.textMid),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notice.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(notice.body, style: const TextStyle(fontSize: 12, color: AppTheme.textMid, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text('Posted by ${notice.postedBy}', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void showNoticeOverlay(BuildContext context, Notice notice) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 52),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.campaign_rounded, color: AppTheme.accent, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(notice.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                StatusBadge(label: notice.category, color: AppTheme.accent),
                const SizedBox(width: 10),
                Text('Posted by ${notice.postedBy}', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                const Spacer(),
                Text(DateFormat('dd MMM yyyy').format(notice.postedAt), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
              ],
            ),
            const SizedBox(height: 18),
            Text(notice.body, style: const TextStyle(fontSize: 14, height: 1.6, color: AppTheme.textDark)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ── Facility Booking ──────────────────────────────────────────────────────
class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  static const List<Map<String, dynamic>> _facilities = [
    {'name': 'Swimming Pool', 'icon': Icons.pool_rounded, 'color': 0xFF2980B9, 'slots': '10', 'fee': '₦5,000/hr'},
    {'name': 'Clubhouse', 'icon': Icons.meeting_room_rounded, 'color': 0xFF8E44AD, 'slots': '6', 'fee': '₦25,000/session'},
    {'name': 'Tennis Court', 'icon': Icons.sports_tennis_rounded, 'color': 0xFF27AE60, 'slots': '8', 'fee': '₦3,000/hr'},
    {'name': 'Event Hall', 'icon': Icons.event_rounded, 'color': 0xFFC9973A, 'slots': '4', 'fee': '₦80,000/day'},
    {'name': 'Gym', 'icon': Icons.fitness_center_rounded, 'color': 0xFFE74C3C, 'slots': '12', 'fee': '₦2,000/session'},
    {'name': 'Kids Playground', 'icon': Icons.child_care_rounded, 'color': 0xFF16A085, 'slots': '∞', 'fee': 'Free'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Facility Booking'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: _facilities.map((f) {
                final color = Color(f['color'] as int);
                return GestureDetector(
                  onTap: () => _showBookingSheet(context, f),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(f['icon'] as IconData, color: color, size: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(f['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(f['fee'] as String, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        const Text("Book Now", style: TextStyle(fontSize: 11,color: AppTheme.textLight,decoration: TextDecoration.underline, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'My Bookings'),
            const SizedBox(height: 12),
            ...DummyData.bookings.map((b) => _BookingCard(booking: b)),
          ],
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, Map<String, dynamic> facility) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 52),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book ${facility['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(facility['fee'] as String, style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Select Date')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Select Time Slot')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Purpose / Notes')),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm Booking'))),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final FacilityBooking booking;
  const _BookingCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
      case BookingStatus.confirmed: return AppTheme.success;
      case BookingStatus.pending: return AppTheme.warning;
      case BookingStatus.cancelled: return AppTheme.error;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case BookingStatus.confirmed: return 'Confirmed';
      case BookingStatus.pending: return 'Pending';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, color: AppTheme.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.facilityName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${DateFormat('EEE, dd MMM').format(booking.date)} · ${booking.timeSlot}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₦${NumberFormat('#,###').format(booking.fee)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              StatusBadge(label: _statusLabel(), color: _statusColor()),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Marketplace ────────────────────────────────────────────────────────────
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  bool _showServices = false;

  void _showCreateListingSheet() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isService = _showServices;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 52),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create a new listing', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isService = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isService ? AppTheme.primary : AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 20,
                                  color: isService ? AppTheme.textDark : Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text('Item', style: TextStyle(color: isService ? AppTheme.textDark : Colors.white, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isService = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isService ? AppTheme.primary : AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.build_circle_outlined,
                                  size: 20,
                                  color: isService ? Colors.white : AppTheme.textDark,
                                ),
                                const SizedBox(width: 8),
                                Text('Service', style: TextStyle(color: isService ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Listing title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter a title';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: categoryController,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter a category';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price (₦)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter a price';
                          if (double.tryParse(value.replaceAll(',', '')) == null) return 'Enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter a description';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            final user = DummyData.currentUser;
                            final listing = MarketListing(
                              id: 'ml${DummyData.listings.length + 1}',
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              sellerName: user.name,
                              sellerUnit: user.unitNumber,
                              category: categoryController.text.trim(),
                              price: double.parse(priceController.text.trim().replaceAll(',', '')),
                              isService: isService,
                              listedAt: DateTime.now(),
                            );

                            setState(() {
                              DummyData.listings.insert(0, listing);
                              _showServices = isService;
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Your ${isService ? 'service' : 'item'} has been listed.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: const Text('Create Listing'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = DummyData.listings.where((l) => _showServices ? l.isService : !l.isService).toList();

    return Scaffold(
      appBar: EstateAppBar(
        title: 'Estate Marketplace',
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: _showCreateListingSheet),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16,16,16,52),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showServices = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_showServices ? AppTheme.primary : AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.storefront_rounded, color: !_showServices ? Colors.white : AppTheme.textMid, size: 18),
                          const SizedBox(width: 6),
                          Text('Items', style: TextStyle(fontWeight: FontWeight.w600, color: !_showServices ? Colors.white : AppTheme.textMid)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showServices = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _showServices ? AppTheme.primary : AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.miscellaneous_services_rounded, color: _showServices ? Colors.white : AppTheme.textMid, size: 18),
                          const SizedBox(width: 6),
                          Text('Services', style: TextStyle(fontWeight: FontWeight.w600, color: _showServices ? Colors.white : AppTheme.textMid)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16,16,16,52),
              itemCount: items.length,
              itemBuilder: (_, i) => _ListingCard(listing: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final MarketListing listing;
  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(
                listing.isService ? Icons.build_circle_outlined : Icons.shopping_bag_outlined,
                size: 44, color: AppTheme.secondary.withOpacity(0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadge(label: listing.category, color: AppTheme.secondary),
                    Text(DateFormat('dd MMM').format(listing.listedAt), style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(listing.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(listing.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMid), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('₦${NumberFormat('#,###').format(listing.price)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.accent)),
                    if (listing.isService) const Text('/session', style: TextStyle(fontSize: 11, color: AppTheme.textMid)),
                    const Spacer(),
                    MemberAvatar(initials: listing.sellerName.substring(0, 2).toUpperCase(), size: 24),
                    const SizedBox(width: 6),
                    Text('${listing.sellerName.split(' ')[0]} · ${listing.sellerUnit}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: Text(listing.isService ? 'Request Service' : 'Contact Seller'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Vendor Profile ───────────────────────────────────────────────────────
class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final EstateMember _user;
  Vendor? _vendor;
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  bool _isApproved = false;

  @override
  void initState() {
    super.initState();
    _user = DummyData.currentUser;
    Vendor? existing;
    for (final vendor in DummyData.vendors) {
      if (vendor.email == _user.email || vendor.contactPerson == _user.name) {
        existing = vendor;
        break;
      }
    }
    _vendor = existing;

    _nameController = TextEditingController(text: _vendor?.name ?? '${_user.name} Services');
    _categoryController = TextEditingController(text: _vendor?.category ?? 'General');
    _contactController = TextEditingController(text: _vendor?.contactPerson ?? _user.name);
    _phoneController = TextEditingController(text: _vendor?.phone ?? _user.phone);
    _emailController = TextEditingController(text: _vendor?.email ?? _user.email);
    _isApproved = _vendor?.isApproved ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveVendorProfile() {
    if (!_formKey.currentState!.validate()) return;

    final newVendor = Vendor(
      id: 'vd${DummyData.vendors.length + 1}',
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      contactPerson: _contactController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      rating: 4.5,
      isApproved: _isApproved,
    );

    setState(() {
      DummyData.vendors.insert(0, newVendor);
      _vendor = newVendor;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vendor profile created for ${_vendor!.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listings = DummyData.listings.where((l) => l.sellerName == _user.name).toList();

    return Scaffold(
      appBar: EstateAppBar(title: 'My Vendor Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 52),
        child: _vendor == null ? _buildCreateForm() : _buildProfile(listings),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create vendor profile', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Vendor/Business name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a vendor/business name';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a category';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact person'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a contact name';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a phone number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVendorProfile,
                  child: const Text('Submit Vendor Profile'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfile(List<MarketListing> listings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_vendor!.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              StatusBadge(label: _vendor!.category, color: AppTheme.accent),
              const SizedBox(height: 16),
              Text('Contact', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text(_vendor!.contactPerson, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_vendor!.phone, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text(_vendor!.email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(_vendor!.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 10),
                  StatusBadge(label: _vendor!.isApproved ? 'Approved' : 'Pending', color: _vendor!.isApproved ? AppTheme.success : AppTheme.warning),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('My Listings', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (listings.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
            child: const Text('You have no active listings yet.', style: TextStyle(color: AppTheme.textMid)),
          )
        else
          ...listings.map((listing) => _vendorListingTile(listing)).toList(),
      ],
    );
  }

  Widget _vendorListingTile(MarketListing listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(listing.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(listing.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMid), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('₦${NumberFormat('#,###').format(listing.price)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.accent)),
              const Spacer(),
              StatusBadge(label: listing.isService ? 'Service' : 'Item', color: AppTheme.secondary),
            ],
          ),
        ],
      ),
    );
  }
}

class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EstateAppBar(title: 'Vendors', actions: [
        IconButton(icon: const Icon(Icons.person_pin_rounded, color: Colors.white), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorProfileScreen()));
        }),
      ]),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        itemCount: DummyData.vendors.length,
        itemBuilder: (_, i) {
          final v = DummyData.vendors[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(
              children: [
                MemberAvatar(initials: v.name.substring(0, 2).toUpperCase(), size: 46, color: AppTheme.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(v.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                          if (v.isApproved) const Icon(Icons.verified_rounded, size: 16, color: AppTheme.info),
                        ],
                      ),
                      Text(v.category, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                      Text(v.contactPerson, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppTheme.accent, size: 14),
                        const SizedBox(width: 2),
                        Text(v.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(label: v.isApproved ? 'Approved' : 'Pending', color: v.isApproved ? AppTheme.success : AppTheme.warning),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Profile ────────────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    final fmt = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const SizedBox(height: 24),
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                        child: Center(child: Text(user.avatarInitials, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700))),
                      ),
                      const SizedBox(height: 10),
                      Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Text('Unit ${user.unitNumber} · ${user.roleLabel}', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('Profile'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16,16,16,52),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Wallet
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (_) => DuePaymentScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Pay Dues', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 20),
                // Info
                _infoCard([
                  _infoRow(Icons.email_outlined, 'Email', user.email),
                  _infoRow(Icons.phone_outlined, 'Phone', user.phone),
                  _infoRow(Icons.home_outlined, 'Unit', user.unitNumber),
                  _infoRow(Icons.calendar_month_outlined, 'Member Since', DateFormat('MMMM yyyy').format(user.joinDate)),
                ]),
                const SizedBox(height: 16),
                _settingsCard(context),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMid),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMid)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _settingsCard(BuildContext context) {
    final items = [
      {'icon': Icons.notifications_outlined, 'label': 'Notifications', 'color': AppTheme.info, 'page': const NotificationsScreen()},
      {'icon': Icons.lock_outlined, 'label': 'Change Password', 'color': AppTheme.secondary, 'page': const ChangePasswordScreen()},
      {'icon': Icons.help_outline_rounded, 'label': 'Help & Support', 'color': AppTheme.success, 'page': const HelpFeedbackScreen()},
      {'icon': Icons.logout_rounded, 'label': 'Sign Out', 'color': AppTheme.error, 'page': const LoginScreen()},
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
      child: Column(
        children: items.map((item) {
          final color = item['color'] as Color;
          final page = item['page'] as Widget;
          return ListTile(
            leading: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
              child: Icon(item['icon'] as IconData, color: color, size: 18),
            ),
            title: Text(item['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textLight),
            onTap: () async {
              if (page is LoginScreen) {
                final shouldSignOut = await _confirmSignOut(context);
                if (!shouldSignOut) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                      (route) => false,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              }},
          );
        }).toList(),
      ),
    );
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Text('Confirm Sign Out', style: TextStyle(fontWeight: FontWeight.w700)),
              content: const Text('Are you sure you want to sign out?', style: TextStyle(height: 1.5)),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              actions: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textDark,
                    side: const BorderSide(color: AppTheme.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sign Out'),
                ),
              ],
            );
          },
        ) ?? false;
  }
}
