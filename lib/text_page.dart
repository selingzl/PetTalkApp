import 'package:flutter/material.dart';
import 'begin_page.dart';

class TextPage extends StatelessWidget {

  final dynamic Line;
  final dynamic emoji;

  const TextPage(this.Line, this.emoji, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Image.asset(
            'images/paw.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),

          Align(
            alignment: const Alignment(-0.97, -0.90),
            child: IconButton(
              icon: const Icon(
                  Icons.arrow_back_ios),
              iconSize: 24,
              color: const Color(0xffD67471),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  // Dikdörtgen ve elips
                  child: Container(
                    width: 252,
                    height: 375,
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xffE9CD96).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: Text("$Line", style: TextStyle(fontSize: 20), textAlign: TextAlign.center, ),

                  ),
                ),
                ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xffE9CD96),
                    child: Image.asset(emoji, fit: BoxFit.fill,),
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