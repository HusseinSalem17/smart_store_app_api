import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_smartstore/constants.dart';

class SliderCarousel extends StatefulWidget {
  late List<String> imgList;
  late List<Widget> imageSliders;
  SliderCarousel({super.key, required this.imgList}) {
    imageSliders = _generateSlides();
  }
  List<Widget> _generateSlides() {
    return imgList
        .map(
          (item) => Container(
            margin: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: HOST_URL + item,
                fit: BoxFit.cover,
                width: 1000,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.warning_rounded),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  State<SliderCarousel> createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            viewportFraction: 0.99,
            autoPlay: true,
            aspectRatio: 21 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgList.asMap().entries.map(
                (entry) {
                  return GestureDetector(
                    onTap: () {
                      _controller.animateToPage(entry.key);
                    },
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PRIMARY_SWATCH.withOpacity(
                          _current == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ))
      ],
    );
  }
}
