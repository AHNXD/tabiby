import 'package:flutter/material.dart';
import '../widgets/clinic_header.dart';

class HeaderSection extends StatelessWidget {
  final String name;
  final String address;
  final String imageUrl;

  const HeaderSection({
    super.key,
    required this.name,
    required this.address,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(name: name, address: address, imageUrl: imageUrl);
  }
}
