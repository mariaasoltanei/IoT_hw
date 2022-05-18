import 'package:flutter/material.dart';
import 'package:l5_iot/product.dart';
import 'package:l5_iot/shopping_list_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shopping List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.amber,
      ),
      home: MyHomePage(title: 'My Shopping List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController searchBarController = TextEditingController();
  List<Product> shoppingCart = [];
  List<Product> favouriteItems = [];
  List<Product> filteredProducts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    setState(() {
      filteredProducts = shoppingCart;
    });
    super.initState();
  }

  void searchItem(String inputString) {
    if (inputString.isEmpty) {
      filteredProducts = shoppingCart;
    } else {
      setState(() { //clear editing controller
        filteredProducts = shoppingCart
            .where((item) =>
                item.name.toLowerCase().contains(inputString.toLowerCase()))
            .toList();
      });
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "assets/toDo.png",
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    "Products you have to buy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      onChanged: (input) {
                        searchItem(input);
                      },
                      controller: searchBarController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final item = filteredProducts[index];
                    return Dismissible(
                      key: Key(item.name),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          favouriteItems.add(filteredProducts[index]);
                          //print(favouriteItems);
                        }
                        setState(() {
                          filteredProducts.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$item dismissed')));
                      },
                      background: Container(color: Colors.green),
                      secondaryBackground: Container(color: Colors.red),
                      child: ShoppingListItem(
                        product: filteredProducts[index],
                        inCart:
                            filteredProducts.contains(filteredProducts[index]),
                        onCartChanged: onCartChanged,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayDialog(context),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Future<AlertDialog> displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Add a new product to your list",
              textAlign: TextAlign.center,
            ),
            content: TextField(
              controller: textFieldController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // print(textFieldController.text);
                  if (textFieldController.text.trim() != "")
                    setState(() {
                      shoppingCart.add(Product(name: textFieldController.text));
                      textFieldController.clear();
                    });

                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        });
  }

  void onCartChanged(Product product, bool inCart) {
    setState(() {
      // if (!inCart) shoppingCart.add(product);
      // if (inCart)
      shoppingCart.remove(product);
    });
  }
}
