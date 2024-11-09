import 'package:floor/floor.dart';
import 'ToDoEntity.dart';

@dao
abstract class ToDoDAO {
  @Query('SELECT * FROM ToDo')
  Future<List<ToDo>> getList();

  @insert
  Future<void> insertItem(ToDo item);

  @delete
  Future<void> deleteItem(ToDo item);

}
