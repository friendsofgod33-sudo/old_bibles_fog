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

  static const _categoryLabels = {
    TextCategory.bible: 'Bibles & Scriptures',
    TextCategory.dictionary: 'Dictionaries & Concordances',
    TextCategory.other: 'Devotionals & Early Writings',
  };

  static const _categoryIcons = {
    TextCategory.bible: Icons.menu_book,
    TextCategory.dictionary: Icons.import_contacts,
    TextCategory.other: Icons.auto_stories,
  };

  void _openPicker(BuildContext context) {
    final grouped = <TextCategory, List<OldBibleTranslation>>{};
    for (final t in options) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                label,
                style: ctx.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  for (final category in TextCategory.values)
                    if (grouped.containsKey(category)) ...[
                      _SectionHeader(
                        icon: _categoryIcons[category]!,
                        title: _categoryLabels[category]!,
                      ),
                      for (final t in grouped[category]!)
                        _TranslationTile(
                          translation: t,
                          isSelected: t.id == value.id,
                          onTap: () {
                            Navigator.pop(ctx);
                            onChanged(t);
                          },
                        ),
                    ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          value.displayTitle ?? '${value.name} (${value.year})',
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslationTile extends StatelessWidget {
  const _TranslationTile({
    required this.translation,
    required this.isSelected,
    required this.onTap,
  });
  final OldBibleTranslation translation;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(
        translation.displayTitle ?? translation.name,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        translation.subtitle,
        style: context.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary, size: 20)
          : null,
    );
  }
}

extension _TextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
