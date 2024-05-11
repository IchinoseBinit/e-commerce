import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';

import 'package:e_commerce_app/urls.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  ApiCalls apiCalls = new ApiCalls();

  fetchOrders() async {
    if (_orders.isNotEmpty) {
      _orders.clear();
    }
    final response = await apiCalls.fetchData(url: fetchOrdersUrl);
    final listOfOrders = response['Orders'];

    for (var eachOrder in listOfOrders) {
      _orders.add(Order.fromMap(eachOrder));
    }
    _orders[0].selected = true;
  }

  fetchOrderProducts(BuildContext context) async {
    if (getSelectedOrder()!.orderProducts.isNotEmpty) {
      getSelectedOrder()!.orderProducts.clear();
    }
    final orderId = getSelectedOrder()!.id;
    final url = '$fetchOrderProductsUrl?orderId=$orderId';
    final response = await apiCalls.fetchData(url: url);
    final listOfProducts = response['Items'];
    for (var eachProduct in listOfProducts) {
      final productId = eachProduct['ProductId'];
      final urlForEachProduct = '$fetchProductUrl/$productId';
      print(urlForEachProduct);
      final productResponse = await apiCalls.fetchData(url: urlForEachProduct);
      print(response);
      final product = await Provider.of<Products>(context, listen: false)
          .addEachProduct(context, productResponse);
      OrderProduct orderProduct =
          OrderProduct.fromOrderMap(eachProduct, product);
      getSelectedOrder()!.orderProducts.add(orderProduct);
    }
    notifyListeners();
    // print();
  }

  Order? getSelectedOrder() {
    Order? selectedOrder =
        _orders.firstWhereOrNull((order) => order.selected == true);
    return selectedOrder;
  }

  void selectOrder(BuildContext context, String? orderId) async {
    Order? oldSelectedOrder = getSelectedOrder();
    if (oldSelectedOrder != null) {
      oldSelectedOrder.selected = false;
    }
    final selectedOrder =
        _orders.firstWhereOrNull((oldOrder) => oldOrder.id == orderId);
    if (selectedOrder != null) {
      selectedOrder.selected = true;

      notifyListeners();
    }
  }
}

class Order {
  String? id;
  late String orderTotal;
  late String orderStatus;
  late String paymentStatus;
  late String shippingStatus;
  int? orderNumber;
  String? orderCode;
  String? customerEmail;
  late List<OrderProduct> orderProducts;
  bool? selected;

  Order.fromMap(dynamic obj) {
    this.id = obj['Id'].toString();
    this.orderTotal = obj['OrderTotal'].toString();
    this.orderStatus = obj['OrderStatus'].toString();
    this.paymentStatus = obj['PaymentStatus'].toString();
    this.shippingStatus = obj['ShippingStatus'].toString();
    this.orderNumber = obj['OrderNumber'].toInt();
    this.orderCode = obj['OrderCode'].toString();
    this.customerEmail = obj['CustomerEmail'].toString();
    this.orderProducts = [];
    this.selected = false;
  }
}

class OrderProduct {
  String? id;
  late String title;
  double? unitPrice;
  late String subTotal;
  int? quantity;
  Product? product;

  OrderProduct.fromOrderMap(dynamic obj, Product prod) {
    this.id = obj['ProductId'].toString();
    this.title = obj['ProductName'].toString();
    this.unitPrice = obj['UnitPriceValue'].toDouble();
    this.subTotal = obj['SubTotal'].toString();
    this.quantity = obj['Quantity'].toInt();
    this.product = prod;
  }
}
