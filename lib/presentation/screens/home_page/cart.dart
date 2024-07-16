import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_sources/sqlite.dart';
import '../auth/login/login_imports.dart';
import '/presentation/screens/home_page/add_to_cart.dart';
import '/presentation/screens/home_page/oder_history.dart';
import '../../../core/constants/my_colors.dart';
import '../../../data/models/cart_model.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CartBloc cartBloc;
  late final DataBaseHelper dataBaseHelper;

  // late int userId;

  @override
  void initState() {
    dataBaseHelper = DataBaseHelper();
    cartBloc = context.read<CartBloc>();

    _initUser();
    super.initState();
  }

  void _initUser() async {
    setState(() {
      cartBloc.add(FetchCartItemEvent(userId: widget.userId));
    });
  }

  final searchController = TextEditingController();
  final productController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        actions: [
          // const SizedBox(width: 10),
          //  GestureDetector(
          //    onTap: () {
          //      Navigator.push(
          //        context,
          //        MaterialPageRoute(
          //          builder: (context) => OrderHistoryScreen(userId: widget.userId),
          //        ),
          //      );
          //    },
          //    child: const Icon(
          //      Icons.history,
          //      color: Colors.black,
          //    ),
          //  ),
          // const SizedBox(width: 10),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AddToCartScreen(userId: widget.userId),
          //       ),
          //     );
          //   },
          //   child: const Icon(
          //     Icons.shopping_cart,
          //     color: Colors.black,
          //   ),
          // ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
            },
            child: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    _filterItems(context, query);
                  },
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartScreenLoadedState) {
                    final items = state.cartItems;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(context, items[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('No items found.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddProductDialog();
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes min:$seconds seconds';
  }

  Widget _buildItemCard(BuildContext context, CartModel item) {
    (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(item.createdAt!)).inMinutes.remainder(60) >= 1 &&
            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(item.createdAt!)).inSeconds.remainder(60) >= 0)
        ? null
        : Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _formatDuration(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(item.createdAt!)));
            });
          });
    return Card(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      item.product,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      _formatDuration(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(item.createdAt!))),
                      style: TextStyle(fontSize: 15, color: MyColors.primaryColor),
                    ),
                  ],
                ),
                Text(item.description),
                // Text("₹ ${item.amount.toString()}"),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (item.id != null) {
                    cartBloc.add(CartItemDeleteEvent(item.id!, item.userId!));
                  }
                },
                child: const Icon(Icons.delete),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _showEditProductDialog(context, item);
                },
                child: const Icon(Icons.edit),
              ),
              // const SizedBox(width: 8),
              // GestureDetector(
              //   onTap: () {
              //     final cartItem = CartItemModel(
              //       userId: item.userId!,
              //       id: item.id ?? 0,
              //       product: item.product,
              //       description: item.description,
              //       amount: item.amount,
              //       quantity: 1,
              //       isSelected: true,
              //     );
              //     cartBloc.add(CartItemAddedOnClickedEvent(
              //         clickedItem: cartItem, userId: widget.userId));
              //   },
              //   child: const Icon(Icons.shopping_cart),
              // ),
              // const SizedBox(width: 8),
            ],
          )
        ],
      ),
    );
  }

  void _filterItems(BuildContext context, String query) {
    if (query.isEmpty) {
      cartBloc.add(FetchCartItemEvent(userId: widget.userId));
    } else {
      cartBloc.add(CartItemSearchEvent(query, widget.userId));
    }
  }

  void _showAddProductDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: const Text("Add a New TODO"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: productController, decoration: const InputDecoration(hintText: "Title")),
              TextField(controller: descriptionController, decoration: const InputDecoration(hintText: "Description")),
              // TextField(
              //     controller: amountController,
              //     decoration: const InputDecoration(hintText: "Amount")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (productController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Enter Title"),
                    backgroundColor: Colors.black,
                  ));
                } else if (descriptionController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Enter description"),
                    backgroundColor: Colors.black,
                  ));
                } else {
                  final newItem = CartModel(
                    product: productController.text,
                    description: descriptionController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                  );
                  productController.clear();
                  descriptionController.clear();
                  // amountController.clear();
                  cartBloc.add(AddCartItemEvent(items: newItem, userId: widget.userId));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, CartModel item) {
    TextEditingController productController = TextEditingController(text: item.product);
    TextEditingController descriptionController = TextEditingController(text: item.description);
    TextEditingController amountController = TextEditingController(text: item.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit TODO"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              // TextField(
              //   controller: amountController,
              //   decoration: const InputDecoration(hintText: 'Amount'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedItem = CartModel(
                  id: item.id,
                  product: productController.text,
                  description: descriptionController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                );
                cartBloc.add(
                  CartItemUpdateEvent(
                    userId: item.userId!,
                    id: item.id!,
                    product: updatedItem.product,
                    description: updatedItem.description,
                    amount: updatedItem.amount,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
