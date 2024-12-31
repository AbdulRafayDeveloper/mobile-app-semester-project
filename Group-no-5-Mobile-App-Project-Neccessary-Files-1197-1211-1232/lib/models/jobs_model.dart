class JobListingModel {
  final int thierStackJobId;
  final String title;
  final String? location;
  final String country;
  final String? salary;
  final int? minAnnualSalary;
  final int? maxAnnualSalary;
  final String? salaryCurrency;
  final String? industry;
  final List<String>? employmentStatuses;
  final String? description;
  final DateTime? jobPostDate;
  final String applyUrl;
  final String companyName;
  final String finalUrl;
  final String sourceUrl;
  final String? stateCode;
  final bool remote;
  final bool hybrid;
  final String? seniority;
  final String? companyLogoLink;
  final String? companyUrl;
  final int? numberOfJobs;
  final int? foundedYear;
  final DateTime createdAt;

  JobListingModel({
    required this.thierStackJobId,
    required this.title,
    this.location,
    required this.country,
    this.salary,
    this.minAnnualSalary,
    this.maxAnnualSalary,
    this.salaryCurrency,
    this.industry,
    this.employmentStatuses,
    this.description,
    this.jobPostDate,
    required this.applyUrl,
    required this.companyName,
    required this.finalUrl,
    required this.sourceUrl,
    this.stateCode,
    this.remote = false,
    this.hybrid = false,
    this.seniority,
    this.companyLogoLink,
    this.companyUrl,
    this.numberOfJobs,
    this.foundedYear,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'thierStackJobId': thierStackJobId,
      'title': title,
      'location': location ?? '',
      'country': country,
      'salary': salary ?? '',
      'minAnnualSalary': minAnnualSalary ?? 0,
      'maxAnnualSalary': maxAnnualSalary ?? 0,
      'salaryCurrency': salaryCurrency ?? '',
      'industry': industry ?? '',
      'employmentStatuses': employmentStatuses ?? [],
      'description': description ?? '',
      'jobPostDate': jobPostDate?.toIso8601String(),
      'applyUrl': applyUrl,
      'companyName': companyName,
      'finalUrl': finalUrl,
      'sourceUrl': sourceUrl,
      'stateCode': stateCode ?? '',
      'remote': remote,
      'hybrid': hybrid,
      'seniority': seniority ?? '',
      'companyLogoLink': companyLogoLink ?? '',
      'companyUrl': companyUrl ?? '',
      'numberOfJobs': numberOfJobs ?? 0,
      'foundedYear': foundedYear ?? 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JobListingModel.fromMap(Map<String, dynamic> map) {
    return JobListingModel(
      thierStackJobId: map['thierStackJobId'] ?? 0,
      title: map['title'] ?? '',
      location: map['location'],
      country: map['country'] ?? '',
      salary: map['salary'],
      minAnnualSalary: map['minAnnualSalary'],
      maxAnnualSalary: map['maxAnnualSalary'],
      salaryCurrency: map['salaryCurrency'],
      industry: map['industry'],
      employmentStatuses: List<String>.from(map['employmentStatuses'] ?? []),
      description: map['description'],
      jobPostDate: map['jobPostDate'] != null
          ? DateTime.parse(map['jobPostDate'])
          : null,
      applyUrl: map['applyUrl'] ?? '',
      companyName: map['companyName'] ?? '',
      finalUrl: map['finalUrl'] ?? '',
      sourceUrl: map['sourceUrl'] ?? '',
      stateCode: map['stateCode'],
      remote: map['remote'] ?? false,
      hybrid: map['hybrid'] ?? false,
      seniority: map['seniority'],
      companyLogoLink: map['companyLogoLink'],
      companyUrl: map['companyUrl'],
      numberOfJobs: map['numberOfJobs'],
      foundedYear: map['foundedYear'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
