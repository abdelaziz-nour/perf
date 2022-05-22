import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he_store/itemsmodel.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var database = FirebaseFirestore.instance.collection('cart').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => ItemModel.fromMap(doc.data())).toList());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.purple,
              ))),
      body: ListView(
        children: [
          Center(
            child: Text(
              'قائمة المشتريات',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<List<ItemModel>>(
              stream: database,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  return ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: snapshot.data!.map(builditem).toList());
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }

  Widget builditem(ItemModel item) => Card(
        child: ListTile(
          leading: Image.asset(
            item.image,
            width: 100,
          ),
          title: Text(item.title),
          subtitle:
              Text('Size : ${item.size}\nPrice : ${item.price.toString()} \$'),
          trailing: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('حذف'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("cart")
                    .doc(item.title)
                    .delete();
              }),
        ),
      );
}

/*import 'package:flutter/material.dart';
import 'package:he_store/itemsmodel.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
      body: StreamBuilder<List<ItemModel>>(
        stream: null,
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.active){
          return ListView(
            shrinkWrap: true,
            primary: false,
            children: [
              Row(
                children: snapshot.data!.map(builditem).toList());
              )
            ],
          );}
        }
      ),
    );
    
  }
  Widget builditem(ItemModel item) =>Card(
                child: Column(
                  children: [
                    Image.asset('assets/1.jpeg'),
                    Text('data'),
                    Text('data')
                  ],
                ),
              )
}
*/