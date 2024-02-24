import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {

    late MapboxMapController mapController;
     final darkStyle = 'mapbox://styles/celes73/clsusga0g004s01qgc6j1d0bj';
     final streetStyle = 'mapbox://styles/celes73/clsuspd0y004801qj5wxp4aq6';
     String  selectedStyle  = 'mapbox://styles/celes73/clsusga0g004s01qgc6j1d0bj';
     final center = const LatLng(-32.900530, -68.799489);

    _onMapCreated(MapboxMapController controller){
      mapController = controller;
      _onStyleLoaded();
   }
    void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }
   /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }
    Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(Uri.parse(url));
    return mapController.addImage(name, response.bodyBytes);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: (){
            mapController.animateCamera( CameraUpdate.zoomIn() );
          },
          
          ),
          const SizedBox( height: 10,),
          FloatingActionButton(
          child: const Icon(Icons.zoom_out),
          onPressed: (){
            mapController.animateCamera( CameraUpdate.zoomOut() );
          }, 
          ),
          const SizedBox( height: 10,),

          FloatingActionButton(
          child: const Icon(Icons.sentiment_very_dissatisfied),
          onPressed: (){
            mapController.addSymbols( [
              SymbolOptions(
                geometry: center,
                //iconSize: 3,
                textField: 'Montaña creada aqui',
                iconImage: 'networkImage',
                textOffset: const Offset(0, 2)

            ) 
            ]
             
              );
          },
          ),
          const SizedBox( height: 10,),

           FloatingActionButton(
          child: const Icon(Icons.adjust_rounded),
          onPressed:(){
            if( selectedStyle == darkStyle){
               selectedStyle = streetStyle;
              
            }else{
              selectedStyle = darkStyle;
             }
              _onStyleLoaded();
            setState(() { });
          }

          )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      accessToken: 'acces_token',
      //const String.fromEnvironment("ACCESS_TOKEN"),
      initialCameraPosition: CameraPosition(
        target: center ,
        zoom : 14
        ),
      );
  }
}