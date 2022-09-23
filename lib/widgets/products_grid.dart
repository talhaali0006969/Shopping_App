import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/product_item.dart';
import 'package:shopping_app/providers/products.dart';

class ProductsGrid extends StatelessWidget {
  bool showFav = false;
  ProductsGrid({required this.showFav});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav ? productsData.FavItems : productsData.Items;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // id: products[i].id,
            //imgUrl: products[i].imageUrl,
            //title: products[i].title,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
