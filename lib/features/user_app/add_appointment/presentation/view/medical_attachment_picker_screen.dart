import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';

class MedicalAttachmentPickerScreen extends StatefulWidget {
  const MedicalAttachmentPickerScreen({
    super.key,
    required this.title,
    required this.attachments,
    required this.selectedAttachmentKeys,
  });

  final String title;
  final List<MedicalAttachmentItem> attachments;
  final Set<String> selectedAttachmentKeys;

  @override
  State<MedicalAttachmentPickerScreen> createState() =>
      _MedicalAttachmentPickerScreenState();
}

class _MedicalAttachmentPickerScreenState
    extends State<MedicalAttachmentPickerScreen> {
  late final Set<String> _selectedAttachmentKeys;

  @override
  void initState() {
    super.initState();
    _selectedAttachmentKeys = Set<String>.from(widget.selectedAttachmentKeys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(title: widget.title),
      ),
      body: widget.attachments.isEmpty
          ? const _EmptyAttachmentState()
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.attachments.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final MedicalAttachmentItem attachment =
                          widget.attachments[index];
                      final bool isSelected = _selectedAttachmentKeys.contains(
                        attachment.selectionKey,
                      );
                      return _AttachmentCard(
                        attachment: attachment,
                        isSelected: isSelected,
                        onTap: () => _toggleAttachment(attachment.selectionKey),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColors,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: Text(
                        'apply_selected_records'.tr(context),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _saveSelection() {
    final List<MedicalAttachmentItem> selectedAttachments = widget.attachments
        .where(
          (MedicalAttachmentItem item) =>
              _selectedAttachmentKeys.contains(item.selectionKey),
        )
        .toList();
    Navigator.of(context).pop(selectedAttachments);
  }

  void _toggleAttachment(String selectionKey) {
    setState(() {
      if (_selectedAttachmentKeys.contains(selectionKey)) {
        _selectedAttachmentKeys.remove(selectionKey);
      } else {
        _selectedAttachmentKeys.add(selectionKey);
      }
    });
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
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : AppColors.grey200Color,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.04),
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
                        style: TextStyle(color: AppColors.grey700Color),
                      ),
                    ],
                    if (attachment.sourceLabel != null &&
                        attachment.sourceLabel!.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        attachment.sourceLabel!,
                        style: TextStyle(
                          color: AppColors.grey500Color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (attachment.recordedAt != null &&
                        attachment.recordedAt!.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        attachment.recordedAt!,
                        style: TextStyle(
                          color: AppColors.grey500Color,
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
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : AppColors.grey400Color,
                size: 24,
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

    final bool isRadiology = attachment.type == MedicalAttachmentType.radiology;
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: isRadiology
            ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
            : AppColors.orangeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        isRadiology ? Icons.image_outlined : Icons.description_outlined,
        color: isRadiology
            ? Theme.of(context).primaryColor
            : AppColors.orange700Color,
        size: 34,
      ),
    );
  }
}

class _EmptyAttachmentState extends StatelessWidget {
  const _EmptyAttachmentState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'no_medical_records_available'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.grey600Color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
