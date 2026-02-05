import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_4/model/expense_model.dart';
import 'calculator_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<ExpenseModel> _expenses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadExpenses());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ================= Load Expenses =================
  Future<void> _loadExpenses() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString('expenses');
      if (dataString != null) {
        final List<dynamic> dataList = jsonDecode(dataString);
        setState(() {
          _expenses.clear();
          _expenses.addAll(dataList.map((e) => ExpenseModel.fromMap(e)));
          _loading = false;
        });
      } else {
        setState(() {
          _expenses.clear();
          _loading = false;
        });
      }
    } else {
      // Mobile: SQLite logic here if needed
      setState(() {
        _expenses.clear();
        _loading = false;
      });
    }
  }

  // ================= Save Expenses (Web) =================
  Future<void> _saveExpensesWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = jsonEncode(_expenses.map((e) => e.toMap()).toList());
    await prefs.setString('expenses', dataString);
  }

  // ================= Add Expense =================
  Future<void> _addExpenseFromField() async {
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    final expense = ExpenseModel(amount: amount, reason: '');

    setState(() {
      _expenses.add(expense);
      _amountController.clear();
    });

    if (kIsWeb) {
      await _saveExpensesWeb();
    }
  }

  // ================= Update Reason =================
  Future<void> _updateExpenseReason(int index, String newReason) async {
    final updated = _expenses[index].copyWith(reason: newReason);
    setState(() {
      _expenses[index] = updated;
    });
    if (kIsWeb) await _saveExpensesWeb();
  }

  // ================= Delete Expense =================
  Future<void> _deleteExpense(int index) async {
    setState(() {
      _expenses.removeAt(index);
    });
    if (kIsWeb) await _saveExpensesWeb();
  }

  // ================= Calculator =================
  Future<void> _openCalculator() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalculatorScreen()),
    );

    if (result != null && result is ExpenseModel) {
      setState(() {
        _expenses.add(result);
      });
      if (kIsWeb) await _saveExpensesWeb();
    }
  }

  // ================= Edit Reason Dialog =================
  void _editReasonDialog(int index) {
    final controller = TextEditingController(text: _expenses[index].reason);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit reason'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter reason'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newReason = controller.text.trim();
              if (newReason.isEmpty) return;
              await _updateExpenseReason(index, newReason);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalExpense = _expenses.fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.lightBlue,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                            prefixIcon: Icon(Icons.currency_exchange_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _addExpenseFromField,
                                child: const Text('Add Expense'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _openCalculator,
                              child: const Text('Open Calculator'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _expenses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                              SizedBox(height: 12),
                              Text('No expenses yet',
                                  style: TextStyle(fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _expenses.length,
                          itemBuilder: (context, index) {
                            final expense = _expenses[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  expense.reason.isEmpty
                                      ? 'Tap to add reason'
                                      : expense.reason,
                                  style: TextStyle(
                                    fontStyle: expense.reason.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: expense.reason.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text('৳ ${expense.amount}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.redAccent,
                                  onPressed: () => _deleteExpense(index),
                                ),
                                onTap: () => _editReasonDialog(index),
                              ),
                            );
                          },
                        ),
                ),
                Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('৳ $totalExpense',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
