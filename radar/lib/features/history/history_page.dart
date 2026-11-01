import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../core/ui_labels.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/enums.dart';
import '../../l10n/generated/app_localizations.dart';
import 'domain/session_summary.dart';
import 'domain/vehicle_event.dart';

final _sessionsProvider = FutureProvider<List<SessionSummary>>((ref) {
  return ref.read(sessionRepositoryProvider).list();
});

final _sessionProvider =
    FutureProvider.family<SessionSummary?, String>((ref, id) {
  return ref.read(sessionRepositoryProvider).byId(id);
});

final _sessionEventsProvider =
    FutureProvider.family<List<VehicleEvent>, String>((ref, id) {
  return ref.read(eventRepositoryProvider).query(
        EventFilter(
          sessionId: id,
          includeInvalid: true,
          includeDeleted: true,
        ),
        limit: 500,
      );
});

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(_sessionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(_sessionsProvider),
        ),
        data: (items) {
          if (items.isEmpty) return Center(child: Text(l10n.historyNoSessions));
          return RefreshIndicator(
            onRefresh: () => ref.refresh(_sessionsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _SessionCard(
                session: items[index],
                onOpen: () => context.push('/history/${items[index].id}'),
                onDelete: () => _deleteSession(context, ref, items[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SessionDetailPage extends ConsumerWidget {
  const SessionDetailPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(_sessionProvider(sessionId));
    final events = ref.watch(_sessionEventsProvider(sessionId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historySession)),
      body: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(_sessionProvider(sessionId)),
        ),
        data: (item) {
          if (item == null) return Center(child: Text(l10n.commonUnknown));
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(_sessionProvider(sessionId));
              ref.invalidate(_sessionEventsProvider(sessionId));
              await ref.read(_sessionProvider(sessionId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SessionSummaryCard(session: item),
                const SizedBox(height: 18),
                Text(
                  l10n.historyEvents,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                events.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Text('${l10n.commonError}: $error'),
                  data: (rows) => rows.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(l10n.historyNoEvents),
                        )
                      : Card(
                          child: Column(
                            children: [
                              for (var index = 0; index < rows.length; index++)
                                _EventTile(
                                  event: rows[index],
                                  divider: index < rows.length - 1,
                                  onRefresh: () => ref.invalidate(
                                    _sessionEventsProvider(sessionId),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.onOpen,
    required this.onDelete,
  });

  final SessionSummary session;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              const Icon(Icons.route_rounded, color: AppTheme.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().add_Hm().format(
                            session.startedAt.toLocal(),
                          ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.totalCount} ${l10n.historyCount} · '
                      '${session.measuredCount} ${l10n.historyMeasured} · '
                      '${_duration(session.durationAt(DateTime.now()))}',
                    ),
                    if (session.isRunning)
                      Text(
                        l10n.liveSessionRunning,
                        style: const TextStyle(color: AppTheme.accent),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.commonDelete,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionSummaryCard extends StatelessWidget {
  const _SessionSummaryCard({required this.session});

  final SessionSummary session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd(locale).add_Hm().format(
                    session.startedAt.toLocal(),
                  ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _SummaryValue(
                  label: l10n.historyDuration,
                  value: _duration(session.durationAt(DateTime.now())),
                ),
                _SummaryValue(
                  label: l10n.historyEvents,
                  value: '${session.totalCount}',
                ),
                _SummaryValue(
                  label: l10n.historyMeasured,
                  value: '${session.measuredCount}',
                ),
                _SummaryValue(
                  label: l10n.violationsTitle,
                  value: '${session.violationCount}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
}

class _EventTile extends ConsumerWidget {
  const _EventTile({
    required this.event,
    required this.divider,
    required this.onRefresh,
  });

  final VehicleEvent event;
  final bool divider;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).value;
    final speed = event.speedKmh == null || settings == null
        ? l10n.historySpeedUnknown
        : '${settings.unit.format(event.speedKmh!, decimals: 0)} ${settings.unit.label}';
    final excluded = event.excludedFromStats;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: excluded
                ? AppTheme.surfaceHigh
                : AppTheme.accent.withValues(alpha: 0.15),
            child: Icon(
              _classIcon(event.vehicleClass),
              color: excluded ? null : AppTheme.accent,
            ),
          ),
          title: Text(
            '${vehicleClassLabel(l10n, event.vehicleClass)} · $speed',
            style: TextStyle(
              color: event.isDeleted
                  ? Theme.of(context).disabledColor
                  : event.speedKmh != null &&
                          settings != null &&
                          event.speedKmh! > settings.speedLimitKmh
                      ? AppTheme.danger
                      : null,
            ),
          ),
          subtitle: Text(
            '${DateFormat.Hm().format(event.countedAt.toLocal())} · '
            '${travelDirectionLabel(l10n, event.direction)} · '
            '${l10n.historyConfidence} ${(event.confidence * 100).round()}%'
            '${excluded ? ' · ${l10n.historyInvalidBadge}' : ''}',
          ),
          trailing: PopupMenuButton<String>(
            tooltip: l10n.historyEdit,
            onSelected: (value) async {
              final repo = ref.read(eventRepositoryProvider);
              if (value == 'valid') {
                await repo.setValid(event.id, !event.isValid);
              } else if (value == 'delete') {
                await repo.softDelete(event.id);
              } else if (value == 'restore') {
                await repo.restore(event.id);
                await repo.setValid(event.id, true);
              } else if (value.startsWith('class:')) {
                final index = int.parse(value.substring(6));
                await repo.setClass(event.id, VehicleClass.values[index]);
              }
              onRefresh();
            },
            itemBuilder: (context) => [
              if (!event.isDeleted)
                PopupMenuItem(
                  value: 'valid',
                  child: Text(event.isValid
                      ? l10n.historyMarkInvalid
                      : l10n.historyMarkValid),
                ),
              for (final vehicleClass in VehicleClass.values)
                PopupMenuItem(
                  value: 'class:${vehicleClass.index}',
                  child: Text(
                    '${l10n.historyChangeClass}: ${vehicleClassLabel(l10n, vehicleClass)}',
                  ),
                ),
              if (event.isDeleted)
                PopupMenuItem(
                  value: 'restore',
                  child: Text(l10n.historyMarkValid),
                )
              else
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.commonDelete),
                ),
            ],
          ),
          isThreeLine: true,
        ),
        if (divider) const Divider(height: 1, indent: 72),
      ],
    );
  }

  IconData _classIcon(VehicleClass vehicleClass) => switch (vehicleClass) {
        VehicleClass.car => Icons.directions_car_rounded,
        VehicleClass.motorcycle => Icons.two_wheeler_rounded,
        VehicleClass.bus => Icons.directions_bus_rounded,
        VehicleClass.truck => Icons.local_shipping_rounded,
      };
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.commonError}: $error', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

String _duration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m ${seconds}s';
}

Future<void> _deleteSession(
  BuildContext context,
  WidgetRef ref,
  SessionSummary session,
) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.historyDeleteTitle),
      content: Text(l10n.historyDeleteBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.commonDelete),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await ref.read(violationRepositoryProvider).deleteImagesForSession(
          session.id,
        );
    await ref.read(sessionRepositoryProvider).delete(session.id);
    ref.invalidate(_sessionsProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.historyDeleted)));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.commonError}: $error')),
      );
    }
  }
}
