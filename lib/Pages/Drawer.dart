import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:portafolio/Const/Constants.dart' as constants;
import 'package:portafolio/Routes/Routes.dart';

class DrawerAll extends StatefulWidget {
  const DrawerAll({Key? key}) : super(key: key);

  @override
  State<DrawerAll> createState() => _DrawerAllState();
}

int _selectedDrawerItem = 1;

class _DrawerAllState extends State<DrawerAll> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);


  _onSelectedItem(int pos) {
    setState(() {
      _selectedDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //color: Color.fromRGBO(66, 66, 66, 1),
      child: ListView(
        padding: padding,
        children: <Widget>[
          FadeInLeft(
            child: const DrawerHeader(
              /*decoration: BoxDecoration(
                      color: Color.fromRGBO(44, 240, 233, 1),
                    ),*/
              child: Text(
                'Menu',
                style: TextStyle(
                  //color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          ListTile(
            leading: FadeInLeft(
              child: const Icon(
                Icons.format_list_bulleted_outlined,
              ),
            ),
            title: FadeInLeft(
              child: const Text('Listado de usuarios',
                  style: TextStyle(
                    fontSize: constants.fontSizeDrawer,
                  )),
            ),
            selected: (1 == _selectedDrawerItem),
            selectedColor: constants.selectedColorDrawer,
            selectedTileColor: Colors.blueGrey,
            onTap: () {
              _onSelectedItem(1);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.ACCESS);
            },
          ),
          /*ListTile(
            leading: FadeInLeft(
              child: Icon(
                _selectedDrawerItem == 2 ? Icons.map_rounded: Icons.map_outlined,
                size: constants.iconSizeDrawer,
              ),
            ),
            title: FadeInLeft(
              child: const Text(
                'Mapa de inspecciones',
                style: TextStyle(fontSize: constants.fontSizeDrawer),
              ),
            ),
            selected: (2 == _selectedDrawerItem),
            selectedColor: constants.selectedColorDrawer,
            selectedTileColor: constants.selectedTileColorDrawer,
            onTap: () {
              _onSelectedItem(2);
              Navigator.of(context);
              Navigator.pushReplacementNamed(context, Routes.ACCESS);
            },
          ),*/
          const Divider(/*color: Colors.white,*/),
          FadeInLeft(
            child: ListTile(
              leading: const Icon(
                Icons.close_outlined,
                size: constants.iconSizeDrawer,
              ),
              title: const Text(
                'Salir',
                style: TextStyle(fontSize: constants.fontSizeDrawer),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.LOGIN);
              },
            ),
          ),
        ],
      ),
    );
  }
}
