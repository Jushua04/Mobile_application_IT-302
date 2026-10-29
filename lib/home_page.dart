import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Search controller and query state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Debt records list
  List<Map<String, dynamic>> _debts = [
    {
      'id': '1',
      'name': 'Juan Dela Cruz',
      'note': 'Lunch treat last Friday',
      'dueDate': 'Sep 20, 2026',
      'amount': 500.00,
      'isPaid': false,
    },
    {
      'id': '2',
      'name': 'Maria Clara',
      'note': 'Grocery contribution',
      'dueDate': 'Sep 18, 2026',
      'amount': 1200.00,
      'isPaid': false,
    },
    {
      'id': '3',
      'name': 'Pedro Penduko',
      'note': 'Coffee & Snacks',
      'dueDate': 'Sep 10, 2026',
      'amount': 350.00,
      'isPaid': true,
    },
  ];

  // Calculated getters for total stats
  double get _totalUnpaid => _debts
      .where((d) => !d['isPaid'])
      .fold(0.0, (sum, item) => sum + (item['amount'] as double));

  double get _totalPaid => _debts
      .where((d) => d['isPaid'])
      .fold(0.0, (sum, item) => sum + (item['amount'] as double));

  int get _pendingCount => _debts.where((d) => !d['isPaid']).length;

  // Filtered debts computed dynamically based on search query
  List<Map<String, dynamic>> get _filteredDebts {
    if (_searchQuery.trim().isEmpty) {
      return _debts;
    }
    final query = _searchQuery.toLowerCase();
    return _debts.where((debt) {
      final name = (debt['name'] ?? '').toString().toLowerCase();
      final note = (debt['note'] ?? '').toString().toLowerCase();
      return name.contains(query) || note.contains(query);
    }).toList();
  }

  void _togglePaidStatus(String id) {
    setState(() {
      final index = _debts.indexWhere((debt) => debt['id'] == id);
      if (index != -1) {
        _debts[index]['isPaid'] = !_debts[index]['isPaid'];
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0F624C);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: _buildHeaderSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Unpaid Summary Card
            _buildSummaryCard(),
            const SizedBox(height: 24),

            // Section Header
            const Text(
              'Recent Debt Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F624C),
              ),
            ),
            const SizedBox(height: 12),

            // Filtered Debt Records List
            _filteredDebts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredDebts.length,
                    itemBuilder: (context, index) {
                      final debt = _filteredDebts[index];
                      return _buildDebtCard(debt);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to add new record
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Utang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Search Bar inside AppBar Header
  Widget _buildHeaderSearchBar() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search Kalimot Ka...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.white70, size: 16),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F624C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Unpaid Utang',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₱${_totalUnpaid.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.lightGreenAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Paid: ₱${_totalPaid.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.pending_actions,
                    color: Colors.amberAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_pendingCount Pending',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Record Card Widget
  Widget _buildDebtCard(Map<String, dynamic> debt) {
    final bool isPaid = debt['isPaid'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPaid ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Indicator
          CircleAvatar(
            backgroundColor:
                isPaid ? Colors.green.shade50 : Colors.orange.shade50,
            child: Icon(
              isPaid ? Icons.check : Icons.call_made,
              color: isPaid ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Debt Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  debt['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  debt['note'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Due: ${debt['dueDate'] ?? ''}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Amount & Mark Paid Action Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₱${(debt['amount'] as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPaid ? Colors.green.shade700 : const Color(0xFFD9381E),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _togglePaidStatus(debt['id']),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPaid ? 'PAID' : 'MARK PAID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPaid
                          ? Colors.green.shade800
                          : Colors.orange.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Empty Search View
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No records found matching "$_searchQuery"',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}