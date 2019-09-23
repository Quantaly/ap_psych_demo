import 'package:json_annotation/json_annotation.dart';

part 'data_class.g.dart';

@JsonSerializable()
class DataSet {
  final String group;
  final bool startedWith;
  final List<DataRound> log;

  DataSet({this.group, this.startedWith, this.log});
  factory DataSet.fromJson(Map<String, dynamic> json) =>
      _$DataSetFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetToJson(this);
}

@JsonSerializable()
class DataRound {
  final String display;
  final String prompt;
  final bool correct;
  final int ms;

  DataRound({this.display, this.prompt, this.correct, this.ms});
  factory DataRound.fromJson(Map<String, dynamic> json) =>
      _$DataRoundFromJson(json);

  Map<String, dynamic> toJson() => _$DataRoundToJson(this);
}
