import 'package:flutter/material.dart';

class UiHelper{


  static helperButton(String message, void Function()? onTap){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: 220,
        height: 45,
        child: ElevatedButton(
            onPressed: onTap, child: Text(message),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white
          ),

        ),
      ),
    );
  }

  static message(String message,BuildContext context,Color messageColor){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: messageColor,
        duration: const Duration(milliseconds: 700),
        content: Text(message)
    ));
  }


}