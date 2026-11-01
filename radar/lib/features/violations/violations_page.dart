import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui_labels.dart';
import '../../domain/models/enums.dart';
import '../../l10n/generated/app_localizations.dart';
import 'domain/violation_item.dart';

final _violationsProvider =
    FutureProvider.family<List<ViolationItem>, int>((ref, statusIndex) {
  return ref.read(violationRepositoryProvider).list(
        status: statusIndex < 0 ? null : ViolationStatus.values[statusIndex],
      );
});

class ViolationsPage extends ConsumerStatefulWidget {
  const ViolationsPage({super.key});

  @override
  ConsumerState<ViolationsPage> createState() => _ViolationsPageState();
}

class _ViolationsPageState extends ConsumerState<ViolationsPage> {
  int _statusFilter = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final violations = ref.watch(_violationsProvider(_statusFilter));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.violationsTitle)),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _filterChip(l10n.commonAll, -1),
                for (final status in ViolationStatus.values)
                  _filterChip(violationStatusLabel(l10n, status), status.index),
              ],
            ),
          ),
          Expanded(
            child: violations.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _ErrorRetry(
                error: error,
                onRetry: () =>
                    ref.invalidate(_violationsProvider(_statusFilter)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(child: Text(l10n.violationsEmpty));
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(
                    _violationsProvider(_statusFilter).future,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _ViolationCard(
                      item: items[index],
                      onChanged: () => ref.invalidate(
                        _violationsProvider(_statusFilter),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int value) => Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ChoiceChip(
          label: Text(label),
          selected: _statusFilter == value,
          onSelected: (_) => setState(() => _statusFilter = value),
        ),
      );
}

class _ViolationCard extends ConsumerWidget {
  const _ViolationCard({required this.item, required this.onChanged});

  final ViolationItem item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).value;
    final unit = settings?.unit ?? SpeedUnit.kmh;
    final speed = item.speedKmh == null
        ? l10n.historySpeedUnknown
        : '${unit.format(item.speedKmh!, decimals: 0)} ${unit.label}';
    final limit = '${unit.format(item.limitKmh, decimals: 0)} ${unit.label}';
    final over = '${unit.fromKmh(item.overBy).toStringAsFixed(0)} ${unit.label}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imagePath != null)
            GestureDetector(
              onTap: () => _showImage(context, item.imagePath!),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: Image.file(
                  File(item.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _NoImage(
                    label: l10n.violationsNoImage,
                  ),
                ),
              ),
            )
          else
            _NoImage(label: l10n.violationsNoImage),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$speed · ${vehicleClassLabel(l10n, item.vehicleClass)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.danger,
                            ),
                      ),
                    ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        violationStatusLabel(l10n, item.status),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.violationsLimit}: $limit  ·  '
                  '${l10n.violationsOver}: $over',
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().add_Hm().format(item.countedAt.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    if (item.status != ViolationStatus.reviewed)
                      OutlinedButton.icon(
                        onPressed: () => _setStatus(
                          context,
                          ref,
                          ViolationStatus.reviewed,
                        ),
                        icon: const Icon(Icons.done_rounded),
                        label: Text(l10n.violationsMarkReviewed),
                      ),
                    if (item.status != ViolationStatus.ignored)
                      TextButton.icon(
                        onPressed: () => _setStatus(
                          context,
                          ref,
                          ViolationStatus.ignored,
                        ),
                        icon: const Icon(Icons.visibility_off_outlined),
                        label: Text(l10n.violationsMarkIgnored),
                      ),
                    if (item.imagePath != null)
                      IconButton(
                        tooltip: l10n.commonDelete,
                        onPressed: () => _removeImage(context, ref),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setStatus(
    BuildContext context,
    WidgetRef ref,
    ViolationStatus status,
  ) async {
    try {
      await ref.read(violationRepositoryProvider).setStatus(item.id, status);
      onChanged();
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  Future<void> _removeImage(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(violationRepositoryProvider).deleteImage(item.id);
      onChanged();
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  void _showError(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context).commonError}: $error'),
      ),
    );
  }

  void _showImage(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.file(
            File(path),
            errorBuilder: (_, _, _) =>
                _NoImage(label: AppLocalizations.of(context).violationsNoImage),
          ),
        ),
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        height: 96,
        width: double.infinity,
        color: AppTheme.surfaceHigh,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_not_supported_outlined),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      );
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.commonError}: $error'),
          TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
