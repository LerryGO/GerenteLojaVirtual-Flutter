import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order, {Key? key}) : super(key: key);

  final states = [
    "",
    "Em preparação",
    "Em transporte",
    "Aguardando Entrega",
    "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.id),
          initiallyExpanded: order["status"] != 4,
          title: Text(
            "#${order.id.substring(order.id.length - 7, order.id.length)} - ${states[order["status"]]}",
            style: TextStyle(
                color:
                    order["status"] == 1 ? Colors.grey.shade800 : order["status"] == 2? Colors.amber.shade600 : order["status"] == 3 ? Colors.blue : Colors.green),
          ),
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(order),
                  const Divider(
                    thickness: 1,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order["products"].map<Widget>(
                      (p) {
                        return ListTile(
                          title: Text(p["product"]["title"] + " " + p["size"]),
                          subtitle: Text(p["category"] + "/" + p["pid"]),
                          trailing: Text(
                            p["quantity"].toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc("clientId")
                              .collection("orders")
                              .doc(order.id)
                              .delete();
                          order.reference.delete();
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                      ElevatedButton(
                        onPressed: order["status"] > 1
                            ? () {
                                order.reference
                                    .update({"status": order["status"] - 1});
                              }
                            : null,
                        child: Text(
                          "Regredir",
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                      ElevatedButton(
                        onPressed: order["status"] < 4
                            ? () {
                                order.reference
                                    .update({"status": order["status"] + 1});
                              }
                            : null,
                        child: const Text(
                          "Avançar",
                          style: TextStyle(color: Colors.green),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
