import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

enum BodySide { front, back }

class BodyPartDescriptor {
  const BodyPartDescriptor({
    required this.id,
    required this.backendValue,
    required this.labelKey,
    required this.icon,
    required this.side,
  });

  final String id;
  final String backendValue;
  final String labelKey;
  final IconData icon;
  final BodySide side;
}

const List<BodyPartDescriptor> bodyPartCatalog = [
  BodyPartDescriptor(
    id: 'head',
    backendValue: 'Head',
    labelKey: 'diagnose_part_head',
    icon: Icons.face_rounded,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'neck',
    backendValue: 'Neck',
    labelKey: 'diagnose_part_neck',
    icon: Icons.accessibility_new,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'leftChest',
    backendValue: 'Left Chest',
    labelKey: 'diagnose_part_left_chest',
    icon: Icons.favorite_border,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'chest',
    backendValue: 'Chest',
    labelKey: 'diagnose_part_chest',
    icon: Icons.monitor_heart_outlined,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'abdomen',
    backendValue: 'Abdomen',
    labelKey: 'diagnose_part_abdomen',
    icon: Icons.airline_seat_flat,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'leftArm',
    backendValue: 'Left Arm',
    labelKey: 'diagnose_part_left_arm',
    icon: Icons.pan_tool_alt_outlined,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'rightArm',
    backendValue: 'Right Arm',
    labelKey: 'diagnose_part_right_arm',
    icon: Icons.pan_tool_alt_outlined,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'leftLeg',
    backendValue: 'Left Leg',
    labelKey: 'diagnose_part_left_leg',
    icon: Icons.directions_walk,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'rightLeg',
    backendValue: 'Right Leg',
    labelKey: 'diagnose_part_right_leg',
    icon: Icons.directions_walk,
    side: BodySide.front,
  ),
  BodyPartDescriptor(
    id: 'lowerBack',
    backendValue: 'Lower Back',
    labelKey: 'diagnose_part_lower_back',
    icon: Icons.airline_seat_recline_normal,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'upperBack',
    backendValue: 'Upper Back',
    labelKey: 'diagnose_part_upper_back',
    icon: Icons.airline_seat_recline_extra,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'leftShoulderBack',
    backendValue: 'Left Shoulder',
    labelKey: 'diagnose_part_left_shoulder_back',
    icon: Icons.accessibility,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'rightShoulderBack',
    backendValue: 'Right Shoulder',
    labelKey: 'diagnose_part_right_shoulder_back',
    icon: Icons.accessibility,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'leftHip',
    backendValue: 'Left Hip',
    labelKey: 'diagnose_part_left_hip',
    icon: Icons.accessibility_new,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'rightHip',
    backendValue: 'Right Hip',
    labelKey: 'diagnose_part_right_hip',
    icon: Icons.accessibility_new,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'leftCalf',
    backendValue: 'Left Calf',
    labelKey: 'diagnose_part_left_calf',
    icon: Icons.directions_walk,
    side: BodySide.back,
  ),
  BodyPartDescriptor(
    id: 'rightCalf',
    backendValue: 'Right Calf',
    labelKey: 'diagnose_part_right_calf',
    icon: Icons.directions_walk,
    side: BodySide.back,
  ),
];

BodyPartDescriptor? findBodyPartById(String? id) {
  if (id == null || id.trim().isEmpty) {
    return null;
  }

  for (final item in bodyPartCatalog) {
    if (item.id == id) {
      return item;
    }
  }

  return null;
}

String localizedBodyPartLabel(
  BuildContext context, {
  String? partKey,
  String? fallbackLabel,
}) {
  final descriptor = findBodyPartById(partKey);
  if (descriptor != null) {
    return descriptor.labelKey.tr(context);
  }

  return fallbackLabel ?? '';
}
