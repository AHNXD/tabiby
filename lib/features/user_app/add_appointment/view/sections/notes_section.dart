import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../widgets/notes_field.dart';
import '../widgets/section_title.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '3. ${"add_notes".tr(context)}'),
        NotesField(),
      ],
    );
  }
}
