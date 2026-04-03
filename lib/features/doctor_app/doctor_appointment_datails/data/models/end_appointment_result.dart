class EndAppointmentResult {
  final String message;
  final int? appointmentId;
  final String? appointmentStatus;
  final String? doctorNote;
  final bool? sendToPharmacy;

  const EndAppointmentResult({
    required this.message,
    this.appointmentId,
    this.appointmentStatus,
    this.doctorNote,
    this.sendToPharmacy,
  });

  factory EndAppointmentResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return EndAppointmentResult(
      message:
          json['message']?.toString() ?? 'Appointment completed successfully',
      appointmentId: _asNullableInt(data['appointment_id']),
      appointmentStatus: data['appointment_status']?.toString(),
      doctorNote: data['doctor_note']?.toString(),
      sendToPharmacy: _asNullableBool(data['send_to_pharmacy']),
    );
  }
}

int? _asNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

bool? _asNullableBool(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is bool) {
    return value;
  }

  final String normalized = value.toString().trim().toLowerCase();
  if (normalized == '1' || normalized == 'true') {
    return true;
  }
  if (normalized == '0' || normalized == 'false') {
    return false;
  }

  return null;
}
