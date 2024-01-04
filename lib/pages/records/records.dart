import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorblindgame/pages/game/game_model.dart';
import 'package:colorblindgame/pages/game/game_repository.dart';
import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  const Records({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('records')
              .orderBy('score', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<RecordModel> recordList = [];
              for (QueryDocumentSnapshot<Map<String, dynamic>> e
                  in snapshot.data!.docs) {
                recordList.add(RecordModel.fromFirestore(e));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Text('Rank'),
                    title: Text('Name'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 40,
                            child: Text('Level')),
                        SizedBox(width: 10),
                        Container(
                            alignment: Alignment.center,
                            width: 40,
                            child: Text('Score')),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: recordList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final record = recordList[index];
                      return ListTile(
                        leading: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                        ),
                        title: Text(record.name ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 40,
                                child: Center(child: Text('${record.level}'))),
                            SizedBox(width: 10),
                            Container(
                                alignment: Alignment.center,
                                width: 40,
                                child: Text('${record.score}')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox();
          }),
    );
  }
}
