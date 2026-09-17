// A command-line tool for turning OHLCV CSV files into TradePath datasets.
//
// Usage:
//
//   dart run tools/import_ohlcv.dart \
//       --input path/to/BTCUSDT-1h.csv \
//       --symbol BTC/USDT \
//       --timeframe h1 \
//       --class crypto \
//       --out assets/market_data
//
// The CSV may have a header row in any column order; `timestamp,open,high,
// low,close,volume` and the common exchange variants are recognised. Rows that
// would produce an impossible candle are reported and skipped rather than
// written out.
//
// Add `--scenarios N` to also emit a scenario package: a compact index of
// windows over the imported data, each with its decision point, detected
// features and scored difficulty. The simulator reads these the same way it
// reads generated scenarios, so imported history slots straight in.

import 'dart:convert';
import 'dart:io';

import 'package:tradepath/data/market/ohlcv_csv_importer.dart';
import 'package:tradepath/data/scenarios/difficulty_scorer.dart';
import 'package:tradepath/data/scenarios/feature_detector.dart';
import 'package:tradepath/domain/models/market.dart';

void main(List<String> args) {
  final options = _parseArgs(args);
  if (options == null) {
    stdout.writeln(_usage);
    exitCode = 64;
    return;
  }

  final input = File(options.input);
  if (!input.existsSync()) {
    stderr.writeln('Input file not found: ${options.input}');
    exitCode = 66;
    return;
  }

  stdout.writeln('Reading ${options.input}…');
  final result = OhlcvCsvImporter.parse(input.readAsStringSync());

  stdout.writeln('  rows read      : ${result.totalRows}');
  stdout.writeln('  candles kept   : ${result.candles.length}');
  stdout.writeln('  rows skipped   : ${result.skipped}');
  for (final issue in result.issues.take(10)) {
    stdout.writeln('    - $issue');
  }
  if (result.issues.length > 10) {
    stdout.writeln('    … and ${result.issues.length - 10} more');
  }

  if (result.isEmpty) {
    stderr.writeln('Nothing usable was imported.');
    exitCode = 65;
    return;
  }

  final outDir = Directory(options.out);
  outDir.createSync(recursive: true);

  final slug = options.symbol.replaceAll(RegExp(r'[^A-Za-z0-9]'), '_');
  final datasetPath = '${options.out}/${slug}_${options.timeframe.name}.json';
  File(datasetPath).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(
      OhlcvCsvImporter.toDataset(
        symbol: options.symbol,
        timeframe: options.timeframe,
        assetClass: options.assetClass,
        candles: result.candles,
        source: 'csv:${input.uri.pathSegments.last}',
      ),
    ),
  );
  stdout.writeln('Wrote dataset: $datasetPath');

  if (options.scenarios <= 0) return;

  final scenarios = _buildScenarios(
    candles: result.candles,
    symbol: options.symbol,
    timeframe: options.timeframe,
    wanted: options.scenarios,
  );
  if (scenarios.isEmpty) {
    stdout.writeln(
      'Not enough candles to build scenario windows (need at least 120).',
    );
    return;
  }
  final packagePath =
      '${options.out}/${slug}_${options.timeframe.name}'
      '_scenarios.json';
  File(packagePath).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'symbol': options.symbol,
      'timeframe': options.timeframe.name,
      'dataset': datasetPath.split('/').last,
      'count': scenarios.length,
      'scenarios': scenarios,
    }),
  );
  stdout.writeln(
    'Wrote scenario package: $packagePath (${scenarios.length} windows)',
  );
}

List<Map<String, Object?>> _buildScenarios({
  required List<Candle> candles,
  required String symbol,
  required Timeframe timeframe,
  required int wanted,
}) {
  const visible = 70;
  const future = 40;
  final total = visible + future;
  if (candles.length < total + 10) return const [];

  final maxWindows = candles.length - total;
  final stride = (maxWindows / wanted).ceil().clamp(1, maxWindows);

  final out = <Map<String, Object?>>[];
  for (var start = 0; start + total <= candles.length; start += stride) {
    final window = candles.sublist(start, start + visible);
    final swings = FeatureDetector.detectSwings(window);
    final features = FeatureDetector.detectFeatures(window, swings);
    final volatility = FeatureDetector.classifyVolatility(window);
    final condition = FeatureDetector.classifyCondition(
      swings,
      volatility,
      features,
    );
    final hardness = DifficultyScorer.score(
      candles: window,
      swings: swings,
      features: features,
    );

    out.add({
      'scenarioId': '$symbol-${timeframe.name}-$start',
      'asset': symbol,
      'timeframe': timeframe.name,
      'visibleStart': start,
      'decisionIndex': start + visible - 1,
      'futureEnd': start + total,
      'difficulty': DifficultyScorer.bucket(hardness).name,
      'difficultyScore': double.parse(hardness.toStringAsFixed(4)),
      'marketCondition': condition.name,
      'volatility': volatility.name,
      'features': [for (final f in features) f.name],
    });
    if (out.length >= wanted) break;
  }
  return out;
}

class _Options {
  _Options({
    required this.input,
    required this.symbol,
    required this.timeframe,
    required this.assetClass,
    required this.out,
    required this.scenarios,
  });

  final String input;
  final String symbol;
  final Timeframe timeframe;
  final AssetClass assetClass;
  final String out;
  final int scenarios;
}

_Options? _parseArgs(List<String> args) {
  final map = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (!arg.startsWith('--')) continue;
    final key = arg.substring(2);
    if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
      map[key] = args[++i];
    } else {
      map[key] = 'true';
    }
  }
  final input = map['input'];
  final symbol = map['symbol'];
  if (input == null || symbol == null) return null;

  return _Options(
    input: input,
    symbol: symbol,
    timeframe: Timeframe.fromName(map['timeframe'] ?? 'h1'),
    assetClass: AssetClass.fromName(map['class'] ?? 'crypto'),
    out: map['out'] ?? 'assets/market_data',
    scenarios: int.tryParse(map['scenarios'] ?? '0') ?? 0,
  );
}

const String _usage = '''
Import OHLCV CSV data into a TradePath dataset.

Required:
  --input <path>        CSV file to read
  --symbol <SYMBOL>     Instrument symbol, e.g. BTC/USDT

Optional:
  --timeframe <name>    m1 | m5 | m15 | h1 | h4 | d1   (default h1)
  --class <name>        crypto | stocks | forex | futures | commodities
  --out <dir>           Output directory (default assets/market_data)
  --scenarios <n>       Also emit a scenario package with up to n windows

Example:
  dart run tools/import_ohlcv.dart --input data/btc_1h.csv \\
      --symbol BTC/USDT --timeframe h1 --class crypto --scenarios 500
''';
