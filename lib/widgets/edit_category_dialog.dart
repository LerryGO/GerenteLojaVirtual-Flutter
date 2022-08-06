import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';

class EditCategoryDialog extends StatefulWidget {
  final TextEditingController _controller;
  final CategoryBloc _categoryBloc;

  EditCategoryDialog({Key? key, DocumentSnapshot? category})
      : _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(
            text: category != null ? category["title"] : ""),
        super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheet(
                            onImageSelected: (image) {
                              widget._categoryBloc.setImage(image);
                              //Navigator.of(context).pop();
                            },
                          ));
                },
                child: StreamBuilder(
                    stream: widget._categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return CircleAvatar(
                          child: snapshot.data is File
                              ? Image.file(
                                  snapshot.data as File,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  snapshot.data.toString(),
                                  fit: BoxFit.cover,
                                ),
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        return Icon(Icons.image);
                      }
                    }),
              ),
              title: StreamBuilder<String>(
                  stream: widget._categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: widget._controller,
                      onChanged: widget._categoryBloc.setTitle,
                      decoration: InputDecoration(
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: widget._categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ElevatedButton(
                          onPressed: snapshot.data!
                              ? () {
                                  widget._categoryBloc.delete();
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                                color:
                                    snapshot.data! ? Colors.red : Colors.grey),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0)),
                        );
                      }
                    }),
                StreamBuilder<bool>(
                    stream: widget._categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.hasData
                            ? () async {
                                print(snapshot);
                                await widget._categoryBloc.saveData();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Salvar",
                          style: TextStyle(
                              color: snapshot.hasData
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
