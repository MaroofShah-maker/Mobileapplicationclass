import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../models/food_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Cart: maps food name -> quantity
  final Map<String, int> cart = {};
  int selectedIndex = 0;

  void addToCart(FoodItem item) {
    setState(() {
      cart[item.name] = (cart[item.name] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void removeFromCart(FoodItem item) {
    setState(() {
      if (cart.containsKey(item.name)) {
        if (cart[item.name]! > 1) {
          cart[item.name] = cart[item.name]! - 1;
        } else {
          cart.remove(item.name);
        }
      }
    });
  }

  double get totalPrice {
    double total = 0;
    for (var item in menuItems) {
      if (cart.containsKey(item.name)) {
        total += item.price * cart[item.name]!;
      }
    }
    return total;
  }

  int get totalItems => cart.values.fold(0, (sum, qty) => sum + qty);

  void showCart() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🛒 Your Cart',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(child: Text('Your cart is empty'))
                        : ListView(
                            children: cart.entries.map((entry) {
                              final item = menuItems.firstWhere(
                                (m) => m.name == entry.key,
                              );
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(item.name),
                                subtitle: Text(
                                  '\$${item.price.toStringAsFixed(2)} x ${entry.value}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        removeFromCart(item);
                                        setModalState(() {});
                                        setState(() {});
                                      },
                                    ),
                                    Text('${entry.value}'),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        addToCart(item);
                                        setModalState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cart.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Order placed successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() => cart.clear());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍽️ Restaurant Menu'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: showCart,
              ),
              if (totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // === LEFT SIDE: Category List ===
          Container(
            width: 110,
            color: Colors.white,
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepOrange.shade50
                          : Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? Colors.deepOrange
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Icon(Icons.fastfood),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // === RIGHT SIDE: Selected Item Details ===
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      menuItems[selectedIndex].imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Chip
                  Chip(
                    label: Text(menuItems[selectedIndex].category),
                    backgroundColor: Colors.deepOrange.shade50,
                    labelStyle: const TextStyle(color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),
                  // Name
                  Text(
                    menuItems[selectedIndex].name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    menuItems[selectedIndex].description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  // Rating Row
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.5 (120 reviews)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Price + Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '\$${menuItems[selectedIndex].price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => addToCart(menuItems[selectedIndex]),
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Quantity controls if item is in cart
                  if (cart.containsKey(menuItems[selectedIndex].name))
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'In your cart:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    removeFromCart(menuItems[selectedIndex]),
                              ),
                              Text(
                                '${cart[menuItems[selectedIndex].name]}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    addToCart(menuItems[selectedIndex]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  // "Other items" section
                  const Text(
                    'Other Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 120,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
