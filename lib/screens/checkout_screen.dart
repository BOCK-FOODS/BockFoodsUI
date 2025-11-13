import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bock_foods/providers/cart_provider.dart';
import 'package:bock_foods/providers/instamart_cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Address selection
  String? _selectedAddress;
  final List<Map<String, String>> _savedAddresses = [
    {
      'label': 'Home',
      'address': 'B- Block, Flat No. 305, Krishna Kuteer Phase 2 Road, 3G Homes Crimson Layout, Chansandra, Bangalore, Karnataka 560067',
      'time': '15 MINS'
    },
  ];
  
  // Payment method
  String _paymentMethod = 'cod';
  bool _noContactDelivery = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _expandStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  bool _isStepComplete(int step) {
    switch (step) {
      case 0:
        return _phoneController.text.isNotEmpty && 
               _nameController.text.isNotEmpty && 
               _emailController.text.isNotEmpty;
      case 1:
        return _selectedAddress != null;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _handleContinue() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      if (_selectedAddress != null) {
        setState(() {
          _currentStep = 2;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a delivery address')),
        );
      }
    } else if (_currentStep == 2) {
      _showOrderConfirmation();
    }
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text('Your order has been placed successfully. Pay cash on delivery.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodCart = Provider.of<FoodCartProvider>(context);
    final instamartCart = Provider.of<InstamartCartProvider>(context);
    final isWeb = MediaQuery.of(context).size.width > 900;
    final double cartWidth = isWeb ? MediaQuery.of(context).size.width * 0.75 : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('SECURE CHECKOUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.black),
            label: const Text('Help', style: TextStyle(color: Colors.black)),
          ),
          if (!isWeb) const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          width: cartWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Checkout steps
              Expanded(
                flex: isWeb ? 6 : 10,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStepCard(
                        step: 0,
                        icon: Icons.person_outline,
                        title: 'Account',
                        subtitle: 'To place your order now, log in to your existing account or sign up.',
                        content: _buildAccountForm(),
                      ),
                      const SizedBox(height: 16),
                      _buildStepCard(
                        step: 1,
                        icon: Icons.location_on_outlined,
                        title: 'Delivery address',
                        subtitle: _selectedAddress ?? '',
                        content: _buildAddressSelection(),
                        enabled: _isStepComplete(0),
                      ),
                      const SizedBox(height: 16),
                      _buildStepCard(
                        step: 2,
                        icon: Icons.payment_outlined,
                        title: 'Payment',
                        subtitle: '',
                        content: _buildPaymentSelection(),
                        enabled: _isStepComplete(1),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right side - Order summary (only on web)
              if (isWeb)
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: _buildOrderSummary(foodCart, instamartCart),
                  ),
                ),
            ],
          ),
        ),
      ),
      // Bottom summary for mobile
      bottomNavigationBar: !isWeb ? _buildMobileBottomBar(foodCart, instamartCart) : null,
    );
  }

  Widget _buildStepCard({
    required int step,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
    bool enabled = true,
  }) {
    final isExpanded = _currentStep == step;
    final isComplete = _isStepComplete(step);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: enabled ? () => _expandStep(step) : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isComplete ? const Color(0xFF27A600) : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isComplete ? Icons.check : icon,
                      color: isComplete ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle.isNotEmpty && !isExpanded)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (isComplete && !isExpanded)
                    TextButton(
                      onPressed: () => _expandStep(step),
                      child: const Text(
                        'CHANGE',
                        style: TextStyle(color: Color(0xFFFF6B35)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildAccountForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign up or log in to your account',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Have a referral code?'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27A600),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text('CONTINUE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By creating an account, I accept the Terms & Conditions & Privacy Policy',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You have a saved address in this location',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ..._savedAddresses.map((addr) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedAddress == addr['address'] 
                ? const Color(0xFF27A600) 
                : Colors.grey.shade300,
              width: _selectedAddress == addr['address'] ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAddress = addr['address'];
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        addr['label']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    addr['address']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    addr['time']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedAddress == addr['address'])
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27A600),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('DELIVER HERE'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        )).toList(),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            // Add new address functionality
          },
          icon: const Icon(Icons.add),
          label: const Text('ADD NEW ADDRESS'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF27A600),
            side: const BorderSide(color: Color(0xFF27A600)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose payment method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioListTile<String>(
          value: 'cod',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
          title: const Text('Cash on Delivery'),
          activeColor: const Color(0xFF27A600),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27A600),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text('PROCEED TO PAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(FoodCartProvider foodCart, InstamartCartProvider instamartCart) {
    final total = foodCart.subtotal + instamartCart.subtotal + 20;
    
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Restaurant info
            if (foodCart.items.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.restaurant, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant Order',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Central Bangalore',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
            ],
            
            // Cart items
            ...foodCart.items.values.map((ci) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF27A600), width: 2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ci.item.name, style: const TextStyle(fontSize: 14)),
                        if (ci.qty > 1)
                          Text(
                            'Qty: ${ci.qty}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  Text('₹${(ci.item.price * ci.qty).toStringAsFixed(0)}'),
                ],
              ),
            )).toList(),
            
            ...instamartCart.items.values.map((ci) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF27A600), width: 2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ci.item.name, style: const TextStyle(fontSize: 14)),
                        if (ci.qty > 1)
                          Text(
                            'Qty: ${ci.qty}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  Text('₹${(ci.item.price * ci.qty).toStringAsFixed(0)}'),
                ],
              ),
            )).toList(),
            
            const SizedBox(height: 8),
            const Text(
              '💬 Any suggestions? We will pass it on...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            
            const Divider(height: 32),
            
            // No-contact delivery option
            CheckboxListTile(
              value: _noContactDelivery,
              onChanged: (value) {
                setState(() {
                  _noContactDelivery = value!;
                });
              },
              title: const Text(
                'Opt in for No-contact Delivery',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Unwell, or avoiding contact? Please select no-contact delivery. Partner will safely place the order outside your door (not for COD)',
                style: TextStyle(fontSize: 11),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFF27A600),
            ),
            
            const Divider(height: 24),
            
            // Apply Coupon
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.local_offer_outlined),
              label: const Text('Apply Coupon'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Bill Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            
            _buildBillRow('Item Total', '₹${(foodCart.subtotal + instamartCart.subtotal).toStringAsFixed(0)}'),
            if (foodCart.subtotal > 0)
              _buildBillRow('Food total', '₹${foodCart.subtotal.toStringAsFixed(0)}', isSubItem: true),
            if (instamartCart.subtotal > 0)
              _buildBillRow('Instamart total', '₹${instamartCart.subtotal.toStringAsFixed(0)}', isSubItem: true),
            _buildBillRow('Delivery Fee | 3.0 kms', '₹20'),
            _buildBillRow('GST & Other Charges', '₹${(total * 0.05).toStringAsFixed(2)}'),
            
            const Divider(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TO PAY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₹${(total + total * 0.05).toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review your order and address details to avoid cancellations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Note: Please ensure your address and order details are correct. This order, if cancelled, is non-refundable.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isSubItem = false}) {
    return Padding(
      padding: EdgeInsets.only(left: isSubItem ? 16 : 0, top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSubItem ? 12 : 14,
              color: isSubItem ? Colors.grey.shade600 : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isSubItem ? 12 : 14,
              color: isSubItem ? Colors.grey.shade600 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar(FoodCartProvider foodCart, InstamartCartProvider instamartCart) {
    final total = (foodCart.subtotal + instamartCart.subtotal + 20) * 1.05;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TO PAY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _currentStep == 2 ? _handleContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27A600),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  _currentStep == 2 ? 'PROCEED' : 'Complete checkout steps',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}