import 'package:flutter/material.dart';
import 'package:e_commerce_app/components/rounded_icon_btn.dart';
import 'package:e_commerce_app/providers/Product.dart';

import '../../../size_config.dart';

typedef void IntCallback(int quantity);

class ColorDots extends StatefulWidget {
  const ColorDots({
    Key? key,
    required this.product,
    required this.onQuantityChanged,
  }) : super(key: key);

  final Product product;
  final IntCallback onQuantityChanged;
  // int quantity;

  @override
  _ColorDotsState createState() => _ColorDotsState();
}

class _ColorDotsState extends State<ColorDots> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedIconBtn(
            icon: Icons.remove,
            press: () {
              setState(() {
                if (quantity > 1) {
                  quantity = quantity - 1;
                  widget.onQuantityChanged(quantity);
                }
              });
            },
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(10),
              color: Theme.of(context).cardTheme.color,
              child: Text(
                "$quantity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).appBarTheme.textTheme!.headline6!.color,
                ),
              ),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: () {
              setState(() {
                quantity = quantity + 1;
                widget.onQuantityChanged(quantity);
              });
            },
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key? key,
    required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: isSelected
                ? Theme.of(context).buttonColor
                : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
