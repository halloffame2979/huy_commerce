import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Order/OrderHistory.dart';
import 'package:huy_commerce/Order/OrderingList.dart';
import 'package:huy_commerce/Products/ProductList.dart';
import 'package:huy_commerce/UserInformation/UserInformation.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('HSCom'),
          actions: [
            ProductInCart(),
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
    Future navigateTo(BuildContext context, Widget page) {
      return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => page),
      );
    }

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
          TileInDrawer(
            title: 'My Orders',
            subtitle: 'Orders History',
            icon: Icons.history,
            onTap: () {
              Navigator.of(context).pop();
              navigateTo(context, OrderHistory());
            },
          ),
          Divider(height: 0),
          TileInDrawer(
            title: 'My Cart',
            subtitle: 'Products in Cart',
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.of(context).pop();
              navigateTo(context, OrderingList());
            },
          ),
          Divider(height: 0),
          TileInDrawer(
            title: 'Discount',
            subtitle: 'Available Discount',
            icon: Icons.trending_down,
            onTap: () {},
          ),
          Divider(height: 3, thickness: 3),
          TileInDrawer(
            title: 'Account',
            subtitle: 'Go to my profile',
            icon: Icons.account_circle,
            onTap: () {
              Navigator.of(context).pop();
              navigateTo(context, UserInformation());
            },
          ),
          Divider(height: 0),
          TileInDrawer(
            title: 'Address',
            subtitle: 'Manage my addresses',
            icon: Icons.place,
            onTap: () {},
          ),
          Divider(height: 3, thickness: 3),
          TileInDrawer(
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
            icon: Icons.help,
            onTap: () {},
          ),
          Divider(height: 0),
          // FlatButton(
          //     onPressed: (){
          //       FirebaseFirestore.instance.collection('Product').add({
          //         'Brand':'',
          //         'Detail':'',
          //         'Discount':0,
          //         'Image':['Facial Cleanser/','Facial Cleanser/'],
          //         'Name':'',
          //         'Price':1,
          //         'Quantity':1000,
          //         'Type':'Facial Cleanser',
          //       });
          //     }, child: Text('a')),
        ],
      ),
    );
  }
}

class TileInDrawer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const TileInDrawer(
      {Key key, this.title, this.subtitle, this.icon, this.onTap})
      : assert(title != null),
        assert(icon != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: true,
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(
        Icons.navigate_next,
        size: 30,
      ),
    );
  }
}
