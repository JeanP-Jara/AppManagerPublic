
import 'package:flutter/material.dart';

showAlertUsers(context, String cadena){
  showDialog(
      barrierColor: const Color.fromRGBO(14, 106, 142 , 0.7),
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Column(
            children: [
              Text("ALERTA",
                style: TextStyle(
                  color: Color.fromRGBO(119, 118, 118, 1),
                ),
              ),
              Divider(
                height: 40,
                thickness: 2,
                color: Colors.blueGrey,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ///Text('Usuarios actualizados', style: const TextStyle(fontSize: 16, color: Color.fromRGBO(119, 118, 118, 1),),),
                //SizedBox(height: 15),
                Text(cadena,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(119, 118, 118, 1),
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(70, 15, 70, 15),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),)
                    ),
                    /*backgroundColor: MaterialStateProperty.all<Color>(
                      ConstApp.colorSecundario,
                    ),*/
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child:const Text('ACEPTAR', style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
        );
      }
  );
}

showDialogGenera(context, String titulo, bool success, String mensaje) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      icon: success ?
      const Icon(Icons.check_circle, size: 48, color: Colors.green) :
      const Icon(Icons.error, size: 48, color: Colors.red),
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
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}