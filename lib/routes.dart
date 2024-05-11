import 'package:e_commerce_app/screens/app_details/app_details.dart';
import 'package:e_commerce_app/screens/category/category.dart';
import 'package:e_commerce_app/screens/color_screen/color_screen.dart';
import 'package:e_commerce_app/screens/home_products_list/products_list.dart';
import 'package:e_commerce_app/screens/news_blogs/news_blogs.dart';
import 'package:e_commerce_app/screens/order_details/order_details_screen.dart';
import 'package:e_commerce_app/screens/orders/order_screen.dart';
import 'package:e_commerce_app/screens/payment/payment.dart';
import 'package:e_commerce_app/screens/payment_method/payment_method_screen.dart';
import 'package:e_commerce_app/screens/pick_up_point/pick_up_point.dart';
import 'package:e_commerce_app/screens/qr_code/qr_code.dart';
import 'package:e_commerce_app/screens/reviews.dart/reviews.dart';
import 'package:e_commerce_app/screens/address/address.dart';
import 'package:e_commerce_app/screens/address/components/address_form.dart';
import 'package:e_commerce_app/screens/settings/components/country.dart';
import 'package:e_commerce_app/screens/settings/components/currency.dart';
import 'package:e_commerce_app/screens/settings/components/password_screen.dart';
import 'package:e_commerce_app/screens/settings/components/theme_screen.dart';
import 'package:e_commerce_app/screens/settings/setting_screen.dart';
import 'package:e_commerce_app/screens/shipping_address/shipping_address_screen.dart';
import 'package:e_commerce_app/screens/shipping_method/shipping_method_screen.dart';
import 'package:e_commerce_app/screens/splash/splash_loading.dart';
import 'package:e_commerce_app/screens/state_province/state_screen.dart';
import 'package:e_commerce_app/screens/user_details/user_detail.dart';
import 'package:e_commerce_app/screens/user_details/user_display.dart';
import 'package:e_commerce_app/screens/wish_list/wish_list.dart';
import 'package:flutter/widgets.dart';

import 'package:e_commerce_app/screens/checkout/checkout.dart';
import 'package:e_commerce_app/screens/invoice/invoice.dart';
import 'package:e_commerce_app/screens/profile/components/help.dart';
import 'package:e_commerce_app/screens/cart/cart_screen.dart';
import 'package:e_commerce_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:e_commerce_app/screens/details/details_screen.dart';
import 'package:e_commerce_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/login_success/login_success_screen.dart';
import 'package:e_commerce_app/screens/otp/otp_screen.dart';
import 'package:e_commerce_app/screens/profile/profile_screen.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/screens/splash/splash_screen.dart';
import 'package:e_commerce_app/screens/display_products/display.dart';
import 'package:e_commerce_app/screens/notifications/notification.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  HelpScreen.routeName: (context) => HelpScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  InvoiceScreen.routeName: (context) => InvoiceScreen(),
  DisplayScreen.routeName: (context) => DisplayScreen(),
  UserDetailScreen.routeName: (context) => UserDetailScreen(),
  ReviewScreen.routeName: (context) => ReviewScreen(),
  AddressScreen.routeName: (context) => AddressScreen(),
  SettingScreen.routeName: (context) => SettingScreen(),
  AddressFormScreen.routeName: (context) => AddressFormScreen(),
  CountryScreen.routeName: (context) => CountryScreen(),
  CurrencyScreen.routeName: (context) => CurrencyScreen(),
  // PaymentScreen.routeName: (context) => PaymentScreen(),
  QrCodeScreen.routeName: (context) => QrCodeScreen(),
  WishListScreen.routeName: (context) => WishListScreen(),
  ShippingAddressFormScreen.routeName: (context) => ShippingAddressFormScreen(),
  ShippingMethodScreen.routeName: (context) => ShippingMethodScreen(),
  PaymentMethodScreen.routeName: (context) => PaymentMethodScreen(),
  StateScreen.routeName: (context) => StateScreen(),
  PickUpPointScreen.routeName: (context) => PickUpPointScreen(),
  ColorScreen.routeName: (context) => ColorScreen(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  ProductListScreen.routeName: (context) => ProductListScreen(),
  AppDetailsScreen.routeName: (context) => AppDetailsScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
  OrderDetailsScreen.routeName: (context) => OrderDetailsScreen(),
  NewsBlogsScreen.routeName: (context) => NewsBlogsScreen(),
  SplashLoadingScreen.routeName: (context) => SplashLoadingScreen(),
  UserDisplayScreen.routeName: (context) => UserDisplayScreen(),
  ThemeScreen.routeName: (context) => ThemeScreen(),
  PasswordScreen.routeName: (context) => PasswordScreen(),
};
