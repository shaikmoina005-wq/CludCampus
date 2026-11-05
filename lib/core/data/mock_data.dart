import '../models/models.dart';

class MockData {
  static const colleges = <CollegeInfo>[
    CollegeInfo(
      name: 'ASN Degree College, Tenali',
      code: 'ASN-TNL',
      city: 'Tenali',
      abbrev: 'ASN',
      isLive: true,
      address: 'Ganganammapet, Tenali, Guntur Dist., Andhra Pradesh 522201',
      phone: '+91 8644 222 100',
      email: 'office@asndegreetenali.edu.in',
      affiliation: 'ANU / APSCHE',
    ),
    CollegeInfo(
      name: 'Sri Venkateswara Degree College',
      code: 'SVDC-GNT',
      city: 'Guntur',
      abbrev: 'SVD',
    ),
    CollegeInfo(
      name: 'Andhra Loyola Degree College',
      code: 'ALDC-VJA',
      city: 'Vijayawada',
      abbrev: 'ALD',
    ),
    CollegeInfo(
      name: 'Maris Stella Degree College',
      code: 'MSDC-VJA',
      city: 'Vijayawada',
      abbrev: 'MSD',
    ),
    CollegeInfo(
      name: 'PB Siddhartha College of Arts & Science',
      code: 'PBSC-VJA',
      city: 'Vijayawada',
      abbrev: 'PBS',
    ),
    CollegeInfo(
      name: 'KBN Degree College',
      code: 'KBND-VJA',
      city: 'Vijayawada',
      abbrev: 'KBN',
    ),
  ];

  /// Enrolled campus identities. Each profile has its own local OTP.
  /// Those codes stay off the login screen; sign-in matches the mobile
  /// to the person, then checks that person's code.
  static const demoRoles = <DemoRoleProfile>[
    DemoRoleProfile(
      name: 'Eshu Sahana',
      detail: 'B.Sc Computer Science · II Year',
      phone: '+91 98765 01002',
      role: UserRole.student,
      initials: 'ES',
      otp: '010002',
    ),
    DemoRoleProfile(
      name: 'Priya Reddy',
      detail: 'B.Sc Computer Science · II Year',
      phone: '+91 98765 01001',
      role: UserRole.student,
      initials: 'PR',
      otp: '010001',
    ),
    DemoRoleProfile(
      name: 'Kiran Teja',
      detail: 'B.C.A · III Year',
      phone: '+91 98765 01011',
      role: UserRole.student,
      initials: 'KT',
      otp: '010011',
    ),
    DemoRoleProfile(
      name: 'Dr Ramesh Kumar',
      detail: 'Assistant Professor · Computer Science',
      phone: '+91 98765 02001',
      role: UserRole.faculty,
      initials: 'RK',
      otp: '020001',
    ),
    DemoRoleProfile(
      name: 'Prof Lakshmi Narayana',
      detail: 'Head · Computer Science',
      phone: '+91 98765 03001',
      role: UserRole.hod,
      initials: 'LN',
      otp: '030001',
    ),
    DemoRoleProfile(
      name: 'Dr Ramchand Kolasani',
      detail: 'Principal · B.E, MS, M.Tech, Ph.D',
      phone: '+91 98765 04001',
      role: UserRole.principal,
      initials: 'RK',
      otp: '040001',
    ),
    DemoRoleProfile(
      name: 'College Office',
      detail: 'Administrative office',
      phone: '+91 98765 05001',
      role: UserRole.collegeOffice,
      initials: 'CO',
      otp: '050001',
    ),
  ];

  static const student = StudentProfile(
    name: 'Priya Venkata Lakshmi Reddy',
    rollNo: 'Y21CS045',
    college: 'ASN Degree College, Tenali',
    collegeCode: 'ASN-TNL',
    branch: 'B.Sc Computer Science',
    year: 'II Year',
    section: 'A',
    email: 'priya.reddy@demo.cludcampus.com',
    phone: '+91 98765 01001',
  );

  /// Demo dashboard: 252/294 hours ≈ 86%.
  static final attendance = AttendanceSummary(
    overallPresent: 252,
    overallTotal: 294,
    subjects: const [
      SubjectAttendance(
        code: 'CSC201',
        name: 'Data Structures',
        present: 37,
        total: 42,
      ),
      SubjectAttendance(
        code: 'CSC202',
        name: 'Database Management Systems',
        present: 38,
        total: 42,
      ),
      SubjectAttendance(
        code: 'CSC203',
        name: 'Object Oriented Programming',
        present: 32,
        total: 42,
      ),
      SubjectAttendance(
        code: 'CSC204',
        name: 'Computer Networks',
        present: 35,
        total: 42,
      ),
      SubjectAttendance(
        code: 'SEC201',
        name: 'Python Programming',
        present: 40,
        total: 42,
      ),
      SubjectAttendance(
        code: 'CSC205',
        name: 'Discrete Mathematics',
        present: 34,
        total: 42,
      ),
      SubjectAttendance(
        code: 'AECC201',
        name: 'Environmental Studies',
        present: 36,
        total: 42,
      ),
    ],
  );

  static const examFeeAmount = 1450.0;
  static const examTitle = 'I Internal Examinations — 15 to 20 September 2026';
  static const recognitionTitle = 'Student of the Month';
  static const recognitionPeriod = 'August 2026';
  static const fridaySkillTitle = 'Pick a debate topic';
  static const fridaySkillTime = '3:00–4:50 pm';
  static const fridaySkillMeta =
      '40 present this Friday · 4 topics · 10 votes each';
  static const fridayPresentCount = 40;
  static const semesterLabel = 'Odd semester 2026–27 · Mon–Sat';

  static const timetable = <ClassSlot>[
    // Monday
    ClassSlot(
      day: 'Mon',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'DBMS',
      code: 'CSC202',
      faculty: 'Ms Divya Sri',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'OOP',
      code: 'CSC203',
      faculty: 'Ms Kavitha Rao',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '11:45',
      endTime: '12:35',
      subject: 'Discrete Mathematics',
      code: 'CSC205',
      faculty: 'Mrs Swathi Devi',
      room: 'B-110',
    ),
    ClassSlot(
      day: 'Mon',
      startTime: '12:35',
      endTime: '13:25',
      subject: 'Computer Networks',
      code: 'CSC204',
      faculty: 'Prof Lakshmi Narayana',
      room: 'A-203',
    ),
    // Tuesday
    ClassSlot(
      day: 'Tue',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'OOP',
      code: 'CSC203',
      faculty: 'Ms Kavitha Rao',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'Python Programming',
      code: 'SEC201',
      faculty: 'Ms Divya Sri',
      room: 'Lab-1',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '11:45',
      endTime: '12:35',
      subject: 'DBMS',
      code: 'CSC202',
      faculty: 'Ms Divya Sri',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Tue',
      startTime: '12:35',
      endTime: '13:25',
      subject: 'Environmental Studies',
      code: 'AECC201',
      faculty: 'Mrs Swathi Devi',
      room: 'A-101',
    ),
    // Wednesday
    ClassSlot(
      day: 'Wed',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'Computer Networks',
      code: 'CSC204',
      faculty: 'Prof Lakshmi Narayana',
      room: 'A-203',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'Discrete Mathematics',
      code: 'CSC205',
      faculty: 'Mrs Swathi Devi',
      room: 'B-110',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '11:45',
      endTime: '12:35',
      subject: 'OOP',
      code: 'CSC203',
      faculty: 'Ms Kavitha Rao',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Wed',
      startTime: '12:35',
      endTime: '13:25',
      subject: 'Python Programming',
      code: 'SEC201',
      faculty: 'Ms Divya Sri',
      room: 'Lab-1',
    ),
    // Thursday
    ClassSlot(
      day: 'Thu',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'DBMS',
      code: 'CSC202',
      faculty: 'Ms Divya Sri',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'Computer Networks',
      code: 'CSC204',
      faculty: 'Prof Lakshmi Narayana',
      room: 'A-203',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'Environmental Studies',
      code: 'AECC201',
      faculty: 'Mrs Swathi Devi',
      room: 'A-101',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '11:45',
      endTime: '12:35',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Thu',
      startTime: '12:35',
      endTime: '13:25',
      subject: 'Discrete Mathematics',
      code: 'CSC205',
      faculty: 'Mrs Swathi Devi',
      room: 'B-110',
    ),
    // Friday
    ClassSlot(
      day: 'Fri',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'Python Programming',
      code: 'SEC201',
      faculty: 'Ms Divya Sri',
      room: 'Lab-1',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'OOP',
      code: 'CSC203',
      faculty: 'Ms Kavitha Rao',
      room: 'Lab-2',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'DBMS',
      code: 'CSC202',
      faculty: 'Ms Divya Sri',
      room: 'A-105',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '11:45',
      endTime: '12:35',
      subject: 'Computer Networks',
      code: 'CSC204',
      faculty: 'Prof Lakshmi Narayana',
      room: 'A-203',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '12:35',
      endTime: '13:25',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Fri',
      startTime: '15:00',
      endTime: '16:00',
      subject: 'Friday Skill — Debate',
      code: 'SKILL',
      faculty: 'Debate Facilitator',
      room: 'Seminar Hall',
    ),
    // Saturday
    ClassSlot(
      day: 'Sat',
      startTime: '09:00',
      endTime: '09:50',
      subject: 'Discrete Mathematics',
      code: 'CSC205',
      faculty: 'Mrs Swathi Devi',
      room: 'B-110',
    ),
    ClassSlot(
      day: 'Sat',
      startTime: '09:50',
      endTime: '10:40',
      subject: 'Data Structures',
      code: 'CSC201',
      faculty: 'Dr Ramesh Kumar',
      room: 'A-201',
    ),
    ClassSlot(
      day: 'Sat',
      startTime: '10:40',
      endTime: '11:30',
      subject: 'OOP',
      code: 'CSC203',
      faculty: 'Ms Kavitha Rao',
      room: 'Lab-2',
    ),
  ];

  static final notices = <Notice>[
    Notice(
      id: 'n1',
      title: 'Holiday — Vinayaka Chavithi',
      body:
          'The college will remain closed on 26 August 2026 for Vinayaka Chavithi. '
          'Regular classes resume the following working day. Hostel mess will '
          'serve festive lunch on 25 August.',
      category: 'Holiday',
      postedAt: DateTime(2026, 8, 26),
      pinned: true,
      issuer: 'Principal’s Office',
    ),
    Notice(
      id: 'n2',
      title: 'I Internal Examinations — 15 to 20 September 2026',
      body:
          'I Internal examinations for all programmes will be held from 15 to 20 '
          'September 2026 (ANU pattern). Seating plans will be posted on the '
          'notice board and under Examinations in CludCampus. Students with '
          'attendance shortage should contact the office for the condonation window.',
      category: 'Exam',
      postedAt: DateTime(2026, 8, 22),
      pinned: true,
      issuer: 'Examination Cell',
    ),
    Notice(
      id: 'n3',
      title: 'Student of the Month — August 2026',
      body:
          'Congratulations to Priya Reddy (B.Sc Computer Science · II Year A) — '
          'Student of the Month for August 2026. Certificates will be issued by '
          'the Principal’s office.',
      category: 'Award',
      postedAt: DateTime(2026, 8, 29),
      issuer: 'College Office',
    ),
    Notice(
      id: 'n4',
      title: 'Inter-collegiate sports selections — 5 September',
      body:
          'Trials for inter-collegiate sports will be held on 5 September 2026 '
          'at the college ground from 7:00 am. Register with the Physical Director.',
      category: 'Event',
      postedAt: DateTime(2026, 8, 21),
      issuer: 'Physical Education',
    ),
    Notice(
      id: 'n5',
      title: 'University examination fee — last date 12 September',
      body:
          'University examination fee of ₹1,450 is due by 12 September 2026. '
          'Pay via Fees in CludCampus or at the college office.',
      category: 'Fee',
      postedAt: DateTime(2026, 8, 20),
      issuer: 'Accounts',
    ),
    Notice(
      id: 'n6',
      title: 'Attendance shortage — condonation window',
      body:
          'Students below 75% attendance may apply for condonation between '
          '12–18 September 2026 at the college office with supporting documents.',
      category: 'Circular',
      postedAt: DateTime(2026, 8, 18),
      issuer: 'College Office',
    ),
    Notice(
      id: 'n7',
      title: 'Staff leave: Ms. Divya Sri — 3–4 September',
      body:
          'Ms. Divya Sri (Computer Science) is on leave on 3–4 September 2026. '
          'DBMS periods will be handled by Ms Kavitha Rao.',
      category: 'Staff-leave',
      postedAt: DateTime(2026, 9, 2),
      issuer: 'HOD · Computer Science',
    ),
  ];

  static final fees = <FeeItem>[
    FeeItem(
      id: 'f1',
      title: 'Tuition',
      amount: 12500,
      dueDate: DateTime(2026, 7, 15),
      status: 'paid',
    ),
    FeeItem(
      id: 'f2',
      title: 'Special fee',
      amount: 2500,
      dueDate: DateTime(2026, 7, 15),
      status: 'paid',
    ),
    FeeItem(
      id: 'f3',
      title: 'Computer lab',
      amount: 1800,
      dueDate: DateTime(2026, 7, 15),
      status: 'paid',
    ),
    FeeItem(
      id: 'f4',
      title: 'University exam',
      amount: examFeeAmount,
      dueDate: DateTime(2026, 9, 30),
      status: 'pending',
    ),
    FeeItem(
      id: 'f5',
      title: 'Library',
      amount: 400,
      dueDate: DateTime(2026, 11, 30),
      status: 'pending',
    ),
  ];

  static final debateTopics = <DebateTopic>[
    DebateTopic(
      id: 't1',
      title: 'AI in classrooms — help or shortcut?',
      description:
          'Should generative AI tools be allowed during coursework and labs?',
      votes: 10,
      capacity: 10,
      closed: true,
    ),
    DebateTopic(
      id: 't2',
      title: 'Campus placements vs higher studies',
      description: 'Is jumping into a job right after graduation better than a master’s?',
      votes: 7,
      capacity: 10,
    ),
    DebateTopic(
      id: 't3',
      title: 'Open source as a career path',
      description:
          'Can contributing to open source replace traditional internships?',
      votes: 4,
      capacity: 10,
    ),
    DebateTopic(
      id: 't4',
      title: 'Attendance mandates in degree colleges',
      description:
          'Should the 75% rule stay, soften, or move to learning outcomes?',
      votes: 9,
      capacity: 10,
    ),
  ];

  static final skills = <SkillSession>[
    SkillSession(
      id: 's1',
      title: fridaySkillTitle,
      trainer: 'Debate Facilitator',
      date: DateTime(2026, 9, 26),
      time: fridaySkillTime,
      venue: 'Seminar Hall',
      tags: const ['Debate', 'Spotlight Hour'],
    ),
  ];

  static final leaves = <LeaveRequest>[
    LeaveRequest(
      id: 'l1',
      from: DateTime(2026, 8, 10),
      to: DateTime(2026, 8, 10),
      reason: 'Sibling’s wedding, Tenali.',
      type: 'Personal',
      status: 'Approved',
      appliedOn: DateTime(2026, 8, 5),
    ),
  ];

  static final awards = <AwardItem>[
    AwardItem(
      id: 'a1',
      title: 'Student of the Month',
      person: 'Priya Reddy',
      description:
          'Recognized for consistent academics, class participation, and '
          'Friday Skill contribution — August 2026.',
      status: 'AWARDED',
      category: 'Student',
    ),
    AwardItem(
      id: 'a2',
      title: 'Best Teacher',
      person: 'Dr Padmavathi',
      description:
          'Awarded for outstanding teaching and mentorship in the sciences.',
      status: 'AWARDED',
      category: 'Faculty',
    ),
    AwardItem(
      id: 'a3',
      title: 'Faculty Recognition',
      person: 'Dr Ramesh Kumar',
      description:
          'Nominated for excellence in Data Structures instruction and labs.',
      status: 'NOMINATED',
      category: 'Faculty',
    ),
    AwardItem(
      id: 'a4',
      title: 'Student of the Month',
      person: 'Sravani K',
      description: 'Nominated for September 2026 — pending committee review.',
      status: 'NOMINATED',
      category: 'Student',
    ),
  ];

  static final gallery = <GalleryItem>[
    GalleryItem(
      id: 'g1',
      title: 'Tenali techie meetup',
      date: DateTime(2026, 8, 14),
      attribution: 'College Office',
      color: 0xFF2878C0,
    ),
    GalleryItem(
      id: 'g2',
      title: 'Independence Day',
      date: DateTime(2026, 8, 15),
      attribution: 'College Office',
      color: 0xFF2F8A62,
    ),
    GalleryItem(
      id: 'g3',
      title: 'College Anniversary',
      date: DateTime(2026, 7, 22),
      attribution: 'College Office',
      color: 0xFF0D2949,
    ),
    GalleryItem(
      id: 'g4',
      title: 'Annual Sports Day',
      date: DateTime(2026, 2, 18),
      attribution: 'College Office',
      color: 0xFFD97706,
    ),
    GalleryItem(
      id: 'g5',
      title: 'Freshers Day',
      date: DateTime(2026, 9, 5),
      attribution: 'College Office',
      color: 0xFF7C3AED,
    ),
  ];

  static final techNews = <TechNewsItem>[
    TechNewsItem(
      id: 'tn1',
      title: 'New AI chips push edge inference on phones',
      summary:
          'On-device models are getting fast enough for real classroom demos '
          'without a cloud round-trip.',
      category: 'AI',
      source: 'Tech Brief',
      date: DateTime(2026, 9, 18),
    ),
    TechNewsItem(
      id: 'tn2',
      title: 'Open-source coding assistants go mainstream',
      summary:
          'Student developers are pairing LLMs with local repos for lab work '
          'and mini projects.',
      category: 'DevTools',
      source: 'Open Source Weekly',
      date: DateTime(2026, 9, 16),
    ),
    TechNewsItem(
      id: 'tn3',
      title: 'India’s space-tech startups hire more CS grads',
      summary:
          'Ground-station software and satellite analytics roles open to '
          'B.Sc / B.Tech computer science cohorts.',
      category: 'Space',
      source: 'Campus Wire',
      date: DateTime(2026, 9, 12),
    ),
    TechNewsItem(
      id: 'tn4',
      title: 'Cybersecurity drills for college labs',
      summary:
          'Red-team style capture-the-flag events help students practise '
          'network defence safely.',
      category: 'Security',
      source: 'InfoSec Today',
      date: DateTime(2026, 9, 9),
    ),
    TechNewsItem(
      id: 'tn5',
      title: 'Battery chemistry breakthroughs for laptops',
      summary:
          'Solid-state prototypes promise longer class-day runtimes — still '
          'a year from consumer shelves.',
      category: 'Hardware',
      source: 'Device Lab',
      date: DateTime(2026, 9, 5),
    ),
  ];

  static final internalExams = <ExamPaper>[
    ExamPaper(
      id: 'e1',
      subject: 'Data Structures',
      code: 'CSC201',
      dateLabel: '15 Sep',
      timeLabel: '10:00–12:00',
    ),
    ExamPaper(
      id: 'e2',
      subject: 'DBMS',
      code: 'CSC202',
      dateLabel: '16 Sep',
      timeLabel: '10:00–12:00',
    ),
    ExamPaper(
      id: 'e3',
      subject: 'OOP',
      code: 'CSC203',
      dateLabel: '17 Sep',
      timeLabel: '10:00–12:00',
    ),
    ExamPaper(
      id: 'e4',
      subject: 'Computer Networks',
      code: 'CSC204',
      dateLabel: '18 Sep',
      timeLabel: '10:00–12:00',
    ),
    ExamPaper(
      id: 'e5',
      subject: 'Discrete Mathematics',
      code: 'CSC205',
      dateLabel: '19 Sep',
      timeLabel: '10:00–12:00',
    ),
    ExamPaper(
      id: 'e6',
      subject: 'Python Programming',
      code: 'SEC201',
      dateLabel: '20 Sep',
      timeLabel: '10:00–12:00',
    ),
  ];

  static const faculty = <FacultyMember>[
    FacultyMember(
      id: 'fac1',
      name: 'Dr Ramesh Kumar',
      designation: 'Assistant Professor',
      subjects: 'Data Structures, Algorithms',
      initials: 'RK',
    ),
    FacultyMember(
      id: 'fac2',
      name: 'Ms Divya Sri',
      designation: 'Assistant Professor',
      subjects: 'DBMS, Python Programming',
      initials: 'DS',
    ),
    FacultyMember(
      id: 'fac3',
      name: 'Ms Kavitha Rao',
      designation: 'Assistant Professor',
      subjects: 'OOP with Java',
      initials: 'KR',
    ),
    FacultyMember(
      id: 'fac4',
      name: 'Mrs Swathi Devi',
      designation: 'Lecturer',
      subjects: 'Discrete Mathematics, Environmental Studies',
      initials: 'SD',
    ),
    FacultyMember(
      id: 'fac5',
      name: 'Prof Lakshmi Narayana',
      designation: 'HOD · Computer Science',
      subjects: 'Computer Networks, Cloud',
      initials: 'LN',
    ),
  ];

  static const courseYears = <CourseYear>[
    CourseYear(
      year: 'I Year',
      papers: [
        'Programming in C',
        'Discrete Mathematics',
        'Digital Logic',
        'CS Lab',
      ],
    ),
    CourseYear(
      year: 'II Year',
      papers: ['Data Structures', 'OOP with Java', 'DBMS', 'Operating Systems'],
    ),
    CourseYear(
      year: 'III Year',
      papers: [
        'Computer Networks',
        'Web Technologies',
        'Cloud Computing',
        'Project',
      ],
    ),
  ];

  /// Campus reminders that are not public holidays. Lectures come from the
  /// timetable. Gazetted holidays live in the India public-holiday list.
  static final academicReminders = <CalendarDayInfo>[
    CalendarDayInfo(
      date: DateTime(2026, 9, 15),
      label: 'Internal exams begin',
      hasReminder: true,
    ),
  ];

  static const feedbackSubjects = <String>[
    'Data Structures',
    'DBMS',
    'OOP',
    'Computer Networks',
    'Discrete Mathematics',
    'Python Programming',
    'Environmental Studies',
  ];

  static String weekdayShort(DateTime d) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[d.weekday - 1];
  }

  static List<ClassSlot> todayClasses([DateTime? now]) {
    // Demo freeze: treat "today" as Mon 21 Sep 2026 when walking Priya demo.
    final ref = now ?? DateTime(2026, 9, 21);
    final day = weekdayShort(ref);
    return timetable.where((c) => c.day == day).toList();
  }

  static String timeGreeting([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static CollegeInfo? collegeByCode(String code) {
    for (final c in colleges) {
      if (c.code == code) return c;
    }
    return null;
  }

  static CollegeInfo get asnCollege => colleges.first;

  /// Last 10 digits of a phone value, ignoring spaces and a +91 prefix.
  static String nationalMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 10) return digits;
    return digits.substring(digits.length - 10);
  }

  /// The enrolled person for this mobile, or null when the college has
  /// no record of the number.
  static DemoRoleProfile? profileForMobile(String mobile) {
    final needle = nationalMobile(mobile);
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(needle)) return null;
    for (final profile in demoRoles) {
      if (nationalMobile(profile.phone) == needle) return profile;
    }
    return null;
  }

  /// Name shown after sign-in. Priya's enrolled record uses her full name.
  static String displayNameFor(DemoRoleProfile profile) {
    if (profile.role == UserRole.student &&
        nationalMobile(profile.phone) == nationalMobile(student.phone)) {
      return student.name;
    }
    return profile.name;
  }

  static DemoRoleProfile? profileForDisplayName(String name) {
    if (name.isEmpty) return null;
    for (final profile in demoRoles) {
      if (profile.name == name || displayNameFor(profile) == name) {
        return profile;
      }
    }
    return null;
  }

  /// Periods taught by this person on the demo day.
  static List<ClassSlot> classesForPerson(String name, [DateTime? now]) {
    final needle = name.trim().toLowerCase();
    if (needle.isEmpty) return const [];
    return todayClasses(now).where((slot) {
      final faculty = slot.faculty.trim().toLowerCase();
      return faculty == needle ||
          needle.contains(faculty) ||
          faculty.contains(needle);
    }).toList();
  }
}
