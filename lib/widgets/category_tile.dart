import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/product_screen.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  const CategoryTile(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditCategoryDialog(
                  category: category,
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                category["icon"],
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            category["title"],
            style: TextStyle(
                color: Colors.grey.shade800, fontWeight: FontWeight.w500),
          ),
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: category.reference.collection("items").snapshots(),
              builder: (context, snapshot) {
                String _primeiraImagem = '';
                if (!snapshot.hasData) {
                  return Container();
                }
                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    if (_primeiraImagem.isEmpty) {
                      _primeiraImagem = doc['images'][0];
                    }
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(_primeiraImagem),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(doc["title"]),
                      trailing: Text("R\$${doc["price"].toStringAsFixed(2)}"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductScreen(
                                  categoryId: category.id,
                                  product: doc,
                                )));
                      },
                    );
                  }).toList()
                    ..add(ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.add,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      title: const Text("Adicionar"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductScreen(categoryId: category.id)));
                      },
                    )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
