import 'dart:convert';
import 'dart:html';

import 'blocs/demo_bloc.dart';

final AnchorElement _downloadLink = querySelector("#download-link");

void downloadLog(List<ChallengeLog> log) {
  var contents = jsonEncode(log.map((l) => l.toJson()).toList());
  var url = "data:application/json,$contents";
  _downloadLink
    ..href = url
    ..click();
}