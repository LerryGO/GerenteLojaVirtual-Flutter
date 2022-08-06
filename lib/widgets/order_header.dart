import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/users_bloc.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderHeader(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    final _user = _userBloc.getUser(order["clientId"]);
   

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_user["name"]}"), 
              Text("${_user["address"]}"),
              ],
          ),
        ),
       
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Produtos: R\$${order["productsPrice"].toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "Total: R\$${order["totalPrice"].toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ],
    );
  }
}
