import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatelessWidget {
  // Lista de páginas que o carrossel irá receber
  final List<Widget> pages;

  const CustomCarousel({required this.pages, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 80.0,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        viewportFraction: 0.8,
      ),
      items: pages.map((page) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),

              decoration: BoxDecoration(
                // color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: page, // Insere cada página aqui
            );
          },
        );
      }).toList(),
    );
  }
}
