import 'package:cloud_firestore/cloud_firestore.dart';


class AccessClass {
  final String? id;
  String id_movil;
  String c_nombre;
  bool b_mapa;
  bool b_lista;
  bool? isExpanded;

  AccessClass({
    this.id, required this.id_movil, required this.b_mapa, required this.b_lista, required this.c_nombre, this.isExpanded
  });

  factory AccessClass.fromJson(DocumentSnapshot<Map<String, dynamic>> json){
    return AccessClass(
        id: json.id,
        id_movil: json['id_movil'],
        b_mapa: json['b_mapa'],
        b_lista: json['b_lista'],
        c_nombre: json['c_nombre'],
        isExpanded: false
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id_movil': id_movil,
      'b_mapa': b_mapa,
      'b_lista': b_lista,
      'c_nombre': c_nombre
    };
  }
}