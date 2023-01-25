import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/database/my_database.dart';
import 'package:to_do_app/ui_design/home/task_item.dart';
import 'package:to_do_app/utils/dialog_utils.dart';

import '../../database/task_data.dart';

class TasksListTab extends StatefulWidget{
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  List<Task>allTasks = [];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
           CalendarTimeline(
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(Duration(days: 30)),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateSelected: (date){
                setState(() {
                  selectedDate = date;
                });
              },
              leftMargin: 20,
              monthColor: Colors.black,
              dayColor: Colors.black,
              activeDayColor: Theme.of(context).primaryColor,
              activeBackgroundDayColor: Colors.white,
              dotsColor: Theme.of(context).primaryColor,
              //selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
              shrink: true,
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Task>>(builder: (buildContext , snapshot){
              var allTasks = snapshot.data?.docs.map((doc)=>doc.data()).toList();
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return ListView.builder(itemBuilder: (buildContext,index){
                return TaskItem(allTasks![index]);
              },itemCount: allTasks?.length??0,);

            },stream: MyDatabase.getDataRealTime(selectedDate),),
          )
        ],
      )
    );
  }
}