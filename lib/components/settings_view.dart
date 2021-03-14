import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:covid19hr/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

// import '../app_logo.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currMode = AdaptiveTheme.of(context).mode ?? ThemeMode.system;

    return ListView(
      children: [
        SizedBox(height: 8),
        ListTile(
          leading: Icon(
            Icons.flare_rounded,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            'COVID-19 HR',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          subtitle: Text('verzija 1.1'),
        ),
        SizedBox(height: 4),
        ListTile(
          leading: Icon(FluentIcons.info_24_regular),
          title: Text('Copyright © Goran Alković, 2021'),
          subtitle: Text('goranalkovic.com'),
          trailing: Icon(FluentIcons.open_24_regular),
          onTap: () => launchURL('https://goranalkovic.com'),
        ),
        Divider(),
        ListTile(
          leading: Icon(FluentIcons.data_usage_24_regular),
          title: Text('Podaci preuzeti s API-ja Nacionalnog stožera'),
          subtitle: Text('koronavirus.hr'),
          trailing: Icon(FluentIcons.open_24_regular),
          onTap: () => launchURL('https://koronavirus.hr'),
        ),
        Divider(),
        ListTile(
          leading: Container(height: 0, width: 0),
          title: Text(
            'Izgled aplikacije',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile(
          groupValue: currMode,
          onChanged: (_) => AdaptiveTheme.of(context).setSystem(),
          value: AdaptiveThemeMode.system,
          title: Text('Tema sustava'),
          subtitle: currMode == AdaptiveThemeMode.system
              ? Text(
                  'Prati temu sustava (${Theme.of(context).brightness == Brightness.dark ? 'tamno' : 'svijetlo'})')
              : Text('Prati temu sustava'),
        ),
        RadioListTile(
          groupValue: currMode,
          onChanged: (_) => AdaptiveTheme.of(context).setLight(),
          value: AdaptiveThemeMode.light,
          title: Text('Svijetlo'),
        ),
        RadioListTile(
          groupValue: currMode,
          onChanged: (_) => AdaptiveTheme.of(context).setDark(),
          value: AdaptiveThemeMode.dark,
          title: Text('Tamno'),
        ),
      ],
    );
  }
}
