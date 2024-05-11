import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
    required this.productKey,
  }) : super(key: key);

  final Product? product;
  final ValueKey productKey;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(
      //   horizontal: 5,
      // ),
      height: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenHeight! * 0.6
          : SizeConfig.screenHeight! * 0.40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).buttonColor.withOpacity(0.8),
            Theme.of(context).buttonColor.withOpacity(0.4)
          ],
        ),
      ),
      // Theme.of(context).buttonColor.withOpacity(0.75),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Theme.of(context).cardTheme.color,
              ),
              height: SizeConfig.orientation == Orientation.landscape
                  ? getProportionateScreenHeight(200)
                  : getProportionateScreenHeight(160),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...List.generate(widget.product!.images!.length,
                      (index) => buildSmallDots(index)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(double.infinity),
            child: Hero(
              tag: '${widget.productKey}',
              child: CarouselSlider(
                options: CarouselOptions(
                    // autoPlay: true,
                    // height: 200,
                    // enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction:
                        widget.product!.images!.length > 1 ? 0.6 : 1,
                    aspectRatio: 1.2,
                    initialPage: 0,
                    autoPlayInterval: Duration(
                      seconds: 3,
                    ),
                    autoPlayCurve: Curves.easeIn,
                    autoPlayAnimationDuration: Duration(
                      milliseconds: 1200,
                    ),
                    // disableCenter: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) {
                      changePic(index);
                    }),

                items: List.generate(
                  widget.product!.images!.length,
                  (index) => buildImage(index),
                ),
                // widget.product.images.asMap((index) => buildImage(widget.product.images[index]))/
              ),
            ),
          ),
          // SizedBox(height: getProportionateScreenWidth(20)),
        ],
      ),
    );
  }

  buildImage(int index) {
    return widget.product!.images!.isEmpty
        ? Center(
            child: Text(
              "Image Here",
              style: TextStyle(fontSize: 24),
            ),
          )
        : Image.memory(
            widget.product!.images![index]!,
            fit: BoxFit.fitWidth,
            // check here
          );
  }

  abuildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onPanUpdate: ((dis) {
          if (dis.delta.dx > 0) {
            //User swiped from left to right
            if (selectedImage > 0) {
              changePic(selectedImage - 1);
            }
            // here write the code to open drawer
          } else if (dis.delta.dx < 0) {
            //User swiped from right to left
            changePic(selectedImage + 1);
          }
        }),
        child: Hero(
          tag: widget.product!.id.toString(),
          child: widget.product!.images!.isEmpty
              ? Center(
                  child: Text(
                    "Image Here",
                    style: TextStyle(fontSize: 24),
                  ),
                )
              : Image.memory(
                  widget.product!.images![selectedImage]!,
                  fit: BoxFit.fill,
                  // check here
                ),
        ),
      ),
    );
  }

  changePic(int index) {
    if (widget.product!.images!.length > index) {
      setState(() {
        selectedImage = index;
      });
    }
  }

  buildSmallDots(int index) {
    return AnimatedContainer(
      duration: defaultDuration,
      margin: EdgeInsets.only(
        top: SizeConfig.orientation == Orientation.landscape
            ? getProportionateScreenHeight(175)
            : getProportionateScreenHeight(140),
        right: 15,
        bottom: 0,
      ),
      padding: EdgeInsets.all(8),
      height: SizeConfig.orientation == Orientation.landscape
          ? getProportionateScreenHeight(20)
          : getProportionateScreenWidth(10),
      width: SizeConfig.orientation == Orientation.landscape
          ? selectedImage == index
              ? getProportionateScreenHeight(42)
              : getProportionateScreenHeight(20)
          : selectedImage == index
              ? getProportionateScreenHeight(22)
              : getProportionateScreenWidth(10),
      decoration: BoxDecoration(
        color: selectedImage == index
            ? Theme.of(context).buttonColor
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).buttonColor,
        ),
      ),
      // child: ,
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        changePic(index);
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(
          right: 15,
          bottom: 10,
        ),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context)
                  .buttonColor
                  .withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.memory(widget.product!.images![index]!),
      ),
    );
  }
}
