import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart' as csv;

import 'package:ap_psych_demo/data_class.dart';
import 'package:stats/stats.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print("Please specify a directory.");
    exitCode = 255;
    return;
  }

  var dir = Directory(args.first);
  var dataSets = <String, Set<DataSet>>{};

  await for (var fse in dir.list()) {
    if (fse is File && fse.path.endsWith(".json")) {
      var dataSet = DataSet.fromJson(jsonDecode(await fse.readAsString()));
      dataSets[dataSet.group]?.add(dataSet) ??
          (dataSets[dataSet.group] = {dataSet});
    }
  }

  Directory("output").createSync();
  var outfile = File("output/output.csv");
  var csvSink = csv.ListToCsvConverter()
      .startChunkedConversion(CsvOutSink(outfile.openWrite()));
  csvSink.add(["Group", "Mean", "Median", "Standard Deviation"]);
  for (var group in dataSets.entries) {
    var data = group.value.map((ds) => ds.log.length + 2);
    var stats = Stats.fromData(data);
    csvSink.add([group.key, stats.mean, stats.median, stats.standardDeviation]);
    var groupfile = File("output/${group.key}.csv");
    var groupSink = csv.ListToCsvConverter()
        .startChunkedConversion(CsvOutSink(groupfile.openWrite()));
    groupSink
        .add(["Characters", "Count", "Mean", "Median", "Standard Deviation"]);
    for (var i = 0; i < stats.max - 2; i++) {
      var roundStats = Stats.fromData(group.value
          .where((ds) => ds.log.length > i)
          .map((ds) => ds.log[i].ms));
      groupSink.add([
        i + 3,
        roundStats.count,
        roundStats.mean,
        roundStats.median,
        roundStats.standardDeviation
      ]);
    }
    groupSink.close();
  }
  csvSink.close();
}

class CsvOutSink implements Sink<String> {
  final IOSink out;
  CsvOutSink(this.out);

  @override
  void add(String data) {
    out.write(data);
  }

  @override
  void close() {
    out.close();
  }
}
