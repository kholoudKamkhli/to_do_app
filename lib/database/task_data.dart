class Task{
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;
  Task({this.id = '',required this.title,required this.description,required this.date,this.isDone = false});
  Map<String,dynamic>toFirestore(){
    return{
      'id':id,
      'title':title,
      'description':description,
      'DateTime':date.millisecondsSinceEpoch,
      'isDone':isDone,
    };
  }
  Task.fromFirestore(Map<String,dynamic> data):this(
    id: data['id'],
    title: data['title'],
    description: data['description'],
    date: DateTime.fromMillisecondsSinceEpoch(data['DateTime']),
    isDone: data['isDone'],
  );
}