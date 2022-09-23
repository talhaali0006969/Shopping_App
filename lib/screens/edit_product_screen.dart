// @dart=2.9
import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/Edit_Product";
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageContraller = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImage);
    // TODO: implement initState
    super.initState();
  }

  var _inItValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _inItValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageContraller.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImage() {
    if (!_imgUrlFocusNode.hasFocus) if ((_imageContraller.text
                .startsWith('http') &&
            !_imageContraller.text.startsWith('https')) ||
        (!_imageContraller.text.endsWith('.png') &&
            !_imageContraller.text.endsWith('.jpg') &&
            !_imageContraller.text.endsWith('.jpeg'))) {
      return;
    }

    setState(() {});
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .UpdateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Center(
                    child: Text(
                      "An Error Occured",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  content: Text("Something went Wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Ok"))
                  ],
                ));
      }
      //ctrl+shift+/ to comment block
      /*finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }*/
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageContraller.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _inItValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Title Please";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            description: _editedProduct.description);
                      },
                    ),
                    TextFormField(
                      initialValue: _inItValues['price'],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_desFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            description: _editedProduct.description);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Price Please";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Value must be greater than zero !";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                        initialValue: _inItValues['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _desFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              description: value);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Description Please";
                          }
                          if (value.length < 10) {
                            return "Minimum 10 characters";
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageContraller.text.isEmpty
                              ? Text("Enter Image Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageContraller.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'ImageUrl'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imgUrlFocusNode,
                              controller: _imageContraller,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    imageUrl: value,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter ImageUrl Please";
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return "Enter Correct Url Please";
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return "Please Enter Valid Image Url";
                                } else {
                                  return null;
                                }
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
