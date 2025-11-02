import 'package:flutter/material.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customers = List.generate(20, (i) => {
      'id': '#C${1000 + i}',
      'name': 'Customer ${i + 1}',
      'email': 'customer${i + 1}@example.com',
      'orders': 1 + (i % 5),
    });

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: const Text(
            'Customers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Orders')),
                ],
                rows: customers.map((c) => DataRow(cells: [
                  DataCell(Text(c['id'] as String)),
                  DataCell(Text(c['name'] as String)),
                  DataCell(Text(c['email'] as String)),
                  DataCell(Text('${c['orders']}')),
                ])).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}