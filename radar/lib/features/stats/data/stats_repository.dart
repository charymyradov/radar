import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/stats/statistics.dart';
import '../domain/period_stats.dart';

/// Read-only aggregate queries powering the statistics screen.
class StatsRepository {
  StatsRepository(this._db);

  final AppDatabase _db;

  Future<PeriodStats> load(StatsQuery query) async {
    final where = _whereClause(query);
    final variables = _variables(query);

    final totals = await _db
        .customSelect(
          'SELECT COUNT(*) AS total, '
          'COUNT(speed_kmh) AS measured, '
          'AVG(speed_kmh) AS mean '
          'FROM events WHERE $where',
          variables: variables,
        )
        .getSingle();

    final violationCount = await _db
        .customSelect(
          'SELECT COUNT(*) AS c FROM violations v '
          'JOIN events e ON e.id = v.event_id '
          'WHERE ${_whereClause(query, alias: 'e')}',
          variables: variables,
        )
        .map((row) => row.read<int>('c'))
        .getSingle();

    final speeds = await _db.sortedSpeeds(
      from: query.from,
      to: query.to,
      sessionId: query.sessionId,
    );
    final summary = StatsSummary.fromSpeeds(
      speeds,
      totalCount: totals.read<int>('total'),
    );

    final hourlyRows = await _db
        .customSelect(
          "SELECT strftime('%H', counted_at, 'unixepoch', 'localtime') AS k, "
          'COUNT(*) AS c FROM events WHERE $where GROUP BY k ORDER BY k',
          variables: variables,
        )
        .get();
    final hourlyCounts = <String, int>{
      for (final row in hourlyRows)
        (row.read<String>('k')): row.read<int>('c'),
    };
    final hourly = List<TimeBucket>.generate(24, (hour) {
      final key = hour.toString().padLeft(2, '0');
      return TimeBucket(key: key, count: hourlyCounts[key] ?? 0);
    });

    final dailyRows = await _db
        .customSelect(
          "SELECT strftime('%Y-%m-%d', counted_at, 'unixepoch', 'localtime') "
          'AS k, COUNT(*) AS c FROM events WHERE $where '
          'GROUP BY k ORDER BY k',
          variables: variables,
        )
        .get();
    final daily = dailyRows
        .map((row) => TimeBucket(
              key: row.read<String>('k'),
              count: row.read<int>('c'),
            ))
        .toList();

    final classRows = await _db
        .customSelect(
          'SELECT vehicle_class AS k, COUNT(*) AS c FROM events '
          'WHERE $where GROUP BY k',
          variables: variables,
        )
        .get();
    final classCounts = <VehicleClass, int>{
      for (final row in classRows)
        VehicleClass.fromIndex(row.read<int>('k')): row.read<int>('c'),
    };

    final directionRows = await _db
        .customSelect(
          'SELECT direction AS k, COUNT(*) AS c FROM events '
          'WHERE $where GROUP BY k',
          variables: variables,
        )
        .get();
    final directionCounts = <TravelDirection, int>{
      for (final row in directionRows)
        TravelDirection.fromIndex(row.read<int>('k')): row.read<int>('c'),
    };

    return PeriodStats(
      totalCount: totals.read<int>('total'),
      measuredCount: totals.read<int>('measured'),
      violationCount: violationCount,
      summary: summary,
      hourly: hourly,
      daily: daily,
      classCounts: classCounts,
      directionCounts: directionCounts,
      histogram: buildHistogram(speeds),
    );
  }

  /// Convenience used by the session detail header.
  Future<StatsSummary> summaryForSession(String sessionId) async {
    final stats = await load(StatsQuery(sessionId: sessionId));
    return stats.summary;
  }

  String _whereClause(StatsQuery query, {String alias = ''}) {
    final prefix = alias.isEmpty ? '' : '$alias.';
    final conditions = <String>[
      '${prefix}is_deleted = 0',
      '${prefix}is_valid = 1',
    ];
    if (query.sessionId != null) conditions.add('${prefix}session_id = ?');
    if (query.from != null) conditions.add('${prefix}counted_at >= ?');
    if (query.to != null) conditions.add('${prefix}counted_at < ?');
    return conditions.join(' AND ');
  }

  List<Variable> _variables(StatsQuery query) {
    final vars = <Variable>[];
    if (query.sessionId != null) vars.add(Variable<String>(query.sessionId!));
    if (query.from != null) {
      vars.add(Variable<int>(query.from!.toUtc().millisecondsSinceEpoch ~/ 1000));
    }
    if (query.to != null) {
      vars.add(Variable<int>(query.to!.toUtc().millisecondsSinceEpoch ~/ 1000));
    }
    return vars;
  }
}
