import 'package:flutter/material.dart';

class CustomNotification extends Notification {
  final dynamic? notification;
  final dynamic? id;
  final dynamic? value;
  CustomNotification({this.notification, this.value, this.id});
  
  @override
  void dispatch(BuildContext? target) {
    print('Dispatched');
    super.dispatch(target);
  }
}

enum Notifications {
  update,
  delete,
  confirm,
  deny,
}
