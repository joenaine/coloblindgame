import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_model.g.dart';

@JsonSerializable()
class RecordModel {
  final String? name;
  final int? score;
  final int? level;
  RecordModel({
    this.name,
    this.score,
    this.level,
  });
  factory RecordModel.fromJson(Map<String, dynamic> json) =>
      _$RecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecordModelToJson(this);

  factory RecordModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return RecordModel.fromJson(doc.data() ?? {});
  }
}
