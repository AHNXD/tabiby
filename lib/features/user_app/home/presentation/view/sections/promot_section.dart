import 'package:flutter/material.dart';
import '../../../data/models/promot_model.dart';
import '../widgets/promot_card.dart';

class PromotSection extends StatelessWidget {
  const PromotSection({super.key, required this.promot});
  final Promot promot;

  @override
  Widget build(BuildContext context) {
    return PromotCard(promot: promot);
  }
}
