import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'text_page.dart';



class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

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

  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Seçilen resmi kullanmak istiyorsanız burada işlem yapabilirsiniz.
      // Örneğin, Navigator ile başka bir sayfada gösterebilirsiniz.
      uploadFile(pickedFile as String);
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
                // Dikdörtgen ve içerisinde kamera ikonu
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Container(
                        width: 210,
                        height: 344,
                        margin: const EdgeInsets.only(bottom: 30),
                        // Dikdörtgenin yüksekliğini artırarak kamera ikonunu aşağı kaydırın
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _getImage(context); // Galeriyi aç
                          },
                          icon:  const Icon(
                              Icons.photo_camera_outlined),
                          iconSize: 24,
                          color:  const Color(0xffC2AA9B),

                        ),
                      ),
                    ),
                  ],
                ),
                //const SizedBox(height: 0), // Dikdörtgen ile buton arasındaki boşluk
                // Buton
                // 16 birim sola kaydırma
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Butona tıklandığında DiğerSayfa'ya geçiş yap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DigerSayfa()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xff67542E), backgroundColor: const Color(0xffF0C776), fixedSize: const Size(160, 50), // Buton boyutlarını ayarlayın
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0), // Kenarları yuvarlamak için değeri ayarlayın
                      ), // Metin rengi kahverengi

                      textStyle: const TextStyle(fontFamily: 'OpenSans', fontSize: 16),
                    ),
                    child: const Text('Fotoğrafı Yükle'),
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