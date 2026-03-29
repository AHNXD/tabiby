import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';

class MedicalAttachmentPickerScreen extends StatelessWidget {
  const MedicalAttachmentPickerScreen({
    super.key,
    required this.title,
    required this.attachments,
    required this.type,
    this.selectedAttachmentId,
  });

  final String title;
  final List<MedicalAttachmentItem> attachments;
  final MedicalAttachmentType type;
  final int? selectedAttachmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(title: title),
      ),
      body: attachments.isEmpty
          ? _EmptyAttachmentState(type: type)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: attachments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final MedicalAttachmentItem attachment = attachments[index];
                final bool isSelected = attachment.id == selectedAttachmentId;
                return _AttachmentCard(
                  attachment: attachment,
                  isSelected: isSelected,
                  onTap: () => Navigator.pop(context, attachment),
                );
              },
            ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.attachment,
    required this.isSelected,
    required this.onTap,
  });

  final MedicalAttachmentItem attachment;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              _AttachmentPreview(attachment: attachment),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      attachment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (attachment.subtitle != null &&
                        attachment.subtitle!.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        attachment.subtitle!.tr(context),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                    if (attachment.recordedAt != null &&
                        attachment.recordedAt!.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        attachment.recordedAt!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
                size: isSelected ? 26 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.attachment});

  final MedicalAttachmentItem attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.thumbnailUrl != null &&
        attachment.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CustomImageWidget(
          imageUrl: attachment.thumbnailUrl,
          placeholderAsset: AssetsData.defaultCenter,
          height: 72,
          width: 72,
        ),
      );
    }

    final bool isXray = attachment.type == MedicalAttachmentType.xray;
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: isXray
            ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
            : Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        isXray ? Icons.image_outlined : Icons.description_outlined,
        color: isXray ? Theme.of(context).primaryColor : Colors.orange.shade700,
        size: 34,
      ),
    );
  }
}

class _EmptyAttachmentState extends StatelessWidget {
  const _EmptyAttachmentState({required this.type});

  final MedicalAttachmentType type;

  @override
  Widget build(BuildContext context) {
    final String message = type == MedicalAttachmentType.xray
        ? 'no_xray_records_available'.tr(context)
        : 'no_lab_results_available'.tr(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
