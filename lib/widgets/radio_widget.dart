import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({
    super.key,
    required this.titleRadio,
    required this.categColor,
    required this.valueInput,
    required this.onchangeValue,
  });
  final String titleRadio;
  final Color categColor;
  final int valueInput;
  final VoidCallback onchangeValue;

  @override
  Widget build(BuildContext context) {
    late Providerdata providerdata;
    providerdata = Provider.of<Providerdata>(context, listen: false);
    return Material(
      child: Theme(
        data: ThemeData(unselectedWidgetColor: categColor),
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          title: Transform.translate(
              offset: Offset(-22, 0),
              child: Text(
                titleRadio,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: categColor),
              )),
          activeColor: categColor,
          value: valueInput,
          groupValue: providerdata.radioValue,
          onChanged: (value) => onchangeValue(),
        ),
      ),
    );
  }
}
