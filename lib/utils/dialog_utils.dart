import 'package:flutter/material.dart';

class MyDialogUtils{
  static void showLoadingDialog(BuildContext context,String message,{bool isDismissible = true}){
    showDialog(context: context, builder: (buildContext){
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width:12),
            Text(message),
          ],
        ),
      );
    },
      barrierDismissible: isDismissible,
    );
  }
  static void showMessage(BuildContext context , String Message , String posActionButton,{String negativeActionButton = '',VoidCallback? posAction, VoidCallback? negAction}){
    List<Widget>actions = [];
    if(posActionButton!=null){
      actions.add(TextButton(
        child: Text(posActionButton),
        onPressed: (){
          hideDialog(context);
          if(posAction!=null){
            posAction();
          }
        },
      ));
    }
    if(negativeActionButton!=null){
      actions.add(TextButton(
        child: Text(negativeActionButton),
        onPressed: (){
          hideDialog(context);
          if(negAction!=null){
            negAction();
          }
        },
      ));
    }
    showDialog(context: context, builder: (BuildContext){
      barrierDismissible: true;
      return AlertDialog(
        content: Text(Message),
        actions: actions,
      );
    });
  }
  static void showAnotherMessage(BuildContext context , String Message , String posActionButton,{VoidCallback? posAction, VoidCallback? negAction}){
    List<Widget>actions = [];
    if(posActionButton!=null){
      actions.add(TextButton(
        child: Text(posActionButton),
        onPressed: (){
          hideDialog(context);
          if(posAction!=null){
            posAction();
          }
        },
      ));
    }
    showDialog(context: context, builder: (BuildContext){
      barrierDismissible: true;
      return AlertDialog(
        content: Text(Message),
        actions: actions,
      );
    });
  }
  static void hideDialog(BuildContext context){
    Navigator.pop(context);
  }
}