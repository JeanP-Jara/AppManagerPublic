import 'package:flutter/material.dart';
import 'package:portafolio/Model/AccessClass.dart';
import 'package:portafolio/Pages/Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portafolio/Const/Constants.dart' as constants;
import 'package:portafolio/Pages/Home.dart';

class Access extends StatefulWidget {
  const Access({Key? key}) : super(key: key);

  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  List<AccessClass> _list = [];
  List<AccessClass> _foundedUsers = [];

  @override
  void initState() {
    super.initState();
    getListUser();

  }

  void getListUser() async {
    final list = await FirebaseFirestore.instance.collection("access").get();
    print(list);
    if(list.docs.isNotEmpty ){
      _list = [];
      for(var doc in list.docs){
        _list.add(AccessClass.fromJson(doc));
      }
      setState(() {
        _foundedUsers = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ACCESOS"),
      ),
      drawer: const Drawer(
        child: DrawerAll(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return const HomePage();
              },
            ),
          ).then((value) => getListUser());
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _foundedUsers.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(_foundedUsers[i].c_nombre),
              backgroundColor: Colors.blueGrey[50],
              collapsedBackgroundColor: Colors.blueGrey[50],
              /*shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, *//*color: Colors.pink*//*),
                borderRadius: BorderRadius.circular(10),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),*/
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Divider(),
                      Text(_foundedUsers[i].id_movil),
                      Row(
                        children: [
                          const Text("Lista"),
                          Checkbox(
                              value: _foundedUsers[i].b_lista,
                              onChanged: (b){
                                setState(() {
                                  _foundedUsers[i].b_lista = b!;
                                });
                                print(_foundedUsers[i].b_lista);
                              }
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Mapa"),
                          Checkbox(
                              value: _foundedUsers[i].b_mapa,
                              onChanged: (b){
                                setState(() {
                                  _foundedUsers[i].b_mapa = b!;
                                });
                              }
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){
                                updateAccess(_foundedUsers[i]);
                              },
                              child: Text("Aceptar")
                          ),
                          SizedBox(width: 12),
                          TextButton(
                              onPressed: (){
                                setState(() {
                                  _foundedUsers[i].isExpanded = false;
                                });
                              },
                              child: Text("Cancelar")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Future<void> updateAccess(AccessClass user) async {
    await FirebaseFirestore.instance.collection("access")
        .doc(user.id)
        .update(user.toJson())
        .then((value){
          _showDialog("Succeso", true, "Datos actualizados");
        })
        .catchError((error) {
          print(error.toString());
          _showDialog("Error", false, "Datos NO actualizados");
        });
  }

  Future<void> _showDialog(String titulo, bool success, String mensaje) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        icon: success ?
              const Icon(Icons.check_circle, size: 48, color: Colors.lightGreenAccent) :
              const Icon(Icons.error, size: 48, color: Colors.redAccent),
        title: Text(titulo),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensaje),
          ],
        ),
        actions: [
          TextButton(
            onPressed: (){
              getListUser();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
