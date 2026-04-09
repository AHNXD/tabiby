import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Image_diagnosis/data/models/diagnosis_model.dart';
import '../../data/repos/radiology_repo.dart';

class RadiologyViewModel extends ChangeNotifier {
  File? _selectedImage;
  bool _isLoading = false;
  DiagnosisModel? _result;
  String? _errorMessage;
  String? _aiAnalysisText;

  final RadiologyRepo _repo = RadiologyRepo();
  final ImagePicker _picker = ImagePicker();

  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  DiagnosisModel? get result => _result;
  String? get errorMessage => _errorMessage;
  String? get aiAnalysisText => _aiAnalysisText;
  List<MapEntry<String, double>> get optimizedResults =>
      _result?.sortedFindings ?? const <MapEntry<String, double>>[];

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) {
      return;
    }

    _selectedImage = File(image.path);
    _result = null;
    _errorMessage = null;
    _aiAnalysisText = null;
    notifyListeners();
  }

  Future<void> analyzeImage() async {
    if (_selectedImage == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _aiAnalysisText = null;
    notifyListeners();

    try {
      _result = await _repo.analyzeXRay(_selectedImage!);
      _aiAnalysisText = _result?.aiDiagnosis;
    } catch (e) {
      _errorMessage = e.toString();
      log('Error during analysis: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    _result = null;
    _errorMessage = null;
    _aiAnalysisText = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
