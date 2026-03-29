class PrescriptionItem {
  final String drugName;
  final String dosage;
  final String startDate;
  final String endDate;
  final String frequencyPerDay;
  final String specialNotes;

  const PrescriptionItem({
    required this.drugName,
    required this.dosage,
    required this.startDate,
    required this.endDate,
    required this.frequencyPerDay,
    required this.specialNotes,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      drugName:
          json['drug_name']?.toString() ??
          json['name']?.toString() ??
          json['drug']?.toString() ??
          '',
      dosage:
          json['dosage']?.toString() ??
          json['dose']?.toString() ??
          json['amount']?.toString() ??
          '',
      startDate:
          json['start_date']?.toString() ?? json['from']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? json['to']?.toString() ?? '',
      frequencyPerDay:
          json['frequency_per_day']?.toString() ??
          json['frequency']?.toString() ??
          '',
      specialNotes:
          json['special_notes']?.toString() ?? json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'drug_name': drugName,
      'dosage': dosage,
      'start_date': startDate,
      'end_date': endDate,
      'frequency_per_day': frequencyPerDay,
      'special_notes': specialNotes,
    };
  }
}
