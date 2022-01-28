import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Sli extends StatefulWidget {
  static const routeName = "sli";

  @override
  _SliState createState() => _SliState();
}

class _SliState extends State<Sli> {
  final List<String> imglist = [
    "https://cdn.pixabay.com/photo/2021/10/30/11/01/forest-6754057_960_720.jpg",
    "https://cdn.pixabay.com/photo/2021/11/11/09/12/lighthouse-6785763_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/02/09/20/42/marriage-proposal-4834488_960_720.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: CarouselSlider.builder(
        options: CarouselOptions(
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 1),
        itemCount: imglist.length,
        itemBuilder: (context, index, realIndex) {
          return bimage(imglist[index], index);
        },
      ),
    );
  }
 Widget bimage(String urlimage, int index) => Container(
        width: double.infinity,
        child: Image.network(
          urlimage,
          fit: BoxFit.cover,
        ),
      );
}
