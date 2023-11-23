import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: IntroductionScreen(
        // globalBackgroundColor: Colors.white,
        // scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
              titleWidget: const Text(
                "Enjoy Your Music",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              bodyWidget: const Text(
                  " Immerse yourself in the world of music with our VMPA "),
              image: Image.asset("assets/images/image1.png",
                  height: 400, width: 400)),
          PageViewModel(
              titleWidget: const Text(
                "No Advertisement",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              bodyWidget: const Text(
                  "Your personal gateway to a world of endless melodies and rhythms"),
              image: Image.asset("assets/images/image2.png",
                  height: 400, width: MediaQuery.of(context).size.width)),
          PageViewModel(
              titleWidget: const Text(
                "Share Your Playlist",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              bodyWidget:
                  const Text("Discover and share your favorite tunes with ease "),
              image: Image.asset("assets/images/image3.png",
                  height: 400, width: double.infinity))
        ],
        onDone: () {
          Navigator.pushNamed(context, "HomeScreen");
        },
        onSkip: () {
          Navigator.pushNamed(context, "HomeScreen");
        },
        showSkipButton: true,
        skip: const Text(
          "skip",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4527A0)),
        ),
        next: const Icon(
          Icons.arrow_forward,
          color: Color(
            0xFF4527A0,
          ),
        ),
        done: const Text(
          "Done",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4527A0)),
        ),

        dotsDecorator: DotsDecorator(
          size: const Size.square(10),
          activeSize: const Size(20, 10),
          activeColor: const Color(
            0xFF4527A0,
          ),
          spacing: const EdgeInsets.symmetric(horizontal: 3),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}
