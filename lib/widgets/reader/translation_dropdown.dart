import 'package:flutter/material.dart';

import '../../data/old_bibles_data.dart';

class TranslationDropdown extends StatelessWidget {
  const TranslationDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final OldBibleTranslation value;
  final List<OldBibleTranslation> options;
  final ValueChanged<OldBibleTranslation> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<OldBibleTranslation>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options
          .map(
            (translation) => DropdownMenuItem<OldBibleTranslation>(
              value: translation,
              child: Text(
                translation.displayTitle ??
                    '${translation.name} (${translation.year})',
              ),
            ),
          )
          .toList(),
      onChanged: (translation) {
        if (translation != null) {
          onChanged(translation);
        }
      },
    );
  }
}
