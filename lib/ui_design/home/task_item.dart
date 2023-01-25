import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/database/my_database.dart';
import 'package:to_do_app/ui_design/home/edit_task_screen.dart';
import 'package:to_do_app/ui_design/my_theme.dart';
import 'package:to_do_app/utils/dialog_utils.dart';

import '../../database/task_data.dart';

class TaskItem extends StatefulWidget{
  Task task;
  late Task task2;
  TaskItem(this.task){
    task2 = task;
  }


  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(EditScreen.RouteName,arguments: widget.task);
        //Navigator.of(context).push(MaterialPageRoute(builder: (cotenxt)=>EditScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.2,
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),
            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                onPressed:( (buildContext){
                  deleteTask();
                }),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height:  MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 9,bottom: 10),
                    width: 4,
                    //height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: widget.task.isDone?MyTheme.Green:MyTheme.lightPrimary,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                          child: Text(widget.task.title,textAlign:TextAlign.start,style: widget.task.isDone?Theme.of(context).textTheme.headline6?.copyWith(color: MyTheme.Green):Theme.of(context).textTheme.headline6?.copyWith(color: MyTheme.lightPrimary,),
                        )),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                            child: Text(widget.task.description,textAlign:TextAlign.start,style: Theme.of(context).textTheme.headline4),
                            ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      MyDatabase.editIsDone(widget.task);
                    },
                    child: widget.task.isDone?
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal:16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.transparent,
                      ),
                      child: Text("Done !",style: Theme.of(context).textTheme.headline5!.copyWith(color: MyTheme.Green),),
                    )
                        :Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal:16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: MyTheme.lightPrimary,
                      ),
                      child: Icon(Icons.check,size: 30,color: Colors.white,),
                    ),
                  )
                ],
          )

          ),
        ),
      ),
    );
  }
  void deleteTask() {
    MyDialogUtils.showMessage(context, "Are you sure you want to delete this task ?", "Yes", negativeActionButton: "No",posAction: ()async {
      MyDialogUtils.showLoadingDialog(context, "loading...");
      await MyDatabase.deleteTask(widget.task);
      MyDialogUtils.hideDialog(context);
      MyDialogUtils.showMessage(context, "Task deleted successfully ", "Ok",negativeActionButton: "undo",negAction: ()async{
        MyDialogUtils.showLoadingDialog(context, "Loading...");
        try {
          await MyDatabase.insertTask(widget.task2);
          Navigator.pop(context);
          MyDialogUtils.hideDialog(context);
          MyDialogUtils.showAnotherMessage(
              context, "Task added successfully ", 'Ok',posAction: (){

          });
        } catch (e) {
          MyDialogUtils.hideDialog(context);
          MyDialogUtils.showMessage(
              context, "Failed Adding Task ", 'Try Again ', negativeActionButton: "Cancel",
              posAction: () {
                MyDatabase.insertTask(widget.task);
              }, negAction: () {
            Navigator.pop(context);
          });
        }
      });
    });
  }
}