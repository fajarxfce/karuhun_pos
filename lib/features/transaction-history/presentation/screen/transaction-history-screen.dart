import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi'), elevation: 2),
      body: const TransactionHistoryView(),
    );
  }
}

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final transactions = [
      {
        'id': 'TXN001',
        'date': '2024-01-15',
        'total': 150000,
        'items': 3,
        'customer': 'Pelanggan Umum',
      },
      {
        'id': 'TXN002',
        'date': '2024-01-15',
        'total': 275000,
        'items': 5,
        'customer': 'John Doe',
      },
      {
        'id': 'TXN003',
        'date': '2024-01-14',
        'total': 95000,
        'items': 2,
        'customer': 'Jane Smith',
      },
      // add more data
      {
        'id': 'TXN004',
        'date': '2024-01-13',
        'total': 120000,
        'items': 4,
        'customer': 'Alice Johnson',
      },
      {
        'id': 'TXN005',
        'date': '2024-01-12',
        'total': 300000,
        'items': 6,
        'customer': 'Bob Brown',
      },
      // more 10 data
      {
        'id': 'TXN006',
        'date': '2024-01-11',
        'total': 450000,
        'items': 8,
        'customer': 'Charlie Davis',
      },
      {
        'id': 'TXN007',
        'date': '2024-01-10',
        'total': 60000,
        'items': 1,
        'customer': 'Diana Evans',
      },
      {
        'id': 'TXN008',
        'date': '2024-01-09',
        'total': 250000,
        'items': 3,
        'customer': 'Ethan Foster',
      },
      {
        'id': 'TXN009',
        'date': '2024-01-08',
        'total': 80000,
        'items': 2,
        'customer': 'Fiona Green',
      },
      {
        'id': 'TXN010',
        'date': '2024-01-07',
        'total': 120000,
        'items': 4,
        'customer': 'George Harris',
      },
      {
        'id': 'TXN011',
        'date': '2024-01-06',
        'total': 300000,
        'items': 6,
        'customer': 'Hannah Johnson',
      },
      {
        'id': 'TXN012',
        'date': '2024-01-05',
        'total': 150000,
        'items': 3,
        'customer': 'Ian King',
      },
      {
        'id': 'TXN013',
        'date': '2024-01-04',
        'total': 275000,
        'items': 5,
        'customer': 'Jane Lee',
      },
      {
        'id': 'TXN014',
        'date': '2024-01-03',
        'total': 95000,
        'items': 2,
        'customer': 'Kevin Miller',
      },
      {
        'id': 'TXN015',
        'date': '2024-01-02',
        'total': 120000,
        'items': 4,
        'customer': 'Laura Wilson',
      },
    ];

    return Column(
      children: [
        // Summary Cards
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Transaksi',
                  value: '${transactions.length}',
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Pendapatan',
                  value:
                      'Rp ${_formatCurrency(transactions.fold<int>(0, (sum, t) => sum + (t['total'] as int)))}',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),

        // Filter Section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // TODO: Implement filter
                },
                icon: const Icon(Icons.filter_list),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Transaction List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt, color: Colors.green),
        ),
        title: Row(
          children: [
            Text(
              transaction['id'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            Text(
              'Rp ${_formatCurrency(transaction['total'])}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Pelanggan: ${transaction['customer']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  transaction['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.shopping_cart, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${transaction['items']} item',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to transaction detail
        },
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
