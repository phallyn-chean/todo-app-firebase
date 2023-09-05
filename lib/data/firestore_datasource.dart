import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class FireStore_DataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> addNote(String subtitle, String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime date = DateTime.now();
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).set({
        'id': uuid,
        'subtitle': subtitle,
        'isDone': false,
        'image': image,
        'time': '${date.hour}:${date.minute}',
        'title': title,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: data['id'],
          subtitle: data['subtitle'],
          title: data['title'],
          time: data['time'],
          image: data['image'],
          isDone: data['isDone'],
        );
      }).toList();
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore.collection('users').doc(_auth.currentUser!.uid).collection('notes').where('isDone', isEqualTo: isDone).snapshots();
  }

  Future<bool> isDone(String uuid, bool isDone) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).update({'isDone': isDone});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> updateNote(String uuid, int image, String title, String subtitle) async {
    try {
      DateTime date = DateTime.now();
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).update({
        'time': '${date.hour}:${date.minute}',
        'subtitle': subtitle,
        'title': title,
        'image': image,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
