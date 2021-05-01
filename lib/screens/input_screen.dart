import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../providers/item.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User loggedInUser;

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController sellerController = TextEditingController();
TextEditingController priceController = TextEditingController();

class InputPage extends StatelessWidget {
  static const routeName = '/input-screen';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<Item>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Page'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomInputs(settingsProvider),
              PickImage(settingsProvider),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (settingsProvider.image != null &&
              titleController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty &&
              priceController.text.isNotEmpty &&
              sellerController.text.isNotEmpty) {
            settingsProvider.title = titleController.text;
            settingsProvider.description = descriptionController.text;
            settingsProvider.price = double.parse(priceController.text);
            settingsProvider.id = DateTime.now().toString();
            settingsProvider.seller = sellerController.text;

            // Provider.of<Items>(context, listen: false).addItem(
            //   Item(
            //     id: settingsProvider.Id,
            //     title: settingsProvider.Title,
            //     image: settingsProvider.Image,
            //     description: settingsProvider.Description,
            //     seller: settingsProvider.Seller,
            //     price: settingsProvider.Price,
            //     isFavorite: false,
            //   ),
            // );

            _firestore
                .collection('items')
                .doc(settingsProvider.Id)
                .set(settingsProvider.toJson());

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Success!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (settingsProvider.image == null
                      ? 'Please select an image!'
                      : 'Some other Error has occured!'),
                ),
              ),
            );
            return;
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class PickImage extends StatelessWidget {
  final settingsProvider;
  PickImage(this.settingsProvider);

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 30);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      settingsProvider.setImage = _image;
    } else {
      print('No image selected.');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      settingsProvider.setImage = _image;
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              onPressed: () => getImage(),
              child: Column(
                children: [
                  Icon(
                    Icons.camera,
                    size: 40.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Image from camera",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              onPressed: () => getImageFromGallery(),
              child: Column(
                children: [
                  Icon(
                    Icons.storage_rounded,
                    size: 40.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Image from Storage",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Consumer<Item>(
          builder: (context, data, child) {
            return settingsProvider.image != null
                ? Flexible(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Image.file(settingsProvider.Image),
                    ),
                  )
                : Text("No Image is Selected");
          },
        ),
      ],
    );
  }
}

class CustomInputs extends StatelessWidget {
  final settingsProvider;
  CustomInputs(this.settingsProvider);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter a correct description of your product',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: sellerController,
              decoration: InputDecoration(
                labelText: 'Enter seller name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a seller name';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter(
                  RegExp(r"^\d+\.?\d{0,10}"),
                ),
              ], // O
              decoration: InputDecoration(
                labelText: 'Enter a price (in rupees)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some value';
                } else if (double.parse(value) < 0.0) {
                  return 'Please enter some correct value';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
