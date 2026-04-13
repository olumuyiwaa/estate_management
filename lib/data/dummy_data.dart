import '../models/models.dart';

class DummyData {
  // ── Members ───────────────────────────────────────────────────────────────
  static final List<EstateMember> members = [
    EstateMember(id: 'm1', name: 'Adaeze Okonkwo', email: 'adaeze@email.com', phone: '+234 801 234 5678', unitNumber: 'A-101', avatarInitials: 'AO', role: MemberRole.exco, isVerified: true, joinDate: DateTime(2021, 3, 12)),
    EstateMember(id: 'm2', name: 'Chukwuemeka Eze', email: 'emeka@email.com', phone: '+234 802 345 6789', unitNumber: 'A-102', avatarInitials: 'CE', role: MemberRole.owner, isVerified: true, joinDate: DateTime(2020, 7, 5)),
    EstateMember(id: 'm3', name: 'Fatima Al-Hassan', email: 'fatima@email.com', phone: '+234 803 456 7890', unitNumber: 'B-201', avatarInitials: 'FA', role: MemberRole.tenant, isVerified: true, joinDate: DateTime(2022, 1, 20)),
    EstateMember(id: 'm4', name: 'Babatunde Lawal', email: 'babs@email.com', phone: '+234 804 567 8901', unitNumber: 'B-202', avatarInitials: 'BL', role: MemberRole.owner, isVerified: false, joinDate: DateTime(2023, 5, 10)),
    EstateMember(id: 'm5', name: 'Ngozi Dike', email: 'ngozi@email.com', phone: '+234 805 678 9012', unitNumber: 'C-301', avatarInitials: 'ND', role: MemberRole.tenant, isVerified: true, joinDate: DateTime(2022, 9, 15)),
    EstateMember(id: 'm6', name: 'Kayode Afolabi', email: 'kayode@email.com', phone: '+234 806 789 0123', unitNumber: 'C-302', avatarInitials: 'KA', role: MemberRole.exco, isVerified: true, joinDate: DateTime(2019, 11, 30)),
    EstateMember(id: 'm7', name: 'Amaka Nwosu', email: 'amaka@email.com', phone: '+234 807 890 1234', unitNumber: 'D-401', avatarInitials: 'AN', role: MemberRole.facilityManager, isVerified: true, joinDate: DateTime(2021, 6, 8)),
    EstateMember(id: 'm8', name: 'Taiwo Adeleke', email: 'taiwo@email.com', phone: '+234 808 901 2345', unitNumber: 'D-402', avatarInitials: 'TA', role: MemberRole.owner, isVerified: true, joinDate: DateTime(2020, 2, 14)),
  ];

  // ── Payments ──────────────────────────────────────────────────────────────
  static final List<PaymentRecord> payments = [
    PaymentRecord(id: 'p1', memberId: 'm1', memberName: 'Adaeze Okonkwo', description: 'Service Charge Q1 2025', unitNumber: 'A-101', amount: 75000, status: PaymentStatus.paid, dueDate: DateTime(2025, 3, 31), paidDate: DateTime(2025, 3, 15), category: 'Service Charge'),
    PaymentRecord(id: 'p2', memberId: 'm2', memberName: 'Chukwuemeka Eze', description: 'Service Charge Q1 2025', unitNumber: 'A-102', amount: 75000, status: PaymentStatus.paid, dueDate: DateTime(2025, 3, 31), paidDate: DateTime(2025, 3, 18), category: 'Service Charge'),
    PaymentRecord(id: 'p3', memberId: 'm3', memberName: 'Fatima Al-Hassan', description: 'Service Charge Q1 2025', unitNumber: 'B-201', amount: 75000, status: PaymentStatus.pending, dueDate: DateTime(2025, 3, 31), category: 'Service Charge'),
    PaymentRecord(id: 'p4', memberId: 'm4', memberName: 'Babatunde Lawal', description: 'Generator Levy Jan', unitNumber: 'B-202', amount: 15000, status: PaymentStatus.overdue, dueDate: DateTime(2025, 1, 31), category: 'Generator Levy'),
    PaymentRecord(id: 'p9', memberId: 'm1', memberName: 'Adaeze Okonkwo', description: 'Generator Levy Jan', unitNumber: 'A-101', amount: 15000, status: PaymentStatus.overdue, dueDate: DateTime(2025, 1, 31), category: 'Generator Levy'),
    PaymentRecord(id: 'p5', memberId: 'm5', memberName: 'Ngozi Dike', description: 'Waste Management Fee', unitNumber: 'C-301', amount: 5000, status: PaymentStatus.paid, dueDate: DateTime(2025, 2, 28), paidDate: DateTime(2025, 2, 20), category: 'Waste Management'),
    PaymentRecord(id: 'p10', memberId: 'm1', memberName: 'Adaeze Okonkwo', description: 'Waste Management Fee', unitNumber: 'A-101', amount: 5000, status: PaymentStatus.pending, dueDate: DateTime(2025, 2, 28), paidDate: DateTime(2025, 2, 20), category: 'Waste Management'),
    PaymentRecord(id: 'p6', memberId: 'm6', memberName: 'Kayode Afolabi', description: 'Service Charge Q1 2025', unitNumber: 'C-302', amount: 75000, status: PaymentStatus.paid, dueDate: DateTime(2025, 3, 31), paidDate: DateTime(2025, 3, 5), category: 'Service Charge'),
    PaymentRecord(id: 'p7', memberId: 'm8', memberName: 'Taiwo Adeleke', description: 'Generator Levy Feb', unitNumber: 'D-402', amount: 15000, status: PaymentStatus.pending, dueDate: DateTime(2025, 2, 28), category: 'Generator Levy'),
    PaymentRecord(id: 'p8', memberId: 'm5', memberName: 'Ngozi Dike', description: 'Security Levy Q1', unitNumber: 'C-301', amount: 20000, status: PaymentStatus.overdue, dueDate: DateTime(2025, 1, 15), category: 'Security Levy'),
    PaymentRecord(id: 'p11', memberId: 'm1', memberName: 'Adaeze Okonkwo', description: 'Security Levy Q1', unitNumber: 'A-101', amount: 20000, status: PaymentStatus.overdue, dueDate: DateTime(2025, 1, 15), category: 'Security Levy'),
  ];

  // ── Incidents ─────────────────────────────────────────────────────────────
  static final List<Incident> incidents = [
    Incident(id: 'i1', reportedBy: 'Adaeze Okonkwo', title: 'Street Light Out – Block B Entrance', description: 'The street light at Block B entrance has been off for 3 days causing security concerns at night.', location: 'Block B Entrance', status: IncidentStatus.inProgress, priority: TicketPriority.high, reportedAt: DateTime(2025, 4, 8), assignedTo: 'Amaka Nwosu'),
    Incident(id: 'i2', reportedBy: 'Fatima Al-Hassan', title: 'Burst Pipe – B-201 Bathroom', description: 'Water pipe burst under bathroom sink, causing water damage to floor.', location: 'Unit B-201', status: IncidentStatus.open, priority: TicketPriority.urgent, reportedAt: DateTime(2025, 4, 10)),
    Incident(id: 'i3', reportedBy: 'Ngozi Dike', title: 'Elevator Malfunction – Block C', description: 'Elevator in Block C stopped working. Residents unable to use it.', location: 'Block C', status: IncidentStatus.inProgress, priority: TicketPriority.urgent, reportedAt: DateTime(2025, 4, 7), assignedTo: 'Amaka Nwosu'),
    Incident(id: 'i4', reportedBy: 'Babatunde Lawal', title: 'Pothole – Main Driveway', description: 'Large pothole near the main gate entrance, risk of vehicle damage.', location: 'Main Driveway', status: IncidentStatus.open, priority: TicketPriority.medium, reportedAt: DateTime(2025, 4, 5)),
    Incident(id: 'i5', reportedBy: 'Taiwo Adeleke', title: 'Noisy Generator – Night Hours', description: 'Generator running excessively loud after 11 PM, disturbing sleep.', location: 'Generator House', status: IncidentStatus.resolved, priority: TicketPriority.low, reportedAt: DateTime(2025, 4, 1), assignedTo: 'Amaka Nwosu'),
  ];

  // ── Visitors ──────────────────────────────────────────────────────────────
  static final List<Visitor> visitors = [
    Visitor(id: 'v1', name: 'Mr. Olumide Benson', phone: '+234 810 111 2222', hostUnit: 'A-101', hostName: 'Adaeze Okonkwo', purpose: 'Personal Visit', lastAction: AccessType.entry, timestamp: DateTime.now().subtract(const Duration(hours: 2)), hasQrPass: true),
    Visitor(id: 'v6', name: 'Mrs. Ifeoma Uzo', phone: '+234 814 555 6666', hostUnit: 'A-101', hostName: 'Adaeze Okonkwo', purpose: 'Family Visit', lastAction: AccessType.exit, timestamp: DateTime.now().subtract(const Duration(minutes: 50)), hasQrPass: true),
    Visitor(id: 'v7', name: 'Laundry Delivery', phone: '+234 815 777 8888', hostUnit: 'A-101', hostName: 'Adaeze Okonkwo', purpose: 'Parcel Delivery', lastAction: AccessType.entry, timestamp: DateTime.now().subtract(const Duration(minutes: 35)), hasQrPass: false),
    Visitor(id: 'v2', name: 'Plumber - Jimoh Rasheed', phone: '+234 811 222 3333', hostUnit: 'B-201', hostName: 'Fatima Al-Hassan', purpose: 'Maintenance', lastAction: AccessType.entry, timestamp: DateTime.now().subtract(const Duration(hours: 1)), hasQrPass: false),
    Visitor(id: 'v3', name: 'Mrs. Grace Obi', phone: '+234 812 333 4444', hostUnit: 'C-301', hostName: 'Ngozi Dike', purpose: 'Family Visit', lastAction: AccessType.exit, timestamp: DateTime.now().subtract(const Duration(hours: 5)), hasQrPass: true),
    Visitor(id: 'v4', name: 'DHL Delivery', phone: '+234 700 345 7890', hostUnit: 'D-402', hostName: 'Taiwo Adeleke', purpose: 'Delivery', lastAction: AccessType.exit, timestamp: DateTime.now().subtract(const Duration(minutes: 45)), hasQrPass: false),
    Visitor(id: 'v5', name: 'Chidi Anyanwu', phone: '+234 813 444 5555', hostUnit: 'A-102', hostName: 'Chukwuemeka Eze', purpose: 'Business Meeting', lastAction: AccessType.entry, timestamp: DateTime.now().subtract(const Duration(minutes: 20)), hasQrPass: true),
  ];

  // ── Facility Bookings ─────────────────────────────────────────────────────
  static final List<FacilityBooking> bookings = [
    FacilityBooking(id: 'fb1', facilityName: 'Swimming Pool', bookedBy: 'Adaeze Okonkwo', unit: 'A-101', date: DateTime(2025, 4, 13), timeSlot: '10:00 AM – 12:00 PM', status: BookingStatus.confirmed, fee: 5000),
    FacilityBooking(id: 'fb2', facilityName: 'Clubhouse', bookedBy: 'Taiwo Adeleke', unit: 'D-402', date: DateTime(2025, 4, 14), timeSlot: '4:00 PM – 8:00 PM', status: BookingStatus.confirmed, fee: 25000),
    FacilityBooking(id: 'fb3', facilityName: 'Tennis Court', bookedBy: 'Kayode Afolabi', unit: 'C-302', date: DateTime(2025, 4, 12), timeSlot: '7:00 AM – 9:00 AM', status: BookingStatus.pending, fee: 3000),
    FacilityBooking(id: 'fb4', facilityName: 'Event Hall', bookedBy: 'Ngozi Dike', unit: 'C-301', date: DateTime(2025, 4, 20), timeSlot: '2:00 PM – 10:00 PM', status: BookingStatus.pending, fee: 80000),
    FacilityBooking(id: 'fb5', facilityName: 'Gym', bookedBy: 'Fatima Al-Hassan', unit: 'B-201', date: DateTime(2025, 4, 11), timeSlot: '6:00 AM – 7:00 AM', status: BookingStatus.cancelled, fee: 2000),
  ];

  // ── Notices ───────────────────────────────────────────────────────────────
  static final List<Notice> notices = [
    Notice(id: 'n1', title: 'Water Shutdown – Saturday 12 April', body: 'There will be a scheduled water shutdown on Saturday 12 April from 8 AM to 2 PM for maintenance work. Please store sufficient water. Apologies for the inconvenience.', category: 'Maintenance', postedBy: 'Estate Management', postedAt: DateTime.now().subtract(const Duration(hours: 3)), isPinned: true),
    Notice(id: 'n2', title: 'AGM – Sunday 27 April 2025', body: 'The Annual General Meeting will hold on Sunday 27 April at 4 PM in the Estate Clubhouse. All owners and residents are encouraged to attend. Agenda will be shared separately.', category: 'Meeting', postedBy: 'Exco', postedAt: DateTime.now().subtract(const Duration(days: 1)), isPinned: true),
    Notice(id: 'n3', title: 'New Waste Collection Schedule', body: 'Starting May 1st, waste collection will be every Monday and Thursday morning. Bins must be placed outside by 7 AM on collection days.', category: 'General', postedBy: 'Estate Management', postedAt: DateTime.now().subtract(const Duration(days: 2)), isPinned: false),
    Notice(id: 'n4', title: 'Estate Market Day – 19 April', body: 'Our monthly estate market day is back! Residents can sell goods and services. Book your spot by contacting the estate office.', category: 'Community', postedBy: 'Exco', postedAt: DateTime.now().subtract(const Duration(days: 3)), isPinned: false),
    Notice(id: 'n5', title: 'Reminder: Service Charge Q1 Due Date', body: 'Please note that Q1 2025 service charges are due by March 31st. Payments can be made via the app or estate account. Late payments attract a 10% penalty.', category: 'Finance', postedBy: 'Finance Committee', postedAt: DateTime.now().subtract(const Duration(days: 5)), isPinned: false),
  ];

  // ── Vendors ───────────────────────────────────────────────────────────────
  static final List<Vendor> vendors = [
    const Vendor(id: 'vd1', name: 'CleanPro Services', category: 'Cleaning', contactPerson: 'Mr. Emeka Obi', phone: '+234 801 111 0001', email: 'cleanpro@vendor.com', rating: 4.7, isApproved: true),
    const Vendor(id: 'vd2', name: 'SwiftFix Plumbing', category: 'Plumbing', contactPerson: 'Alhaji Musa Bello', phone: '+234 802 222 0002', email: 'swiftfix@vendor.com', rating: 4.3, isApproved: true),
    const Vendor(id: 'vd3', name: 'PowerGen Electricals', category: 'Electrical', contactPerson: 'Engr. Tunde Adesanya', phone: '+234 803 333 0003', email: 'powergen@vendor.com', rating: 4.8, isApproved: true),
    const Vendor(id: 'vd4', name: 'GreenLawn Landscaping', category: 'Landscaping', contactPerson: 'Mr. Victor Onuoha', phone: '+234 804 444 0004', email: 'greenlawn@vendor.com', rating: 4.1, isApproved: false),
    const Vendor(id: 'vd5', name: 'GuardPro Security', category: 'Security', contactPerson: 'Comdr. Jide Fasanya (Rtd)', phone: '+234 805 555 0005', email: 'guardpro@vendor.com', rating: 4.6, isApproved: true),
  ];

  // ── Market Listings ────────────────────────────────────────────────────────
  static final List<MarketListing> listings = [
    MarketListing(id: 'ml1', title: 'Brand New Refrigerator (LG)', description: 'LG 200L single door fridge, barely used, relocating. Original box available.', sellerName: 'Chukwuemeka Eze', sellerUnit: 'A-102', category: 'Electronics', price: 85000, isService: false, listedAt: DateTime.now().subtract(const Duration(days: 1))),
    MarketListing(id: 'ml2', title: 'Professional Cleaning Service', description: 'Deep cleaning of apartments. Thorough, reliable and affordable. 3+ years experience.', sellerName: 'Amaka Nwosu', sellerUnit: 'D-401', category: 'Services', price: 12000, isService: true, listedAt: DateTime.now().subtract(const Duration(hours: 6))),
    MarketListing(id: 'ml3', title: 'Children\'s Bicycle (Age 6–9)', description: 'Red bicycle with training wheels. Good condition, child outgrown.', sellerName: 'Ngozi Dike', sellerUnit: 'C-301', category: 'Kids & Toys', price: 18000, isService: false, listedAt: DateTime.now().subtract(const Duration(days: 3))),
    MarketListing(id: 'ml4', title: 'Private Lesson – Mathematics', description: 'WAEC/NECO level maths tutoring. Weekends only. Score guaranteed improvement.', sellerName: 'Fatima Al-Hassan', sellerUnit: 'B-201', category: 'Services', price: 8000, isService: true, listedAt: DateTime.now().subtract(const Duration(days: 2))),
    MarketListing(id: 'ml5', title: 'Standing Fan (Binatone)', description: 'Working 16-inch standing fan, selling due to upgrade. Pick-up only.', sellerName: 'Babatunde Lawal', sellerUnit: 'B-202', category: 'Home Appliances', price: 9500, isService: false, listedAt: DateTime.now().subtract(const Duration(days: 4))),
  ];

  // ── Financial summary ─────────────────────────────────────────────────────
  static const double totalBudget = 5000000;
  static const double totalExpenses = 2125000;
  static const double totalCollected = 2850000;
  static const double totalExpected = 3600000;

  static final List<Map<String, dynamic>> monthlyIncome = [
    {'month': 'Oct', 'amount': 420000.0},
    {'month': 'Nov', 'amount': 390000.0},
    {'month': 'Dec', 'amount': 510000.0},
    {'month': 'Jan', 'amount': 445000.0},
    {'month': 'Feb', 'amount': 480000.0},
    {'month': 'Mar', 'amount': 605000.0},
  ];

  static final Map<int, List<Map<String, dynamic>>> yearlyIncome = {
    2025: [
      {'month': 'Jan', 'amount': 420000.0},
      {'month': 'Feb', 'amount': 395000.0},
      {'month': 'Mar', 'amount': 510000.0},
      {'month': 'Apr', 'amount': 470000.0},
      {'month': 'May', 'amount': 445000.0},
      {'month': 'Jun', 'amount': 500000.0},
      {'month': 'Jul', 'amount': 525000.0},
      {'month': 'Aug', 'amount': 515000.0},
      {'month': 'Sep', 'amount': 485000.0},
      {'month': 'Oct', 'amount': 450000.0},
      {'month': 'Nov', 'amount': 395000.0},
      {'month': 'Dec', 'amount': 530000.0},
    ],
    2024: [
      {'month': 'Jan', 'amount': 385000.0},
      {'month': 'Feb', 'amount': 410000.0},
      {'month': 'Mar', 'amount': 460000.0},
      {'month': 'Apr', 'amount': 430000.0},
      {'month': 'May', 'amount': 415000.0},
      {'month': 'Jun', 'amount': 470000.0},
      {'month': 'Jul', 'amount': 490000.0},
      {'month': 'Aug', 'amount': 505000.0},
      {'month': 'Sep', 'amount': 465000.0},
      {'month': 'Oct', 'amount': 440000.0},
      {'month': 'Nov', 'amount': 405000.0},
      {'month': 'Dec', 'amount': 520000.0},
    ],
    2023: [
      {'month': 'Jan', 'amount': 360000.0},
      {'month': 'Feb', 'amount': 375000.0},
      {'month': 'Mar', 'amount': 420000.0},
      {'month': 'Apr', 'amount': 400000.0},
      {'month': 'May', 'amount': 390000.0},
      {'month': 'Jun', 'amount': 450000.0},
      {'month': 'Jul', 'amount': 470000.0},
      {'month': 'Aug', 'amount': 480000.0},
      {'month': 'Sep', 'amount': 455000.0},
      {'month': 'Oct', 'amount': 430000.0},
      {'month': 'Nov', 'amount': 395000.0},
      {'month': 'Dec', 'amount': 500000.0},
    ],
  };

  static final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Security', 'amount': 250000.0, 'color': 0xFF0D1B2A},
    {'name': 'Generator', 'amount': 180000.0, 'color': 0xFFC9973A},
    {'name': 'Cleaning', 'amount': 420000.0, 'color': 0xFF1B4F72},
    {'name': 'Maintenance', 'amount': 580000.0, 'color': 0xFF27AE60},
    {'name': 'Admin', 'amount': 695000.0, 'color': 0xFFE74C3C},
  ];

  static final List<GroupChat> groupChats = [
    const GroupChat(
      id: 'gc1',
      title: 'Estate Group Chat',
      description: 'Automatically includes all onboarded estate members.',
      includeAll: true,
      roles: [],
    ),
    const GroupChat(
      id: 'gc2',
      title: 'Excos Group Chat',
      description: 'A dedicated space for Exco members and coordinators.',
      includeAll: false,
      roles: [MemberRole.exco],
    ),
    const GroupChat(
      id: 'gc3',
      title: 'Facility Managers Group Chat',
      description: 'Facility managers and support staff only.',
      includeAll: false,
      roles: [MemberRole.facilityManager],
    ),
  ];

  static final List<ChatMessage> chatMessages = [
    const ChatMessage(id: 'cm1', groupId: 'gc1', sender: 'Adaeze Okonkwo', text: 'Welcome everyone! The estate meeting is scheduled for Friday.', timestamp: '09:12 AM'),
    const ChatMessage(id: 'cm2', groupId: 'gc1', sender: 'Chukwuemeka Eze', text: 'Great, I will share the agenda shortly.', timestamp: '09:15 AM'),
    const ChatMessage(id: 'cm3', groupId: 'gc2', sender: 'Kayode Afolabi', text: 'Exco members, please confirm attendance for the planning session.', timestamp: '08:55 AM'),
    const ChatMessage(id: 'cm4', groupId: 'gc3', sender: 'Amaka Nwosu', text: 'Facility team, the pool cleaning will start at 7 AM tomorrow.', timestamp: '07:40 AM'),
  ];

  static List<EstateMember> groupChatParticipants(GroupChat chat) {
    if (chat.includeAll) return members;
    return members.where((member) => chat.roles.contains(member.role)).toList();
  }

  static final List<MeetingMinute> meetingMinutes = [
    MeetingMinute(
      id: 'mm1',
      title: 'Exco Strategy Review',
      summary: 'Reviewed the upcoming maintenance budget and assigned team leads for the estate improvement plan.',
      date: DateTime(2025, 3, 26),
      author: 'Kayode Afolabi',
    ),
    MeetingMinute(
      id: 'mm2',
      title: 'Security Update',
      summary: 'Approved new CCTV installation and increased evening perimeter patrols for the next 30 days.',
      date: DateTime(2025, 3, 15),
      author: 'Amaka Nwosu',
    ),
    MeetingMinute(
      id: 'mm3',
      title: 'Facility Booking Policy',
      summary: 'Finalized new booking rules and penalties for late cancellation of event hall reservations.',
      date: DateTime(2025, 2, 28),
      author: 'Ngozi Dike',
    ),
  ];

  static final List<MeetingEvent> upcomingMeetings = [
    MeetingEvent(
      id: 'me1',
      title: 'Annual General Meeting',
      location: 'Estate Clubhouse',
      start: DateTime(2025, 4, 27, 16, 0),
      end: DateTime(2025, 4, 27, 18, 0),
      agenda: 'Review annual reports, budget approval, and community proposal voting.',
    ),
    MeetingEvent(
      id: 'me2',
      title: 'Facility Team Coordination',
      location: 'Facility Office',
      start: DateTime(2025, 4, 14, 10, 0),
      end: DateTime(2025, 4, 14, 11, 0),
      agenda: 'Align on maintenance schedule and resource allocation for April.',
    ),
    MeetingEvent(
      id: 'me3',
      title: 'Security Briefing',
      location: 'Security Control Room',
      start: DateTime(2025, 4, 18, 9, 30),
      end: DateTime(2025, 4, 18, 10, 15),
      agenda: 'Review visitor access logs and adjust night patrol rotas.',
    ),
  ];

  // ── Current user ──────────────────────────────────────────────────────────
  static final EstateMember currentUser = members[0];
  static const String estateName = 'Emerald Gardens Estate';
  static const String estateAddress = 'Plot 45, Lekki Phase 2, Lagos';
}
