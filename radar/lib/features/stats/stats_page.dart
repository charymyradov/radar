import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui_labels.dart';
import '../../domain/models/enums.dart';
import '../../l10n/generated/app_localizations.dart';
import 'domain/period_stats.dart';

enum _StatsPeriod { today, week, month, all }

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  _StatsPeriod _period = _StatsPeriod.today;
  Future<PeriodStats>? _statsFuture;

  StatsQuery _query() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (_period) {
      _StatsPeriod.today => StatsQuery(
          from: today,
          to: today.add(const Duration(days: 1)),
          label: 'today',
        ),
      _StatsPeriod.week => StatsQuery(
          from: today.subtract(const Duration(days: 6)),
          to: today.add(const Duration(days: 1)),
          label: '7days',
        ),
      _StatsPeriod.month => StatsQuery(
          from: today.subtract(const Duration(days: 29)),
          to: today.add(const Duration(days: 1)),
          label: '30days',
        ),
      _StatsPeriod.all => const StatsQuery(label: 'all'),
    };
  }

  Future<PeriodStats> _loadStats() =>
      ref.read(statsRepositoryProvider).load(_query());

  void _selectPeriod(_StatsPeriod value) {
    setState(() {
      _period = value;
      _statsFuture = _loadStats();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statsFuture ??= _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _statsFuture = _loadStats());
          await _statsFuture;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _periodChip(l10n.statsPeriodToday, _StatsPeriod.today),
                  _periodChip(l10n.statsPeriod7, _StatsPeriod.week),
                  _periodChip(l10n.statsPeriod30, _StatsPeriod.month),
                  _periodChip(l10n.statsPeriodAll, _StatsPeriod.all),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<PeriodStats>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return _ErrorCard(
                    error: snapshot.error!,
                    onRetry: () =>
                        setState(() => _statsFuture = _loadStats()),
                  );
                }
                final stats = snapshot.data ?? PeriodStats.empty;
                if (stats.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 72),
                    child: Center(child: Text(l10n.statsNoData)),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricsGrid(
                      stats: stats,
                      unit: settings?.unit ?? SpeedUnit.kmh,
                    ),
                    const SizedBox(height: 18),
                    _ChartCard(
                      title: _period == _StatsPeriod.today
                          ? l10n.statsHourly
                          : l10n.statsDaily,
                      buckets: _period == _StatsPeriod.today
                          ? stats.hourly
                          : stats.daily,
                      isHourly: _period == _StatsPeriod.today,
                    ),
                    const SizedBox(height: 12),
                    _ChartCard(
                      title: l10n.statsHistogram,
                      buckets: [
                        for (final bucket in stats.histogram)
                          TimeBucket(
                            key: bucket.label,
                            count: bucket.count,
                          ),
                      ],
                      rotateLabels: true,
                    ),
                    const SizedBox(height: 12),
                    _BreakdownCard(
                      title: l10n.statsClasses,
                      values: {
                        for (final entry in stats.classCounts.entries)
                          vehicleClassLabel(l10n, entry.key): entry.value,
                      },
                    ),
                    const SizedBox(height: 12),
                    _BreakdownCard(
                      title: l10n.statsDirections,
                      values: {
                        for (final entry in stats.directionCounts.entries)
                          travelDirectionLabel(l10n, entry.key): entry.value,
                      },
                    ),
                    if (stats.busiestHour != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.schedule_rounded,
                            color: AppTheme.accent,
                          ),
                          title: Text(l10n.statsBusiest),
                          trailing: Text(
                            '${stats.busiestHour!.key}:00 · ${stats.busiestHour!.count}',
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodChip(String label, _StatsPeriod period) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: _period == period,
          onSelected: (_) => _selectPeriod(period),
        ),
      );
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.stats, required this.unit});

  final PeriodStats stats;
  final SpeedUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final values = [
      (l10n.statsTotal, '${stats.totalCount}'),
      (l10n.statsMeasured, '${stats.measuredCount}'),
      (l10n.statsMean, _speed(stats.meanSpeed)),
      (l10n.statsMedian, _speed(stats.summary.p50)),
      (l10n.statsP85, _speed(stats.p85)),
      (l10n.statsMax, _speed(stats.maxSpeed)),
      (l10n.statsMin, _speed(stats.minSpeed)),
      (l10n.violationsTitle, '${stats.violationCount}'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                values[index].$1,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                values[index].$1 == l10n.statsTotal ||
                        values[index].$1 == l10n.statsMeasured ||
                        values[index].$1 == l10n.violationsTitle
                    ? values[index].$2
                    : '${values[index].$2} ${unit.label}',
                style: AppTheme.numeric(
                  Theme.of(context).textTheme.titleLarge,
                  size: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _speed(double? value) =>
      value == null ? '—' : unit.fromKmh(value).toStringAsFixed(1);
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.buckets,
    this.isHourly = false,
    this.rotateLabels = false,
  });

  final String title;
  final List<TimeBucket> buckets;
  final bool isHourly;
  final bool rotateLabels;

  @override
  Widget build(BuildContext context) {
    final shown = isHourly
        ? buckets
            .asMap()
            .entries
            .where((entry) => entry.key % 3 == 0)
            .map((entry) => (entry.key, entry.value))
            .toList()
        : buckets.asMap().entries.map((entry) => (entry.key, entry.value)).toList();
    final maxValue = buckets.fold<int>(
      0,
      (max, bucket) => bucket.count > max ? bucket.count : max,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: rotateLabels ? 190 : 170,
              child: BarChart(
                BarChartData(
                  maxY: (maxValue + 1).toDouble(),
                  barGroups: [
                    for (var index = 0; index < buckets.length; index++)
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: buckets[index].count.toDouble(),
                            color: AppTheme.accent,
                            width: rotateLabels ? 10 : 9,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: maxValue < 4 ? 1 : (maxValue / 3).ceilToDouble(),
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: rotateLabels ? 44 : 26,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= buckets.length) {
                            return const SizedBox.shrink();
                          }
                          final shouldShow = shown.any(
                            (entry) => entry.$1 == index,
                          );
                          if (!shouldShow) return const SizedBox.shrink();
                          final label = buckets[index].key;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              rotateLabels && label.length > 5
                                  ? label.substring(5)
                                  : label,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.title, required this.values});

  final String title;
  final Map<String, int> values;

  @override
  Widget build(BuildContext context) {
    final total = values.values.fold<int>(0, (sum, value) => sum + value);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final entry in values.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
                    SizedBox(
                      width: 110,
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : entry.value / total,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 28,
                      child: Text('${entry.value}', textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text('${l10n.commonError}: $error'),
        trailing: IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ),
    );
  }
}
