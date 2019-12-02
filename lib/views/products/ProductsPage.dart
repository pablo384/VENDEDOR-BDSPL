import 'package:flutter/material.dart';

import '../../index.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  /// Controlador de el input ade busqueda
  final TextEditingController _filter = new TextEditingController();
  // Variable que almacena el texto a buscar
  String _searchText = "";

  /// Variable que almacena todos los productos
  List<ProductDataModel> products = new List<ProductDataModel>();

  /// Se almacena Lista de productos filtrados con el criterio de busqueda
  List<ProductDataModel> filteredProducts = new List<ProductDataModel>();

  /// Icono de busqueda
  Icon _searchIcon = new Icon(Icons.search);
  // Titulo de pantalla
  Widget _appBarTitle = new Text('Buscar producto');

  /// Constructor de clase
  _ProductsPageState() {
    /// A la escucha de los cambios en el texto a buscar
    _filter.addListener(() {
      /// Si el texto a buscar esta vacio
      /// asigna todos los productos a lista de productos filtrados
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredProducts = products;
        });
      } else {
        /// Si el temrino a buscar no esta vacio se almacena en [_searchText]
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  /// Build del widget que se encarga de construir la interfaz completa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SafeArea(
        child: Container(
          child: _buildList(),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  /// Este metodo se encarga de construir la parte superior de la pantalla
  /// y ademas controlar su interaccion con el usuarios.
  /// Si se hace click en el icono buscar se elimina este y muestra
  /// el icono de X y el input para bsucar productos.
  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  /// Este se encarga de construir la lista de productos que estaran a lo lasrgo de la
  /// pantalla. ademas de filtrar si hay un termino de busqueda valido.
  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<ProductDataModel> tempList = new List<ProductDataModel>();
      for (int i = 0; i < filteredProducts.length; i++) {
        if (filteredProducts[i].descLarga.toLowerCase().contains(
                  _searchText.toLowerCase(),
                ) ||
            filteredProducts[i].lineaProd.toLowerCase().contains(
                  _searchText.toLowerCase(),
                )) {
          tempList.add(filteredProducts[i]);
        }
      }
      filteredProducts = tempList;
    }

    /// ListView que construye cada elemento dentro de la lista de productos
    /// En la interfaz grafica.
    return ListView.builder(
      itemCount: products == null ? 0 : filteredProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: new ListTile(
            title: Container(
              padding: EdgeInsets.all(3.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${filteredProducts[index].id}"),
                  Text("${filteredProducts[index].descLarga}"),
                  Text("Existencia:" + filteredProducts[index].ultExist),
                  Text("Precio:" + filteredProducts[index].precio),
                ],
              ),
            ),
            onTap: () async {
              print(filteredProducts[index].toJson());
              // var _cantidad = TextEditingController();
              // await showDialog(
              //     context: context,
              //     barrierDismissible: true,
              //     builder: (ctx) {
              //       return SimpleDialog(
              //         contentPadding: const EdgeInsets.all(8.0),
              //         children: <Widget>[
              //           Column(
              //             children: <Widget>[
              //               Text("Cantidad"),
              //               new TextField(
              //                 autofocus: true,
              //                 controller: _cantidad,
              //                 keyboardType: TextInputType.number,
              //                 decoration: new InputDecoration(
              //                   prefixIcon: new Icon(Icons.plus_one),
              //                   labelText: "Cantidad",
              //                 ),
              //                 onSubmitted: (arg) {
              //                   print(arg);
              //                 },
              //               ),
              //               RaisedButton(
              //                 onPressed: () {
              //                   print(_cantidad.text);
              //                   var linea = LineaFactura(
              //                     cantidad: double.tryParse(_cantidad.text) ??
              //                         int.tryParse(_cantidad.text).toDouble(),
              //                     producto: filteredProducts[index],
              //                   );
              //                   widget.onSave(linea);
              //                   Navigator.of(context).pop();
              //                   Navigator.of(ctx).pop();
              //                 },
              //                 child: Text("Aceptar"),
              //               )
              //             ],
              //           )
              //         ],
              //       );
              //     });
            },
          ),
        );
      },
    );
  }

  /// Metodo encargado de obtener los productos desde la base de datos.
  void _getProducts() async {
    var _prod = await DatabaseService.getProductsOnce();
    setState(() {
      products = _prod;
      filteredProducts = products;
    });
  }

  /// Metodo que se ejecuta cuendo el boton de busqueda es presionado.
  /// Este cambia la interfaz mostrando el input para escribir el criterio a buscar.
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = Card(
          // color: Colors.white,
          child: new TextField(
            autofocus: true,
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Buscar...',
            ),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(
          'Busca tu producto',
        );
        filteredProducts = products;
        _filter.clear();
      }
    });
  }
}
