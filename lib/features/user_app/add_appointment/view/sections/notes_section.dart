import 'package:flutter/material.dart';

import '../widgets/notes_field.dart';
import '../widgets/section_title.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '3. Add Notes (Optional)'),
        NotesField(),
      ],
    );
  }
}
