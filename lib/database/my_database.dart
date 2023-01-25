import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/database/task_data.dart';
import 'package:to_do_app/utils/date_utils.dart';

class MyDatabase{
  static CollectionReference<Task>getTaskCollection(){
    var tasksCollection =
    FirebaseFirestore.instance.collection('tasks').withConverter(fromFirestore: (snapshot,options)=>Task.fromFirestore(snapshot.data()!), toFirestore: (task,options)=>task.toFirestore());
    return tasksCollection;
  }
  static Future<void> insertTask(Task task){
    var taskCollection = getTaskCollection();
    var doc = taskCollection.doc();
    task.id = doc.id;
    task.date = MyDateUtils.extractDate(task.date);
    return doc.set(task);
  }
  static Future<List<Task>> getTasks(DateTime datetime)async{
    var querySnapshot = await getTaskCollection().where('DateTime',isEqualTo:MyDateUtils.extractDate(datetime).millisecondsSinceEpoch ).get();
    var tasksList = querySnapshot.docs.map((doc)=>doc.data()).toList();
    return tasksList;
  }
  static Stream<QuerySnapshot<Task>> getDataRealTime(DateTime datetime){
    return getTaskCollection().where('DateTime',isEqualTo: MyDateUtils.extractDate(datetime).millisecondsSinceEpoch).snapshots();
  }
  static deleteTask(Task task)async {
    var TaskDoc= getTaskCollection().doc(task.id);
    return TaskDoc.delete();
  }
  static Future<void> editTask(Task task)async{
    var collection = getTaskCollection();
    return await collection.doc(task.id).update({
      'title':task.title,
      'description':task.description,
      'DateTime':task.date.millisecondsSinceEpoch,
    });
  }
  static Future<void> editIsDone(Task task)async{
    var collection = getTaskCollection();
    return await collection.doc(task.id).update({
      'isDone':task.isDone?false:true,
    });
  }
}