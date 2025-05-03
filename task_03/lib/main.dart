import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

// ================== MODEL ==================
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final List<Color> gradientColors;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 4.5,
    required this.gradientColors,
  });
}

// ================== CONTROLLER ==================
class CartController extends GetxController {
  var cartItems = <Product, int>{}.obs;
  var isLoading = false.obs;

  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    Get.snackbar(
      "Added to Cart",
      "${product.name} was added!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal.withOpacity(0.9),
      colorText: Colors.white,
      duration: Duration(seconds: 1),
    );
  }

  void removeFromCart(Product product) {
    if (cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
    } else {
      cartItems.remove(product);
      Get.snackbar(
        "Removed",
        "${product.name} was removed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    }
  }

  void clearCart() {
    cartItems.clear();
    Get.snackbar("Cart Cleared", "All items removed",
        snackPosition: SnackPosition.BOTTOM);
  }

  double get totalPrice => cartItems.entries.fold(
      0, (sum, item) => sum + (item.key.price * item.value));

  int get totalItems => cartItems.values.fold(0, (sum, qty) => sum + qty);
}

// ================== MAIN APP ==================
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibrant Cart',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal[800],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.teal[800],
        ),
      ),
      home: ProductListScreen(),
      getPages: [
        GetPage(name: '/', page: () => ProductListScreen()),
        GetPage(name: '/cart', page: () => CartScreen()),
        GetPage(name: '/product', page: () => ProductDetailScreen()),
      ],
    );
  }
}

// ================== PRODUCT LIST SCREEN ==================
class ProductListScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium noise-cancelling headphones with 30hr battery life',
      price: 199.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
      rating: 4.8,
      gradientColors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Fitness tracker with heart rate monitor',
      price: 159.99,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
      rating: 4.5,
      gradientColors: [Color(0xFF0F2027), Color(0xFF2C5364)],
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      description: 'Portable waterproof speaker with deep bass',
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb',
      rating: 4.3,
      gradientColors: [Color(0xFFED213A), Color(0xFF93291E)],
    ),
    Product(
      id: '4',
      name: 'Gaming Keyboard',
      description: 'Mechanical RGB keyboard with anti-ghosting',
      price: 129.99,
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3',
      rating: 4.7,
      gradientColors: [Color(0xFF614385), Color(0xFF516395)],
    ),
    Product(
      id: '5',
      name: 'Wireless Earbuds',
      description: 'True wireless earbuds with charging case',
      price: 79.99,
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df',
      rating: 4.2,
      gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    Product(
      id: '6',
      name: 'External SSD',
      description: '1TB portable SSD with USB-C connectivity',
      price: 149.99,
      imageUrl: 'https://images.unsplash.com/photo-1591488320449-011701bb6704',
      rating: 4.9,
      gradientColors: [Color(0xFFFDC830), Color(0xFFF37335)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Get.toNamed('/cart'),
              ),
              Obx(() => cartController.cartItems.isEmpty
                  ? SizedBox()
                  : Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${cartController.totalItems}',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => Get.toNamed('/product', arguments: product),
              child: Hero(
                tag: 'product_${product.id}',
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text('${product.rating}'),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_shopping_cart, size: 20),
                                  onPressed: () =>
                                      cartController.addToCart(product),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================== PRODUCT DETAIL SCREEN ==================
class ProductDetailScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'product_${product.id}',
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: product.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(product.imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('${product.rating} (1,234 reviews)'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        cartController.addToCart(product);
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== CART SCREEN ==================
class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: [
          Obx(() => cartController.cartItems.isEmpty
              ? SizedBox()
              : IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => cartController.clearCart(),
          )),
        ],
      ),
      body: Obx(
            () => cartController.cartItems.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/empty_cart.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Browse our products and add some items',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Continue Shopping'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product =
                  cartController.cartItems.keys.elementAt(index);
                  final quantity = cartController.cartItems[product]!;
                  return Dismissible(
                    key: Key(product.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) =>
                        cartController.removeFromCart(product),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '\$${product.price.toStringAsFixed(2)} each'),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      size: 20),
                                  onPressed: () =>
                                      cartController.removeFromCart(
                                          product),
                                ),
                                Text('$quantity',
                                    style: TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline,
                                      size: 20),
                                  onPressed: () =>
                                      cartController.addToCart(product),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\$${(product.price * quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\$${cartController.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\$5.99',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${(cartController.totalPrice + 5.99).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'Order Placed!',
                          'Your order has been successfully placed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.teal,
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                        );
                        cartController.clearCart();
                      },
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}