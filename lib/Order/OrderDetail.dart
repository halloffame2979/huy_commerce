import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/CartModel.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Order/FinishedOrder.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatelessWidget {
  final CartModel order;

  const OrderDetail({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Order Detail'),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Divider(
                    height: 3,
                    color: Colors.transparent,
                  ),
                  Column(
                    children: List.generate(
                        order.products.length,
                        (index) => FinishedOrder(
                              product: ProductInOrderModel.fromJson(
                                order.products[index],
                              ),
                              status: order.status,
                            )),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 20,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Order Price: ' +
                          NumberFormat.currency(locale: 'vi').format(
                            order.totalPrice,
                          ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 20,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Order Date: ' +
                          DateFormat('dd/MM/yyyy').format(
                            order.orderDate.toDate(),
                          ),
                    ),
                  ),
                  Divider(color: Colors.transparent),
                  Visibility(
                    visible: order.status == 'Waiting',
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.blueGrey],
                          ),
                        ),
                        width: 100,
                        child: MaterialButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(order.id)
                                  .update({'Status': 'Cancel'});
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        order.status != 'Waiting' && order.status != 'Shipping',
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange],
                          ),
                        ),
                        width: 100,
                        child: MaterialButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .add({
                                'User': order.user,
                                'Status': 'Waiting',
                                'Product': order.products,
                                'OrderDate': Timestamp.fromDate(DateTime.now()),
                                'TotalPrice': order.totalPrice,
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Buy Again',
                            )),
                      ),
                    ),
                  ),
                  Divider(color: Colors.transparent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
