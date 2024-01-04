import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorblindgame/pages/game/game_model.dart';

final firestore = FirebaseFirestore.instance;

class GameRepository {
  static Future<bool> submitScore({RecordModel? recordModel}) async {
    try {
      return await firestore
          .collection('records')
          .doc(recordModel?.name)
          .set(recordModel?.toJson() ?? {})
          .then((value) => true);
    } catch (e) {
      return false;
    }
  }
}
