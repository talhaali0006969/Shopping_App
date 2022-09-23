import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'Cart_Screen.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _ShowFavOnly = false;
  var _isIntit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isIntit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isIntit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("MyShop"),
            actions: [
              PopupMenuButton(
                  onSelected: (FilterOptions SelectedValue) {
                    setState(() {
                      if (SelectedValue == FilterOptions.Favorites) {
                        _ShowFavOnly = true;
                      } else {
                        _ShowFavOnly = false;
                      }
                    });
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.Favorites,
                        ),
                        PopupMenuItem(
                          child: Text('Show All'),
                          value: FilterOptions.All,
                        ),
                      ]),
              Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                  child: ch!,
                  value: cart.ItemCount.toString(),
                  color: Colors.red,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ProductsGrid(
                  showFav: _ShowFavOnly,
                )),
    ));
  }
}
