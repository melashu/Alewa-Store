import 'package:abushakir/abushakir.dart';
import 'package:flutter/material.dart';

class Dates {
  static var dayList = [
    'ቀን',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];
  static var monthList = [
    'ወር',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  static var yearList = [
    'ዓ.ም',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
  ];
  static List<DropdownMenuItem<String>> getDay() {
    List<DropdownMenuItem<String>> days = [];
    dayList.forEach((day) {
      days.add(DropdownMenuItem(child: Text(day),value: day,));
    });
    return days;
  }
  
    static List<DropdownMenuItem<String>> getMonth() {
    List<DropdownMenuItem<String>> months = [];
    monthList.forEach((month) {
      months.add(DropdownMenuItem(
        child: Text(month),
        value: month,
      ));
    });
    return months;
  }
 static List<DropdownMenuItem<String>> getYear() {
    List<DropdownMenuItem<String>> years = [];
    yearList.forEach((year) {
      years.add(DropdownMenuItem(
        child: Text(year),
        value: year,
      ));
    });
    return years;
  }


  static String get today{
      var mapDate = EtDatetime.now().date;
      var today = EtDatetime(year: mapDate['year'],month: mapDate['month'],day: mapDate['day']).toString();
      return today;
  }
}