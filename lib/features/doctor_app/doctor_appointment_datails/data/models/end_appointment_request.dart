import 'package:tabiby/core/models/prescription_item.dart';

class EndAppointmentRequest {
  final int appointmentId;
  final String note;
  final List<PrescriptionItem> prescriptionList;

  const EndAppointmentRequest({
    required this.appointmentId,
    required this.note,
    required this.prescriptionList,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appointment_id': appointmentId,
      'note': note,
      'prescription_list': prescriptionList
          .map((item) => item.toJson())
          .toList(),
    };
  }
}
