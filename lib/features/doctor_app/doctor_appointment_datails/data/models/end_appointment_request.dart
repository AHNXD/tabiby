class EndAppointmentRequest {
  final int appointmentId;
  final String note;
  final String? prescriptionNote;
  final List<EndAppointmentPrescriptionItem> prescriptionItems;
  final bool sendToPharmacy;
  final String? labRequestNote;
  final List<int> labTests;
  final List<EndAppointmentRadiologyRequest> radiologyRequests;

  const EndAppointmentRequest({
    required this.appointmentId,
    required this.note,
    this.prescriptionNote,
    this.prescriptionItems = const <EndAppointmentPrescriptionItem>[],
    this.sendToPharmacy = false,
    this.labRequestNote,
    this.labTests = const <int>[],
    this.radiologyRequests = const <EndAppointmentRadiologyRequest>[],
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'appointment_id': appointmentId,
      'note': note.trim(),
      'send_to_pharmacy': sendToPharmacy,
    };

    if (prescriptionNote != null && prescriptionNote!.trim().isNotEmpty) {
      data['prescription_note'] = prescriptionNote!.trim();
    }

    if (prescriptionItems.isNotEmpty) {
      data['prescription_items'] = prescriptionItems
          .map((item) => item.toJson())
          .toList();
    }

    if (labRequestNote != null && labRequestNote!.trim().isNotEmpty) {
      data['lab_request_note'] = labRequestNote!.trim();
    }

    if (labTests.isNotEmpty) {
      data['lab_tests'] = labTests;
    }

    if (radiologyRequests.isNotEmpty) {
      data['radiology_requests'] = radiologyRequests
          .map((item) => item.toJson())
          .toList();
    }

    return data;
  }
}

class EndAppointmentPrescriptionItem {
  final String medicineName;
  final String dose;
  final String frequency;
  final String startDate;
  final String endDate;
  final String instructions;

  const EndAppointmentPrescriptionItem({
    required this.medicineName,
    required this.dose,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.instructions,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'medicine_name': medicineName,
      'dose': dose,
      'frequency': frequency,
      'start_date': startDate,
      'end_date': endDate,
      'instructions': instructions,
    };
  }
}

class EndAppointmentRadiologyRequest {
  final int typeOfMedicalImageId;
  final String? notes;

  const EndAppointmentRadiologyRequest({
    required this.typeOfMedicalImageId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'type_of_medical_image_id': typeOfMedicalImageId,
    };

    if (notes != null && notes!.trim().isNotEmpty) {
      data['notes'] = notes!.trim();
    }

    return data;
  }
}
