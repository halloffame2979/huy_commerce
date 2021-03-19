import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  String text;
  var controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: MaterialButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Test')
                .add({'Text': text});
          },
          child: Text('Butt'),
          color: Colors.blue,
        ),
        body: Column(
          children: [
            Center(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (text) {
                  setState(() {
                    this.text = text;
                  });
                },
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Test').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.active) {
                    List a = snapshot.data.docs.map((e) => e.data()['Text']).toList().cast<String>();
                    if(a.length ==0) return Text('NULL');
                    return Column(
                      children: [
                        MaterialButton(
                            onPressed: () {
                              a.forEach((element) {
                                print(element);
                              });

                            },
                            child: Text('Huy')),
                      ],
                    );
                  } else
                    return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
