import 'dart:convert';

import '../../domain/models/market.dart';

/// One problem found while importing.
class ImportIssue {
  const ImportIssue(this.line, this.reason);

  final int line;
  final String reason;

  @override
  String toString() => 'line $line: $reason';
}

/// The result of importing a CSV file.
class ImportResult {
  const ImportResult({
    required this.candles,
    required this.issues,
    required this.totalRows,
  });

  final List<Candle> candles;
  final List<ImportIssue> issues;
  final int totalRows;

  bool get isEmpty => candles.isEmpty;
  int get skipped => totalRows - candles.length;
}

/// Reads OHLCV data from CSV.
///
/// This is the import layer the simulator is built behind: the scenario engine
/// consumes [Candle] lists and never cares where they came from, so dropping in
/// verified historical data later requires no change to any simulator logic.
///
/// The parser is deliberately forgiving about column order and naming, and
/// deliberately strict about the data itself — a row that would produce an
/// impossible candle is reported and skipped rather than silently drawn.
class OhlcvCsvImporter {
  const OhlcvCsvImporter._();

  static const List<String> _timeNames = [
    'timestamp',
    'time',
    'date',
    'datetime',
    'open_time',
    'opentime',
    'ts',
  ];
  static const List<String> _openNames = ['open', 'o'];
  static const List<String> _highNames = ['high', 'h'];
  static const List<String> _lowNames = ['low', 'l'];
  static const List<String> _closeNames = ['close', 'c', 'last'];
  static const List<String> _volumeNames = ['volume', 'vol', 'v', 'basevolume'];

  /// Parses [content]. A header row is detected automatically; without one the
  /// columns are assumed to be time, open, high, low, close, volume.
  static ImportResult parse(String content) {
    final lines = const LineSplitter()
        .convert(content)
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      return const ImportResult(candles: [], issues: [], totalRows: 0);
    }

    final issues = <ImportIssue>[];
    var startLine = 0;
    var timeIndex = 0;
    var openIndex = 1;
    var highIndex = 2;
    var lowIndex = 3;
    var closeIndex = 4;
    var volumeIndex = 5;

    final firstCells = _splitRow(lines.first);
    final looksLikeHeader = firstCells.any(
      (cell) => double.tryParse(cell.trim()) == null && cell.trim().isNotEmpty,
    );

    if (looksLikeHeader) {
      startLine = 1;
      final header = [
        for (final cell in firstCells)
          cell.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''),
      ];
      int find(List<String> names, int fallback) {
        for (final name in names) {
          final i = header.indexOf(name);
          if (i >= 0) return i;
        }
        return fallback;
      }

      timeIndex = find(_timeNames, 0);
      openIndex = find(_openNames, 1);
      highIndex = find(_highNames, 2);
      lowIndex = find(_lowNames, 3);
      closeIndex = find(_closeNames, 4);
      volumeIndex = find(_volumeNames, 5);
    }

    final candles = <Candle>[];
    var rows = 0;

    for (var i = startLine; i < lines.length; i++) {
      rows++;
      final lineNumber = i + 1;
      final cells = _splitRow(lines[i]);
      final maxIndex = [
        timeIndex,
        openIndex,
        highIndex,
        lowIndex,
        closeIndex,
      ].reduce((a, b) => a > b ? a : b);
      if (cells.length <= maxIndex) {
        issues.add(ImportIssue(lineNumber, 'not enough columns'));
        continue;
      }

      final timestamp = _parseTime(cells[timeIndex]);
      if (timestamp == null) {
        issues.add(
          ImportIssue(lineNumber, 'unreadable timestamp "${cells[timeIndex]}"'),
        );
        continue;
      }

      final open = double.tryParse(cells[openIndex].trim());
      final high = double.tryParse(cells[highIndex].trim());
      final low = double.tryParse(cells[lowIndex].trim());
      final close = double.tryParse(cells[closeIndex].trim());
      if (open == null || high == null || low == null || close == null) {
        issues.add(ImportIssue(lineNumber, 'non-numeric price'));
        continue;
      }
      final volume = volumeIndex < cells.length
          ? (double.tryParse(cells[volumeIndex].trim()) ?? 0)
          : 0.0;

      final candle = Candle(
        timestamp: timestamp,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume < 0 ? 0 : volume,
      );
      if (!candle.isValid) {
        issues.add(
          ImportIssue(
            lineNumber,
            'impossible OHLC (low $low, high $high, open $open, close $close)',
          ),
        );
        continue;
      }
      candles.add(candle);
    }

    candles.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Duplicate timestamps would make a window ambiguous; keep the first.
    final deduped = <Candle>[];
    DateTime? last;
    for (final c in candles) {
      if (last != null && c.timestamp == last) continue;
      deduped.add(c);
      last = c.timestamp;
    }

    return ImportResult(candles: deduped, issues: issues, totalRows: rows);
  }

  static List<String> _splitRow(String line) {
    final separator = line.contains('\t')
        ? '\t'
        : line.contains(';') && !line.contains(',')
        ? ';'
        : ',';
    return line.split(separator);
  }

  static DateTime? _parseTime(String raw) {
    final value = raw.trim().replaceAll('"', '');
    if (value.isEmpty) return null;

    final asInt = int.tryParse(value);
    if (asInt != null) {
      // Seconds, milliseconds or microseconds since the epoch.
      if (value.length >= 16) {
        return DateTime.fromMicrosecondsSinceEpoch(asInt, isUtc: true);
      }
      if (value.length >= 13) {
        return DateTime.fromMillisecondsSinceEpoch(asInt, isUtc: true);
      }
      if (value.length >= 9) {
        return DateTime.fromMillisecondsSinceEpoch(asInt * 1000, isUtc: true);
      }
      return null;
    }
    return DateTime.tryParse(value.replaceFirst(' ', 'T'))?.toUtc();
  }

  /// Serialises candles to the compact JSON shape the dataset loader reads.
  static Map<String, Object?> toDataset({
    required String symbol,
    required Timeframe timeframe,
    required AssetClass assetClass,
    required List<Candle> candles,
    String source = 'imported',
  }) => {
    'symbol': symbol,
    'timeframe': timeframe.name,
    'assetClass': assetClass.name,
    'source': source,
    'count': candles.length,
    'candles': [for (final c in candles) c.toJson()],
  };

  /// Reads a dataset produced by [toDataset], skipping any corrupt rows.
  static List<Candle> fromDataset(Map<String, Object?> json) {
    final raw = json['candles'];
    if (raw is! List) return const [];
    final out = <Candle>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final candle = Candle.tryFromJson(Map<String, Object?>.from(item));
      if (candle != null) out.add(candle);
    }
    return out;
  }
}
