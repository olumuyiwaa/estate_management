// models/models.dart

enum MemberRole { owner, tenant, exco, facilityManager, securityPersonnel }
enum PaymentStatus { paid, pending, overdue }
enum IncidentStatus { open, inProgress, resolved }
enum TicketPriority { low, medium, high, urgent }
enum AccessType { entry, exit }
enum BookingStatus { confirmed, pending, cancelled }

class EstateMember {
  final String id, name, email, phone, unitNumber, avatarInitials;
  final MemberRole role;
  final bool isVerified;
  final DateTime joinDate;
  final double walletBalance;

  const EstateMember({
    required this.id, required this.name, required this.email,
    required this.phone, required this.unitNumber, required this.avatarInitials,
    required this.role, required this.isVerified, required this.joinDate,
    required this.walletBalance,
  });

  String get roleLabel {
    switch (role) {
      case MemberRole.owner: return 'Owner';
      case MemberRole.tenant: return 'Tenant';
      case MemberRole.exco: return 'Exco';
      case MemberRole.facilityManager: return 'Facility Manager';
      case MemberRole.securityPersonnel: return 'Security';
    }
  }
}

class PaymentRecord {
  final String id, memberId, memberName, description, unitNumber;
  final double amount;
  final PaymentStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String category;

  const PaymentRecord({
    required this.id, required this.memberId, required this.memberName,
    required this.description, required this.unitNumber, required this.amount,
    required this.status, required this.dueDate, this.paidDate, required this.category,
  });
}

class Incident {
  final String id, reportedBy, title, description, location;
  final IncidentStatus status;
  final TicketPriority priority;
  final DateTime reportedAt;
  final String? assignedTo;

  const Incident({
    required this.id, required this.reportedBy, required this.title,
    required this.description, required this.location, required this.status,
    required this.priority, required this.reportedAt, this.assignedTo,
  });
}

class Visitor {
  final String id, name, phone, hostUnit, hostName, purpose;
  final AccessType lastAction;
  final DateTime timestamp;
  final bool hasQrPass;

  const Visitor({
    required this.id, required this.name, required this.phone,
    required this.hostUnit, required this.hostName, required this.purpose,
    required this.lastAction, required this.timestamp, required this.hasQrPass,
  });
}

class FacilityBooking {
  final String id, facilityName, bookedBy, unit;
  final DateTime date;
  final String timeSlot;
  final BookingStatus status;
  final double fee;

  const FacilityBooking({
    required this.id, required this.facilityName, required this.bookedBy,
    required this.unit, required this.date, required this.timeSlot,
    required this.status, required this.fee,
  });
}

class Notice {
  final String id, title, body, category, postedBy;
  final DateTime postedAt;
  final bool isPinned;

  const Notice({
    required this.id, required this.title, required this.body,
    required this.category, required this.postedBy,
    required this.postedAt, required this.isPinned,
  });
}

class Vendor {
  final String id, name, category, contactPerson, phone, email;
  final double rating;
  final bool isApproved;

  const Vendor({
    required this.id, required this.name, required this.category,
    required this.contactPerson, required this.phone, required this.email,
    required this.rating, required this.isApproved,
  });
}

class MarketListing {
  final String id, title, description, sellerName, sellerUnit, category;
  final double price;
  final bool isService;
  final DateTime listedAt;

  const MarketListing({
    required this.id, required this.title, required this.description,
    required this.sellerName, required this.sellerUnit, required this.category,
    required this.price, required this.isService, required this.listedAt,
  });
}

class GroupChat {
  final String id;
  final String title;
  final String description;
  final bool includeAll;
  final List<MemberRole> roles;

  const GroupChat({
    required this.id,
    required this.title,
    required this.description,
    required this.includeAll,
    required this.roles,
  });
}

class ChatMessage {
  final String id;
  final String groupId;
  final String sender;
  final String text;
  final String timestamp;

  const ChatMessage({
    required this.id,
    required this.groupId,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

class MeetingMinute {
  final String id;
  final String title;
  final String summary;
  final DateTime date;
  final String author;

  const MeetingMinute({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.author,
  });
}

class MeetingEvent {
  final String id;
  final String title;
  final String location;
  final DateTime start;
  final DateTime end;
  final String agenda;

  const MeetingEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.start,
    required this.end,
    required this.agenda,
  });
}
