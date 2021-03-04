import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../appstate.dart';

class RegionPicker extends StatelessWidget {
  const RegionPicker({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final Covid19Provider provider;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        List<String> items = [
          'Hrvatska',
          ...counties.map((String c) => '$c županija'
              .replaceAll('županija županija', 'županija')
              .replaceAll('  ', ' ')
              .replaceAll('Grad Zagreb županija', 'Grad Zagreb'))
        ];
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Regija'),
              content: SizedBox(
                width: 600,
                height: 500,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    String selectedItem = provider.county ?? 'Hrvatska';
                    String item = items.elementAt(index);

                    String filteredItem = item
                        .replaceAll(' županija', '')
                        .replaceAll('Zagrebačka', 'Zagrebačka ');
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      enableFeedback: true,
                      trailing: selectedItem == filteredItem
                          ? Icon(FluentIcons.checkbox_checked_24_regular)
                          : null,
                      title: Text(item),
                      onTap: item == selectedItem
                          ? null
                          : () {
                              if (item == 'Hrvatska') {
                                provider.setToGlobalData();
                              } else {
                                provider.changeCounty(
                                  item
                                      .replaceAll(' županija', '')
                                      .replaceAll('Zagrebačka', 'Zagrebačka '),
                                );
                              }

                              Navigator.of(context).pop();
                            },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Odustani'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(
            FluentIcons.location_24_regular,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(width: 4),
          Text(
            provider.county == null
                ? 'Hrvatska'
                : '${provider.county}'
                    .replaceAll('Grad Zagreb', 'Grad Zagreb')
                    .replaceAll('Zagrebačka  ', 'Zagrebačka županija'),
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: BorderSide(color: Theme.of(context).accentColor.withOpacity(0.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        primary: Colors.grey[900],
      ),
    );
  }
}
