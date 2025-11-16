import 'package:flutter/material.dart';
import 'dart:math';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = List.generate(20, (i) => {
      'id': '#${10001 + i}',
      'customer': 'Customer ${Random().nextInt(100)}',
      'kitchen': 'Bock Foods ${['Koramangala', 'Indiranagar', 'Whitefield'][Random().nextInt(3)]}',
      'amount': (150 + Random().nextDouble() * 500).toStringAsFixed(2),
      'status': ['Pending', 'Preparing', 'Out for Delivery', 'Delivered'][Random().nextInt(4)],
      'date': '2025-02-${10 + Random().nextInt(15)}',
      'address': '${Random().nextInt(1000)} ${['Main St', 'Oak Ave', 'Elm Rd', 'Pine Lane', 'Maple Dr'][Random().nextInt(5)]}, Bangalore',
      'phone': '+91 ${9800000000 + Random().nextInt(1000000)}',
    });

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: const Text(
            'Orders Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Kitchen')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Date')),
                ],
                rows: orders.map((order) => DataRow(
                  cells: [
                    DataCell(Text(order['id'] as String)),
                    DataCell(Text(order['customer'] as String)),
                    DataCell(Text(order['kitchen'] as String)),
                    DataCell(Text('₹${order['amount']}')),
                    DataCell(Text(order['address'] as String)),
                    DataCell(Text(order['phone'] as String)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order['status'] as String),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order['status'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(Text(order['date'] as String)),
                  ],
                )).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Preparing':
        return Colors.blue;
      case 'Out for Delivery':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}