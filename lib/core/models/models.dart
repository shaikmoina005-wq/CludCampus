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
    // Solve (present + x) / (total + x) >= 0.75
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
  });

  final String day; // Mon..Sun
  final String startTime;
  final String endTime;
  final String subject;
  final String code;
  final String faculty;
  final String room;
}

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.postedAt,
    this.pinned = false,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime postedAt;
  final bool pinned;
}

class FeeItem {
  const FeeItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status, // paid | pending | overdue
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
  final String status; // Pending | Approved | Rejected
  final DateTime appliedOn;
}

class AwardItem {
  const AwardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.awardedOn,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final DateTime awardedOn;
  final String category;
}
