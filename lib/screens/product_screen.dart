import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/products_bloc.dart';
import 'package:gerente_loja/validators/product_validator.dart';
import 'package:gerente_loja/widgets/images_widget.dart';
import 'package:gerente_loja/widgets/product_sizes.dart';

class ProductScreen extends StatefulWidget {
  final String? categoryId;
  final DocumentSnapshot? product;

  const ProductScreen({Key? key, this.categoryId, this.product})
      : super(key: key);

  @override
  State<ProductScreen> createState() =>
      _ProductScreenState(categoryId!, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot? product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: const TextStyle(color: Colors.grey));
    }

    const _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data! ? "Editar Produto" : "Criar Produto");
          },
        ),
        actions: [
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data!) {
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: snapshot.data!
                              ? null
                              : () {
                                  _productBloc.deleteProduct();
                                  Navigator.of(context).pop();
                                },
                          icon: const Icon(Icons.remove));
                    });
              } else {
                return Container();
              }
            },
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: snapshot.data! ? null : saveProduct,
                    icon: const Icon(Icons.save));
              }),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        "Images",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ImagesWidget(
                          context: context,
                          initialValue: snapshot.data!["images"],
                          onSaved: _productBloc.saveImages,
                          validator: validateImages),
                      TextFormField(
                          initialValue: snapshot.data!["title"],
                          style: _fieldStyle,
                          decoration: _buildDecoration("Titulo"),
                          onSaved: _productBloc.saveTitle,
                          validator: validateTitle),
                      TextFormField(
                        initialValue: snapshot.data!["description"],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data!["price"]?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Tamanhos",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ProductSizes(
                        context: context,
                        initialValue: snapshot.data!["sizes"],
                        onSaved: (s) {
                          _productBloc.saveSizes;
                        },
                        validator: (s) {
                          if (s!.isEmpty) {
                            return "";
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data!,
                  child: Container(
                    color: snapshot.data! ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Salvando Produto...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      bool success = await _productBloc.saveProduct();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "Produto salvo!" : "Erro ao salvar produto!",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }
}
