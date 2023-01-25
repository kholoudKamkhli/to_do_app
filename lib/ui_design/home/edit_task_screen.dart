import 'package:flutter/material.dart';
import 'package:to_do_app/database/my_database.dart';
import 'package:to_do_app/ui_design/my_theme.dart';
import 'package:to_do_app/utils/dialog_utils.dart';

import '../../database/task_data.dart';
import '../../utils/date_utils.dart';

class EditScreen extends StatefulWidget {
  static const String RouteName = "editScreen";

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var formKey = GlobalKey<FormState>();
  var task;
@override
  @override
  Widget build(BuildContext context) {
    task = ModalRoute.of(context)!.settings.arguments as Task;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        centerTitle: true,
        //backgroundColor: MyTheme.lightScaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            //width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            color: MyTheme.lightPrimary,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          "Edit Task",
                          style: Theme.of(context).textTheme.headline5,
                        )),
                    Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
                            child: TextFormField(
                              onChanged: (value) {
                                task.title = value;
                              },
                              decoration: InputDecoration(
                                  labelText: "Task Title",
                                  labelStyle: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .fontSize,
                                  )),
                              initialValue: task.title,
                              style: Theme.of(context).textTheme.headline4,
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
                            child: TextFormField(
                              onChanged: (value) {
                                task.description = value;
                              },
                              decoration: InputDecoration(
                                  labelText: "Task Description",
                                  labelStyle: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .fontSize,
                                  )),
                              initialValue: task.description,
                              style: Theme.of(context).textTheme.headline4,
                            )),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 17, horizontal: 14),
                        child: Text(
                          "Task Date ",
                          style: Theme.of(context).textTheme.headline4,
                        )),
                    Container(
                      alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            showTaskDatePicker();
                          },
                          child: Text(
                            MyDateUtils.dateFormat(task.date),
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Center(
                      child: GestureDetector(
                        onTap: (){
                          editTask(task);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          width: MediaQuery.of(context).size.width*0.6,
                          height: 50,
                          decoration: BoxDecoration(
                            color: MyTheme.lightPrimary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(child: Text("Save Changes",style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showTaskDatePicker() async {
    var userSelecteDate = await showDatePicker(
        context: context,
        initialDate: task.date,
        firstDate: task.date,
        lastDate: DateTime.now().add(Duration(days: 365)));
    if(userSelecteDate!=null){
      setState(() {
        task.date = userSelecteDate;
      });
    }
  }
  void editTask(task)async{
    MyDialogUtils.showLoadingDialog(context, 'Loading...',
        isDismissible: false);
    try {
      await MyDatabase.editTask(task);
      MyDialogUtils.hideDialog(context);
      print("Editting Done");
      MyDialogUtils.showAnotherMessage(
          context, "Task editted successfully ", 'Ok' ,posAction: () {
        Navigator.pop(context);
      });
    } catch (e) {
      MyDialogUtils.hideDialog(context);
      MyDialogUtils.showMessage(
          context, "Failed editting Task ", 'Try Again ', negativeActionButton: "Cancel",
          posAction: () {
            editTask(task);
          }, negAction: () {
        Navigator.pop(context);
      });
  }
}
}
