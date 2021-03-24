import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final IconData icon;
  final Text text;
  final T? value;
  
  CustomPopupMenuItem({
    Key? key,
    Widget? child,
    required this.value,
    required this.icon,
    required this.text
  }) : super(
    key: key,
    value: value,
    child: child,
  );

  
  @override
  _CustomPopupMenuItemState<T> createState() =>_CustomPopupMenuItemState<T>();
  
  double get height => kMinInteractiveDimension;

  @override
  bool represents(T? value) {
    return value == this.value;
  }
  
}


class _CustomPopupMenuItemState<T> extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {

    return PopupMenuItem(
      child: Row(
        children: [
          Icon(widget.icon, color: Colors.black),
          VerticalDivider(),
          widget.text
        ],
      ),
      value: widget.value
    );
  }
}


enum PopupActions {
  edit,
  empty,
  clear
}