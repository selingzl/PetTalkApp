import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'text_page.dart';


class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  late File _image;
  late List _results;
  bool imageSelect = false;
  var imagepath;
  late String line = '';
  late String emoji = '';

  final picker = ImagePicker();

  @override
  void initState()
  {
    super.initState();
    loadModel();
  }

  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/my_model.tflite",labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }

  //Options(Camera or Gallery)
  Future<void> _showImageOptions() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openCamera();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  pickImage();
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

// For storage the photo
  Future<void> uploadFile(String filePath) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child('images/photo.jpg');

      await storageRef.putFile(File(filePath));
      print('File uploaded');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
    imagepath = image.path;
    print("RESULTS: $_results");
  }

  Future<void> _openCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
    imagepath = image.path;
    print("RESULTS: $_results");
  }

  Future<void> chooseLine() async {
    if (imageSelect) {
      _results.forEach((result) {
        String? label = result['label'];
        if ( label == 'Happy') {
          emoji = "assets/happy.png";
          line = "I'm so happy right now!";
        } else if (label == 'Sad') {
          emoji = "assets/sad.png";
          line = "I'm so sad right now";
        } else if (label == 'Angry') {
          emoji = "assets/angry.png";
          line = "I'm so angry right now";
        } else {
          line = "I don't know how I feel";
          emoji = "assets/expressionless.png";
        }
      });
      // Now you have a list of lines, one for each result
      print("lines: $line");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Image.asset(
            'images/homepage.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Container(
                        height: 344,
                        width: 210,
                        margin: const EdgeInsets.only(bottom: 30),
                        // Dikdörtgenin yüksekliğini artırarak kamera ikonunu aşağı kaydırın
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: (imageSelect)
                            ? Image.file(
                          File(imagepath), // Use Image.file to display an image from the file system
                          fit: BoxFit.fitWidth,
                        )
                            : Container(),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _showImageOptions(); // Galeriyi aç
                          },
                          icon:  const Icon(
                              Icons.photo_camera_outlined),
                          iconSize: 40,
                          color:  const Color(0xffC2AA9B),

                        ),
                      ),
                    )
                  ],
                ),
                //const SizedBox(height: 0), // Dikdörtgen ile buton arasındaki boşluk
                // Buton
                // 16 birim sola kaydırma
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      imageClassification(_image);
                      chooseLine();
                      print("LINE: $line");
                      // Butona tıklandığında DiğerSayfa'ya geçiş yap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TextPage(line, emoji)),
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xff67542E), backgroundColor: const Color(0xffF0C776), fixedSize: const Size(160, 50), // Buton boyutlarını ayarlayın
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0), // Kenarları yuvarlamak için değeri ayarlayın
                      ), // Metin rengi kahverengi

                      textStyle: const TextStyle(fontFamily: 'OpenSans', fontSize: 16),
                    ),
                    child: const Text('Upload image'),
                  ),
                ),


              ],
            ),
          ),

        ],
      ),
    );
  }
}