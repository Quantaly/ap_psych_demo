import 'dart:convert';
import 'dart:html';

import 'blocs/demo_bloc.dart';

final AnchorElement _downloadLink = querySelector("#download-link");

void downloadLog(List<ChallengeLog> log, bool startedWith) {
  var contents = jsonEncode({
    "group": Uri.parse(document.baseUri).queryParameters["group"],
    "startedWith": startedWith,
    "log": log.map((l) => l.toJson()).toList(),
  });
  var url = "data:application/json,$contents";
  _downloadLink
    ..href = url
    ..click();
}
