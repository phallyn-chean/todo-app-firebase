import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/data/firestore_datasource.dart';
import 'package:todo_app_firebase/widget/task_widget.dart';

class StreamNotes extends StatelessWidget {
  const StreamNotes({super.key, required this.isDone});
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireStore_DataSource().stream(isDone),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final notelist = FireStore_DataSource().getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: notelist.length,
          itemBuilder: (context, index) {
            final note = notelist[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                FireStore_DataSource().deleteNote(note.id);
              },
              child: TaskWidget(note: note),
            );
          },
        );
      },
    );
  }
}
