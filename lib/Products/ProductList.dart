import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/AvailableProductModel.dart';

import 'ProductBox.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map> fetchedData = [];
  QueryDocumentSnapshot last;
  bool isLast = false;
  bool isLoading = false;
  var controller = ScrollController();

  Future fetchProducts() async {
    List<QueryDocumentSnapshot> rawProductList =
        (await FirebaseFirestore.instance.collection('Product').limit(6).get())
            .docs;

    if (rawProductList.length < 6) {
      setState(() {
        isLast = true;
      });
    } else {
      setState(() {
        last = rawProductList.last;
      });
    }
    var res = await parse(rawProductList);
    setState(() {
      fetchedData.addAll(res);
    });
  }

  Future fetchNext() async {
    if (isLast) return;
    print('fetch');
    setState(() {
      isLoading = true;
    });
    List<QueryDocumentSnapshot> rawProductList = (await FirebaseFirestore
            .instance
            .collection('Product')
            .startAfterDocument(last)
            .limit(6)
            .get())
        .docs;
    if (rawProductList.isEmpty) {
      setState(() {
        isLast = true;
        isLoading = false;
        isLast = null;
      });
      return;
    } else if (rawProductList.length < 6) {
      setState(() {
        isLast = true;
        last = null;
        isLoading = false;
      });
      var res = await parse(rawProductList);
      setState(() {
        fetchedData.addAll(res);
      });
      return;
    } else {
      setState(() {
        last = (rawProductList.last);
      });
      var res = await parse(rawProductList);
      setState(() {
        fetchedData.addAll(res);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map>> parse(List<QueryDocumentSnapshot> rawProductList) async {
    List<Map> products = [];
    for (var rawProduct in rawProductList) {
      var url = [];
      for (var image in rawProduct.data()['Image']) {
        url.add(await FirebaseStorage.instance.ref(image).getDownloadURL());
      }
      var product = rawProduct.data();
      product['ID'] = rawProduct.id;
      product['Image'] = url;
      products.add(product);
    }

    return products;
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    var listener = () {
      if (controller.position.pixels >
              controller.position.maxScrollExtent - 20 &&
          !isLast &&
          !isLoading) fetchNext();
    };
    controller.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fetchedData.isEmpty
        ? Loading()
        : GridView.count(
            controller: controller,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            crossAxisCount: 2,
            childAspectRatio: 3 / 5,
            padding: EdgeInsets.all(6),
            children: List.generate(
                fetchedData.length,
                (index) => ProductBox(
                      product:
                          AvailableProductModel.fromJson(fetchedData[index]),
                    ))
              ..addAll(isLoading ? [Loading(),Loading()] : [Container()]),
          );
  }
}
