import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portafolio/Const/Constants.dart' as constants;
import 'package:portafolio/Model/AccessClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AccessClass user = AccessClass(id_movil: "", b_mapa: false, b_lista: false, c_nombre: "");

  final TextEditingController _txtNameController = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool statusCam = true;
  bool enable = false;

  CollectionReference users = FirebaseFirestore.instance.collection('access');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.TITULO_HOME),
        centerTitle: true,
      ),
      /*drawer: Drawer(
        child: DrawerAll(),
      ),*/
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return IconButton(
                                  onPressed: () async {
                                    await controller?.toggleFlash();
                                    setState(() {});
                                  },
                                  icon: snapshot.data! ? Icon(Icons.flashlight_off):  Icon(Icons.flashlight_on)
                              );
                              //return Text('Flash: ${snapshot.data}');
                            },
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                              onPressed: () async {
                                if(statusCam){
                                  await controller?.pauseCamera();
                                }else{
                                  await controller?.resumeCamera();
                                }
                                setState(() {
                                  statusCam = !statusCam;
                                });
                              },
                              icon: statusCam ? Icon(Icons.pause_circle) : Icon(Icons.play_circle)
                          )
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return IconButton(
                                  onPressed: () async {
                                    await controller?.flipCamera();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.flip_camera_android)
                              );
                            } else {
                              return const Text('Cargando');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          _inputName(),
          const SizedBox(height: 20,),
          _permisos(),
          const SizedBox(height: 20,),
          _buttonConceder(),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Container _inputName(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: _txtNameController,
        enabled: enable,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            hintText: constants.NOMBRE,
            border: InputBorder.none
        ),
        //cursorColor: Colors.amber,
      ),
    );
  }

  Row _permisos(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
          Row(
            children: [
              const Text("Lista"),
              enable ? Checkbox(
                  value: user.b_lista,
                  onChanged: (b){
                    setState(() {
                      user.b_lista = b!;
                    });
                  },
              ) : const Checkbox(value: false, onChanged: null)
            ],
          ),
        Row(
          children: [
            const Text("Mapa"),
            enable ? Checkbox(
                value: user.b_mapa,
                onChanged: (b){
                  setState(() {
                    user.b_mapa = b!;
                  });
                }
            ) : Checkbox(value: false, onChanged: null)
          ],
        )
      ],
    );
  }

  ElevatedButton _buttonConceder(){
    return ElevatedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: (){
          user.c_nombre = _txtNameController.text;
          print(user.toJson().toString());
          _addUser();
        },
        child: const Text(constants.CONCEDER_PERMISO)
    );
  }

  Widget _buildQrView(BuildContext context) {
    // Para este ejemplo, verificamos qué tan ancho o alto es el dispositivo y cambiamos el área de escaneo y la superposición en consecuencia.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // Para garantizar que la vista del escáner tenga el tamaño adecuado después de la rotación
    // necesitamos escuchar la notificación Flutter SizeChanged y actualizar el controlador
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.pink,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if(scanData.format == BarcodeFormat.qrcode){
        setState(() {
          controller.pauseCamera();
          print(scanData.code);
          statusCam = !statusCam;
          result = scanData;
          user.id_movil = scanData.code!;
          enable = true;
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add(user.toJson())
        .then((value){
          _showDialog("Succeso", true, "Usuario agregado");
        })
        .catchError((error) {
          print(error.toString());
          _showDialog("Error", false, "Error al agregar");
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
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
