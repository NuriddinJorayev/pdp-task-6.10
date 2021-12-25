import 'package:firebase_database/firebase_database.dart';
import 'package:planlarim/models/post.dart';

class RTDBService {
  static final _db = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> setSave(Post p) async {
    await _db.child("posts").push().set(p.Tojson());
    return _db.onChildChanged;
  }

  static Future<List<Post>> Load() async {
    return await _db
        .child("posts")
        .get()
        .then((value) => LoadChild(value))
        .then((value) => value);
  }

  static List<Post> LoadChild(v) {
    if (v != null) {
      DataSnapshot snap = v;
      List<Post> list = [];
      for (var i in snap.children) {
        list.add(Post.fromjson(i.value));
      }

      return list;
    }
    return [];
  }
}
