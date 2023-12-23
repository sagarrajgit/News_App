import 'package:flutter/material.dart';

class MyDropDownItem extends StatelessWidget {
  const MyDropDownItem(
      {super.key, required this.countryValue, required this.countryName});

  final String countryValue;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem<String>(
        value: countryValue,
        child: Text(countryName,
            style: const TextStyle(fontSize: 18, color: Colors.white)));
  }
}
