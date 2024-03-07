import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../repository/repository.dart';
import '../../repository/slider_model.dart';

class InstantCarouselSlider extends StatefulWidget {
  final SizingInformation sizingInformation;

  const InstantCarouselSlider({Key? key, required this.sizingInformation}) : super(key: key);

  @override
  _SliderState createState() => _SliderState(sizingInformation:this.sizingInformation);
}

class _SliderState extends State<InstantCarouselSlider> {
  int _sliderIndex = 0;
  final SizingInformation sizingInformation;
  _SliderState({required this.sizingInformation});


  @override
  Widget build(BuildContext context) {
    return _buildSliderWidgetCard();
  }

  Widget _buildSliderWidgetCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 260.0,
            aspectRatio: 0.10,
            viewportFraction: 2.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _sliderIndex = index;
              });
            },
          ),
          items: FakeRepository.sliderData.map((sliderData) {
            return _buildSliderItem(sliderData);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSliderItem(SliderDataModel sliderData) {
    return Builder(
      builder: (_) {
        return InkWell(
          onTap: () {
            // Handle onTap event
          },
          child: Card(
            child: Column(
              children: <Widget>[
                _buildImageStack(sliderData),
                _buildRatingRow(sliderData),
                _buildTitleRow(sliderData),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageStack(SliderDataModel sliderData) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          height: 190,
          width: sizingInformation.screenSize.width,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              sliderData.sliderImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 18,
          child: _buildRatingContainer(sliderData),
        ),
        Positioned(
          right: 18,
          bottom: 0,
          left: 18,
          child: _buildPageIndicator(),
        ),
      ],
    );
  }

  Widget _buildRatingContainer(SliderDataModel sliderData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.star,
            color: Colors.red,
          ),
          Text(
            sliderData.rating,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 135),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: FakeRepository.sliderData.map((sliderData) {
          return Container(
            height: 7.0,
            width: 7.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _sliderIndex == FakeRepository.sliderData.indexOf(sliderData)
                  ? Colors.red
                  : Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingRow(SliderDataModel sliderData) {
    return Positioned(
      right: 18,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.star,
              color: Colors.red,
            ),
            Text(
              sliderData.rating,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(SliderDataModel sliderData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15),
          Container(
            width: sizingInformation.localWidgetSize.width * 0.80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  sliderData.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      sliderData.totalStar,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(width: 5),
                    const Text("star")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
