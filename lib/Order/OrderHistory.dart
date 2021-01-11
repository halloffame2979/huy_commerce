import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/OrderModel.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Order/FinishedOrder.dart';

import '../IntermediateWidget.dart';
import 'OrderDetail.dart';

// 'Ordering'

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  int selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<String> status = ['All', 'Waiting', 'Shipping', 'Cancel', 'Received'];
    var userId = FirebaseAuth.instance.currentUser.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Column(
          children: [
            Row(
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(12),
                    decoration: selected == index
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        : null,
                    child: Text(
                      status[index],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: selected == index ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Order')
                      .where('User', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> orderList) {
                    if (orderList.hasError) return ErrorMessage();

                    if (orderList.connectionState == ConnectionState.active) {
                      var orders = orderList.data.docs
                          .where((element) =>
                              element.data()['Status'] != 'Ordering')
                          .toList()
                            ..sort((a, b) => a
                                .data()['OrderDate']
                                .compareTo(b.data()['OrderDate']));
                      orders = orders.reversed.toList();

                      if (selected != 0) {
                        orders = orders
                            .where((element) =>
                                element.data()['Status'] == status[selected])
                            .toList();
                      }
                      if (orders.length == 0) {
                        return Center(
                          child: Text(
                            'There are no orders placed yet',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          children: List.generate(orders.length, (index) {
                            var order = Order.fromJson(orders[index].data()
                              ..addAll({'ID': orders[index].id}));
                            return Column(
                              children: List.generate(order.products.length,
                                  (index) {
                                var product = ProductInOrder.fromJson(
                                    order.products[index]);
                                return FinishedOrder(
                                  product: product,
                                  status: order.status,
                                );
                              })
                                ..add(
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 0.6,
                                    child: ListTile(
                                      dense: true,
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetail(
                                                      order: order,
                                                    )));
                                      },
                                      leading: Icon(Icons.notes),
                                      title: Text('Order detail'),
                                      trailing: Icon(Icons.navigate_next),
                                    ),
                                  ),
                                )
                                ..add(Divider(
                                  thickness: 6,
                                )),
                            );
                          }),
                        );
                      }
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
