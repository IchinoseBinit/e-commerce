import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/Cart.dart' as cartCheckout;

class CheckoutAttributes extends StatefulWidget {
  final cartCheckout.CheckoutAttributes checkoutAttributes;

  CheckoutAttributes(this.checkoutAttributes);

  @override
  _CheckoutAttributesState createState() => _CheckoutAttributesState();
}

class _CheckoutAttributesState extends State<CheckoutAttributes> {
  cartCheckout.CheckoutDropDown? _choosedValue;

  List<DropdownMenuItem<cartCheckout.CheckoutDropDown>>? _checkoutAttributes;

  @override
  initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    _checkoutAttributes = getDropDownMenuItems(widget.checkoutAttributes);
    _choosedValue = widget.checkoutAttributes.checkoutDropDownList[0];
    super.didChangeDependencies();
  }

  List<DropdownMenuItem<cartCheckout.CheckoutDropDown>> getDropDownMenuItems(
      cartCheckout.CheckoutAttributes _list) {
    List<DropdownMenuItem<cartCheckout.CheckoutDropDown>> items = [];
    for (var eachOption in _list.checkoutDropDownList) {
      items.add(
        new DropdownMenuItem(
          value: eachOption,
          child: Text(
            eachOption.name!,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.checkoutAttributes.name!,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline4!.color,
            fontSize: 18,
          ),
        ),
        Spacer(),
        DropdownButton<cartCheckout.CheckoutDropDown>(
          items: _checkoutAttributes,
          value: _choosedValue,
          style: Theme.of(context).textTheme.headline4,
          onChanged: (value) {
            setState(
              () {
                _choosedValue = value;
                Provider.of<cartCheckout.CartProvider>(context, listen: false)
                    .updateAttributes(widget.checkoutAttributes.id, value!.id);
              },
            );
          },
        )
      ],
    );
  }
}
