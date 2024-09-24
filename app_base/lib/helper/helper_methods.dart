// retorna os dados formatados para String

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  // converter pra string
  DateTime dateTime = timestamp.toDate();

  // get year
  String ano = dateTime.year.toString();


  // get month
  String mes = dateTime.month.toString(); 

  // get day

  String dia = dateTime.day.toString();

  // formato finak

  String formattedData = dia + '/' + mes + '/' + ano;
  return formattedData;
}