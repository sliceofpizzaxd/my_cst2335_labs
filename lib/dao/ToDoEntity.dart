import 'package:floor/floor.dart';

@entity
class ToDo {
  static int maxID = 1;
  @primaryKey
  late final int id;

  final String entry;

  ToDo(this.entry, {int? id}) {
    if(id == null) {
      this.id = maxID;
      maxID++;
    }
    // make sure maxID does not conflict with database
    else {
      if(maxID < id) {
        maxID = id + 1;
      }
      this.id = id;
    }
  }
}