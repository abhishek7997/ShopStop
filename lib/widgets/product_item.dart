import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/item.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Item>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product,
            );
          },
          child: Image.file(
            product.image,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // leading: Consumer<Item>(
          //   builder: (ctx, product, _) => IconButton(
          //     icon: Icon(
          //       product.isFavorite ? Icons.favorite : Icons.favorite_border,
          //     ),
          //     color: Theme.of(context).accentColor,
          //     onPressed: () {
          //       product.toggleFavourite();
          //       //   authData.token,
          //       //   authData.userId,
          //       // );
          //     },
          //   ),
          // ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              try {
                final user = _auth.currentUser;
                if (user != null) {
                  loggedInUser = user;
                  print(loggedInUser.email);
                  _firestore
                      .collection(loggedInUser.email)
                      .doc(product.Id)
                      .set(product.toJson());
                }
              } catch (e) {
                print(e);
              }

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      //cart.removeSingleItem(product.id);
                      _firestore
                          .collection(loggedInUser.email)
                          .doc(product.Id)
                          .delete();
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

// class PotHoleItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final pothole = Provider.of<Item>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14.0),
//       child: Container(
//         decoration: BoxDecoration(
//             color: Color(0xFFd8e2dc),
//             borderRadius: BorderRadius.circular(15.0)),
//         child: ListTile(
//           trailing: Icon(pothole.isFavorite ? Icons.check : Icons.clear),
//           title: Row(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 5.0),
//                 // height: double.infinity,
//                 alignment: Alignment.center,
//                 child: Image.file(
//                   pothole.Image,
//                   fit: BoxFit.contain,
//                   width: 65,
//                   height: 65,
//                 ),
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(height: 10.0),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Text(
//                         "${pothole.title}",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: 14.0, fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           onTap: () {
//             Navigator.of(context)
//                 .pushNamed(PotHoleDetailScreen.routeName, arguments: pothole);
//           },
//         ),
//       ),
//     );
//   }
// }
