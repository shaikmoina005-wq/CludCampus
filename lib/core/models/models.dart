enum UserRole { student, faculty, hod, principal, collegeOffice }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.faculty:
        return 'Faculty';
      case UserRole.hod:
        return 'HOD';
      case UserRole.principal:
        return 'Principal';
      case UserRole.collegeOffice:
        return 'College Office';
    }
  }
}

class CollegeInfo {
  const CollegeInfo({
    required this.name,
    required this.code,
    required this.city,
    required this.abbrev,
    this.isLive = false,
    this.address,
    this.phone,
    this.email,
    this.affiliation,
  });

  final String name;
  final String code;
  final String city;
  final String abbrev;
  final bool isLive;
  final String? address;
  final String? phone;
  final String? email;
  final String? affiliation;

  String get statusLabel => isLive ? 'LIVE' : 'Onboarding';
}

class DemoRoleProfile {
  const DemoRoleProfile({
    required this.name,
    required this.detail,
    required this.phone,
    required this.role,
    required this.initials,
    required this.otp,
  });

  final String name;
  final String detail;
  final String phone;
  final UserRole role;
  final String initials;

  /// Local 6-digit code for this enrolled number. There is no SMS gateway.
  final String otp;

  bool acceptsOtp(String code) => otp == code.trim();
}

class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.rollNo,
    required this.college,
    required this.collegeCode,
    required this.branch,
    required this.year,
    required this.section,
    required this.email,
    required this.phone,
  });

  final String name;
  final String rollNo;
  final String college;
  final String collegeCode;
  final String branch;
  final String year;
  final String section;
  final String email;
  final String phone;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get programmeLine => '$branch · $year $section';
}

class SubjectAttendance {
  const SubjectAttendance({
    required this.code,
    required this.name,
    required this.present,
    required this.total,
  });

  final String code;
  final String name;
  final int present;
  final int total;

  double get percent => total == 0 ? 0 : (present / total) * 100;

  int get classesNeededFor75 {
    if (percent >= 75) return 0;
    var x = 0;
    while ((present + x) / (total + x) < 0.75) {
      x++;
      if (x > 200) break;
    }
    return x;
  }
}

class AttendanceSummary {
  const AttendanceSummary({
    required this.overallPresent,
    required this.overallTotal,
    required this.subjects,
  });

  final int overallPresent;
  final int overallTotal;
  final List<SubjectAttendance> subjects;

  double get overallPercent =>
      overallTotal == 0 ? 0 : (overallPresent / overallTotal) * 100;
}

class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.code,
    required this.faculty,
    required this.room,
    this.yearSection = 'II Year A',
  });

  final String day;
  final String startTime;
  final String endTime;
  final String subject;
  final String code;
  final String faculty;
  final String room;
  final String yearSection;
}

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.postedAt,
    this.pinned = false,
    this.issuer = 'College Office',
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime postedAt;
  final bool pinned;
  final String issuer;
}

class FeeItem {
  const FeeItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final String status;
}

class SkillSession {
  const SkillSession({
    required this.id,
    required this.title,
    required this.trainer,
    required this.date,
    required this.time,
    required this.venue,
    required this.tags,
  });

  final String id;
  final String title;
  final String trainer;
  final DateTime date;
  final String time;
  final String venue;
  final List<String> tags;
}

class DebateTopic {
  const DebateTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.votes,
    required this.capacity,
    this.closed = false,
  });

  final String id;
  final String title;
  final String description;
  final int votes;
  final int capacity;
  final bool closed;

  bool get isFull => votes >= capacity;
}

class LeaveRequest {
  const LeaveRequest({
    required this.id,
    required this.from,
    required this.to,
    required this.reason,
    required this.type,
    required this.status,
    required this.appliedOn,
  });

  final String id;
  final DateTime from;
  final DateTime to;
  final String reason;
  final String type;
  final String status;
  final DateTime appliedOn;
}

class AwardItem {
  const AwardItem({
    required this.id,
    required this.title,
    required this.person,
    required this.description,
    required this.status,
    required this.category,
  });

  final String id;
  final String title;
  final String person;
  final String description;
  final String status; // AWARDED / NOMINATED
  final String category;
}

class ReminderNote {
  const ReminderNote({
    required this.id,
    required this.text,
    required this.date,
  });

  final String id;
  final String text;
  final DateTime date;
}

class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.attribution,
    required this.color,
  });

  final String id;
  final String title;
  final DateTime date;
  final String attribution;
  final int color;
}

class TechNewsItem {
  const TechNewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.source,
    required this.date,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final String source;
  final DateTime date;
}

class ExamPaper {
  const ExamPaper({
    required this.id,
    required this.subject,
    required this.code,
    required this.dateLabel,
    required this.timeLabel,
  });

  final String id;
  final String subject;
  final String code;
  final String dateLabel;
  final String timeLabel;
}

class FacultyMember {
  const FacultyMember({
    required this.id,
    required this.name,
    required this.designation,
    required this.subjects,
    required this.initials,
  });

  final String id;
  final String name;
  final String designation;
  final String subjects;
  final String initials;
}

class CourseYear {
  const CourseYear({required this.year, required this.papers});

  final String year;
  final List<String> papers;
}

class CalendarDayInfo {
  const CalendarDayInfo({
    required this.date,
    required this.label,
    this.isHoliday = false,
    this.hasReminder = false,
  });

  final DateTime date;
  final String label;
  final bool isHoliday;
  final bool hasReminder;
}
