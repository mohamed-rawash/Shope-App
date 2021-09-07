import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/product.dart';
import 'package:real_shop/providers/products.dart';
class EditProductScreen extends StatefulWidget {
  static const String routName = "/edit_product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct = Product(
      id: null,
      title: "",
      description: "",
      price: 0,
      imageUrl: ""
  );
  var _initialValues = {
    'title': "",
    'description': "",
    'price': "",
    'imageUrl': ""
  };
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initialValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': "",
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageUrl() {
    if(_imageUrlFocusNode.hasFocus){
      if(
      (! _imageUrlController.text.startsWith("http")&&
      ! _imageUrlController.text.startsWith("http"))||
      (! _imageUrlController.text.endsWith("png")&&
      ! _imageUrlController.text.endsWith("jpg")&&
      ! _imageUrlController.text.endsWith("jpeg")
      )){
        return;
      }
      setState(() {

      });
    }
  }

  Future<void> _saveForm()async {
    final _isValid = _formKey.currentState.validate();
    if(!_isValid){
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editProduct.id != null){
      await Provider.of<Products>(context, listen: false).updateProduct(_editProduct.id, _editProduct);
    }else{
      try{
        await Provider.of<Products>(context, listen: false).addProduct(_editProduct);
      }catch(e){
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred"),
            content: Text("Something went wrong!"),
            actions: [
              FlatButton(
                child: Text("Okay!"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          )
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white, size: 24,),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ?Center(
        child: CircularProgressIndicator(),
      )
      :Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initialValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter a title";
                  }
                  return null;
                },
                onSaved: (value){
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: value,
                      description: _editProduct.description,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl
                  );
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _initialValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter a price";
                  }
                  if(double.tryParse(value) == null){
                    return "Please enter a valid price";
                  }
                  if(double.tryParse(value) <= 0){
                    return "Please enter a valid price";
                  }
                  return null;
                },
                onSaved: (value){
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: _editProduct.description,
                      price: double.parse(value),
                      imageUrl: _editProduct.imageUrl
                  );
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _initialValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter a description";
                  }
                  if(value.length < 30){
                    return "Please enter a valid description";
                  }
                  return null;
                },
                onSaved: (value){
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: value,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blue),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ?Text("Enter a URL")
                        :FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child:TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URl',
                      ),
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter a URL";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}