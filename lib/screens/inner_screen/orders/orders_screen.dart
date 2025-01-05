import 'package:adoptsmart_admin_en/models/orders_model.dart';
import 'package:adoptsmart_admin_en/providers/orders.provider.dart';
import 'package:adoptsmart_admin_en/widgets/orders_widget.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/empty_bag.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late TextEditingController searchTextController;
  List<OrderModel> orderListSearch = [];

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body: StreamBuilder<List<OrderModel>>(
          stream: ordersProvider.fetchOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(snapshot.error.toString()),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No orders found"),
              );
            }

            final ordersList = snapshot.data!;
            
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      hintText: "Search orders",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          searchTextController.clear();
                          setState(() {
                            orderListSearch.clear();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        orderListSearch = ordersProvider.searchQuery(
                          searchText: searchTextController.text,
                          passedList: ordersList,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  if (searchTextController.text.isNotEmpty &&
                      orderListSearch.isEmpty) ...[
                    const Center(
                      child: Text("No orders found"),
                    ),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchTextController.text.isNotEmpty
                          ? orderListSearch.length
                          : ordersList.length,
                      itemBuilder: (context, index) {
                        final order = searchTextController.text.isNotEmpty
                            ? orderListSearch[index]
                            : ordersList[index];
                        return OrderWidget(orderModel: order);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}