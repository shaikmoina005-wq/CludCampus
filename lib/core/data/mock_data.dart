import '../models/models.dart';

class MockData {
  static const student = StudentProfile(
    name: 'Priya Sharma',
    rollNo: 'Y21CS045',
    college: 'ASN Degree College, Tenali',
    collegeCode: 'ASN-TENALI',
    branch: 'B.Sc Computer Science',
    year: 'III Year',
    section: 'A',
    email: 'priya.sharma@demo.cludcampus.com',
    phone: '+91 98765 43210',
  );

  static final attendance = AttendanceSummary(
    overallPresent: 186,
    overallTotal: 230,
    subjects: const [
      SubjectAttendance(
        code: 'CS301',
        name: 'Data Structures',
        present: 38,
        total: 45,
      ),
      SubjectAttendance(
        code: 'CS302',
        name: 'Database Systems',
        present: 34,
        total: 42,
      ),
      SubjectAttendance(
        code: 'CS303',
        name: 'Operating Systems',
        present: 40,
        total: 48,
      ),
      SubjectAttendance(
        code: 'CS304',
        name: 'Computer Networks',
        present: 28,
        total: 40,
      ),
      SubjectAttendance(
        code: 'MA301',
        name: 'Discrete Mathematics',
        present: 30,
        total: 35,
      ),
      SubjectAttendance(
        code: 'EN301',
        name: 'Professional English',
        present: 16,
        total: 20,
      ),
    ],
  );

  static const timetable = <ClassSlot>[
    ClassSlot(
      day: 'Mon',
      startTime: '09:00',
      endTime: '10:00',
      subject: 'Data Structures',
      code: 'CS301',
      faculty: 'Dr. R. Kumar',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '10:00',
      endTime: '11:00',
      subject: 'Database Systems',
      code: 'CS302',
      faculty: 'Ms. S. Reddy',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '11:15',
      endTime: '12:15',
      subject: 'Operating Systems',
      code: 'CS303',
      faculty: 'Prof. V. Naidu',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '09:00',
      endTime: '10:00',
      subject: 'Computer Networks',
      code: 'CS304',
      faculty: 'Mr. A. Prasad',
      room: 'A-203',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '10:00',
      endTime: '11:00',
      subject: 'Discrete Mathematics',
      code: 'MA301',
      faculty: 'Dr. L. Rao',
      room: 'B-110',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '11:15',
      endTime: '12:15',
      subject: 'Professional English',
      code: 'EN301',
      faculty: 'Ms. K. Devi',
      room: 'A-101',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '09:00',
      endTime: '11:00',
      subject: 'Data Structures Lab',
      code: 'CS301L',
      faculty: 'Dr. R. Kumar',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '11:15',
      endTime: '12:15',
      subject: 'Operating Systems',
      code: 'CS303',
      faculty: 'Prof. V. Naidu',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '09:00',
      endTime: '10:00',
      subject: 'Database Systems',
      code: 'CS302',
      faculty: 'Ms. S. Reddy',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '10:00',
      endTime: '11:00',
      subject: 'Computer Networks',
      code: 'CS304',
      faculty: 'Mr. A. Prasad',
      room: 'A-203',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '11:15',
      endTime: '12:15',
      subject: 'Discrete Mathematics',
      code: 'MA301',
      faculty: 'Dr. L. Rao',
      room: 'B-110',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '09:00',
      endTime: '10:00',
      subject: 'Professional English',
      code: 'EN301',
      faculty: 'Ms. K. Devi',
      room: 'A-101',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '10:00',
      endTime: '12:00',
      subject: 'Friday Skill — Soft Skills',
      code: 'SKILL',
      faculty: 'Industry Trainer',
      room: 'Seminar Hall',
    ),
    ClassSlot(
      day: 'Sat',
      startTime: '09:00',
      endTime: '11:00',
      subject: 'Database Lab',
      code: 'CS302L',
      faculty: 'Ms. S. Reddy',
      room: 'Lab-1',
    ),
  ];

  static final notices = <Notice>[
    Notice(
      id: 'n1',
      title: 'Mid-semester exam schedule released',
      body:
          'Mid-semester examinations for III Year B.Sc CS will be held from 6–12 October. '
          'Hall tickets will be available on CludCampus from 1 October. Students with '
          'attendance below 75% must meet the HOD before 28 September.',
      category: 'Exams',
      postedAt: DateTime(2026, 9, 18),
      pinned: true,
    ),
    Notice(
      id: 'n2',
      title: 'Friday Skill: Resume & Interview Prep',
      body:
          'This Friday’s skill session covers resume writing and mock interviews with '
          'alumni mentors. Reporting time 9:50 AM at Seminar Hall. Bring a printed resume.',
      category: 'Skills',
      postedAt: DateTime(2026, 9, 17),
      pinned: true,
    ),
    Notice(
      id: 'n3',
      title: 'Fee payment reminder — odd semester',
      body:
          'Last date for odd-semester tuition fee without fine is 30 September. '
          'Pay at the college office or via the Fees section in CludCampus (demo).',
      category: 'Fees',
      postedAt: DateTime(2026, 9, 15),
    ),
    Notice(
      id: 'n4',
      title: 'Library book return drive',
      body:
          'All overdue library books must be returned by 25 September. Fine waiver for '
          'returns before that date.',
      category: 'General',
      postedAt: DateTime(2026, 9, 12),
    ),
    Notice(
      id: 'n5',
      title: 'Sports day registrations open',
      body:
          'Inter-class sports day on 10 October. Register with the Physical Director by '
          '3 October. Events: cricket, volleyball, athletics, chess.',
      category: 'Events',
      postedAt: DateTime(2026, 9, 10),
    ),
  ];

  static final fees = <FeeItem>[
    FeeItem(
      id: 'f1',
      title: 'Odd Semester Tuition Fee',
      amount: 18500,
      dueDate: DateTime(2026, 9, 30),
      status: 'pending',
    ),
    FeeItem(
      id: 'f2',
      title: 'Lab Fee (CS)',
      amount: 2500,
      dueDate: DateTime(2026, 9, 30),
      status: 'pending',
    ),
    FeeItem(
      id: 'f3',
      title: 'Even Semester Tuition Fee',
      amount: 18500,
      dueDate: DateTime(2026, 3, 15),
      status: 'paid',
    ),
    FeeItem(
      id: 'f4',
      title: 'Exam Fee — Even Sem',
      amount: 1200,
      dueDate: DateTime(2026, 3, 20),
      status: 'paid',
    ),
  ];

  static final skills = <SkillSession>[
    SkillSession(
      id: 's1',
      title: 'Resume & Interview Prep',
      trainer: 'Alumni Mentors Panel',
      date: DateTime(2026, 9, 26),
      time: '10:00 – 12:00',
      venue: 'Seminar Hall',
      tags: const ['Career', 'Soft Skills'],
    ),
    SkillSession(
      id: 's2',
      title: 'Git & GitHub Essentials',
      trainer: 'Mr. Arun (Industry)',
      date: DateTime(2026, 10, 3),
      time: '10:00 – 12:00',
      venue: 'Lab-2',
      tags: const ['Technical', 'Dev Tools'],
    ),
    SkillSession(
      id: 's3',
      title: 'Public Speaking Lab',
      trainer: 'Ms. Kavitha',
      date: DateTime(2026, 10, 10),
      time: '10:00 – 12:00',
      venue: 'Seminar Hall',
      tags: const ['Soft Skills'],
    ),
    SkillSession(
      id: 's4',
      title: 'Intro to SQL for Interviews',
      trainer: 'Ms. S. Reddy',
      date: DateTime(2026, 10, 17),
      time: '10:00 – 12:00',
      venue: 'Lab-1',
      tags: const ['Technical', 'Databases'],
    ),
  ];

  static final leaves = <LeaveRequest>[
    LeaveRequest(
      id: 'l1',
      from: DateTime(2026, 9, 5),
      to: DateTime(2026, 9, 6),
      reason: 'Family function in Vijayawada',
      type: 'Personal',
      status: 'Approved',
      appliedOn: DateTime(2026, 9, 2),
    ),
    LeaveRequest(
      id: 'l2',
      from: DateTime(2026, 8, 18),
      to: DateTime(2026, 8, 18),
      reason: 'Medical checkup',
      type: 'Medical',
      status: 'Approved',
      appliedOn: DateTime(2026, 8, 17),
    ),
    LeaveRequest(
      id: 'l3',
      from: DateTime(2026, 9, 22),
      to: DateTime(2026, 9, 23),
      reason: 'Attending cousin’s wedding',
      type: 'Personal',
      status: 'Pending',
      appliedOn: DateTime(2026, 9, 19),
    ),
  ];

  static final awards = <AwardItem>[
    AwardItem(
      id: 'a1',
      title: 'Dean’s List — Even Semester',
      description: 'Recognized for academic excellence with CGPA above 8.5.',
      awardedOn: DateTime(2026, 5, 20),
      category: 'Academic',
    ),
    AwardItem(
      id: 'a2',
      title: 'Best Project — Mini Project Expo',
      description: 'Campus inventory tracker won first place among III Year teams.',
      awardedOn: DateTime(2026, 3, 12),
      category: 'Project',
    ),
    AwardItem(
      id: 'a3',
      title: 'Volunteer of the Semester',
      description: 'Outstanding contribution to NSS blood donation camp.',
      awardedOn: DateTime(2026, 2, 8),
      category: 'Service',
    ),
  ];

  static String weekdayShort(DateTime d) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[d.weekday - 1];
  }

  static List<ClassSlot> todayClasses([DateTime? now]) {
    final day = weekdayShort(now ?? DateTime.now());
    return timetable.where((c) => c.day == day).toList();
  }
}
