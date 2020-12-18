import 'package:get/get.dart';

class GetApp extends GetxController{
  int counter=0;
  increment(){
    counter++;
    update(['ibrahem','omar']);
  }
  decrement(){
    counter--;
    update(['omar']);
  }
}