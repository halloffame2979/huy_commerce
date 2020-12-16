import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Products/ProductBox.dart';
import 'package:huy_commerce/Products/ProductList.dart';
import 'package:huy_commerce/UserInformation/UserInformation.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('HSCom'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: (){
              },
            ),
          ],
        ),
        drawer: DrawerMenu(),
        body: ProductList(),
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(context).primaryColor,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserInformation()),
                );
              },
              leading: ClipOval(
                child: Container(
                  width: 55,
                  height: 55,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Image(
                    image: AssetImage('assets/default_avatar.png'),
                  ),
                ),
              ),
              title: Text(
                user.displayName,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(user.email),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.history),
            title: Text(
              'Đơn mua',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Lịch sử mua hàng'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.add_shopping_cart),
            title: Text(
              'Mua lại',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Xem thêm các sản phẩm'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.shopping_cart),
            title: Text(
              'Giỏ hàng',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Các sản phẩm trong giỏ'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.trending_down),
            title: Text(
              'Khuyến mãi',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Các khuyến mãi hiện có'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 3, thickness: 3),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserInformation()));
            },
            dense: true,
            leading: Icon(Icons.account_circle),
            title: Text(
              'Tài khoản',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Đến trang cá nhân'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.place),
            title: Text(
              'Địa chỉ',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Địa chỉ nhận hàng'),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 3, thickness: 3),
          ListTile(
            onTap: () {},
            dense: true,
            leading: Icon(Icons.help),
            title: Text(
              'Câu hỏi thường gặp',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
