import 'package:flutter/material.dart';
import 'package:l5_iot/product.dart';

class ShoppingListItem extends StatelessWidget {
  final Product product;
  final inCart;
  final Function(Product product, bool inCart) onCartChanged;

  ShoppingListItem({
    @required this.product,
    @required this.inCart,
    @required this.onCartChanged,
  });

  Future<AlertDialog> displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Product details",
              textAlign: TextAlign.center,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //position
              mainAxisSize: MainAxisSize.min,
              // wrap content in flutter
              children: <Widget>[
                Text(product.name),
                Text("Quantity: "+product.quantity.toString()),
                Text("Price: "+product.price.toString()),
              ],
            ),
            actions: [
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text(product.name[0]),
      ),
      title: Text(product.name),
      onTap: () => displayDialog(context),
    );
  }
}
