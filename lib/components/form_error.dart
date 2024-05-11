import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length,
          (index) => formErrorText(error: errors[index]!, context: context)),
    );
  }

  Padding formErrorText(
      {required String error, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 4,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/Error.svg",
            height: getProportionateScreenWidth(18),
            width: getProportionateScreenWidth(18),
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                  color: Theme.of(context).textTheme.headline4!.color,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
