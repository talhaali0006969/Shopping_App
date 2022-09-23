import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/user_products_item.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProductScreen';
  Future<void> RefreshScreen(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => RefreshScreen(context),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: ProductsData.Items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                    id: ProductsData.Items[i].id,
                    ImageUrl: ProductsData.Items[i].imageUrl,
                    Title: ProductsData.Items[i].title),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
