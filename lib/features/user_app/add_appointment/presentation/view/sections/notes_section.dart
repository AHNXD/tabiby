import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../widgets/notes_field.dart';
import '../widgets/section_title.dart';

class NotesSection extends StatelessWidget {
  final TextEditingController noteController;
  const NotesSection({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '3. ${"add_notes".tr(context)}'),
        NotesField(noteController: noteController),
      ],
    );
  }
}
