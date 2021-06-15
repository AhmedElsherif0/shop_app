import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';
import 'package:shop_app/widgets/show_dialog.dart';
import 'package:shop_app/widgets/user_image_packer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editProduct = Product(
      productId: null, title: '', price: 0.0, imageUrl: '', description: '');
  var _initValue = {
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': ''
  };

  var _isInit = true;
  var _isLoading = false;
  File _imageStored;

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      super.didChangeDependencies();
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findByID(productId);
        _initValue = {
          'title': _editProduct.title,
          'price': _editProduct.price.toStringAsFixed(2),
          'description': _editProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    } else {
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _titleFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {

      });
    }
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
    if (_editProduct.productId != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.productId, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editProduct);
      } catch (onError) {
        await CustomShowDialog.alertDialog(
            message: 'Something went Wrong', title: 'An Occurred Error');
      }
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CustomCircularProgress())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter The Title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: value,
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                          price: _editProduct.price,
                          productId: _editProduct.productId,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter The Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'value is null';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price Must Be a Number or More Than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                          price: double.parse(value),
                          productId: _editProduct.productId,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['Description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter The Description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          description: value,
                          imageUrl: _editProduct.imageUrl,
                          price: _editProduct.price,
                          productId: _editProduct.productId,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    UserImagePicker(
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
