import "package:flutter/material.dart";

class Style {
  static ButtonStyle get smallButton {
    return OutlinedButton.styleFrom(
        minimumSize: Size(100, 30),
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.all(3),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));
  }

  static ButtonStyle get outlinedButtonStyle {
    return OutlinedButton.styleFrom(
        side: BorderSide(
            color: Colors.deepPurpleAccent,
            width: 1,
            style: BorderStyle.solid));
  }

  static ButtonStyle get elevatedButtonStyle {
    return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        elevation: 8,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
  }

  static TextStyle get style1 {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get mainStyle1 {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue);
  }

  static TextStyle get mainStyle2 {
    return TextStyle(
      fontSize: 13,
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get style2 {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get dropDouwnStyle {
    return TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    );
  }
}
