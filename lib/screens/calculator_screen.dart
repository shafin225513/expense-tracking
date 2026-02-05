import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/expense_model.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  double firstNumber = 0;
  String operator = '';
  bool isNewinput=true;

  void onNumberPress(String value) {
  setState(() {
    if (isNewinput) {
      display = value;
      isNewinput = false;
    } else {
      display += value;
    }
  });
}


  void onOperatorPress(String op) {
    if (display.isEmpty) return;

    firstNumber = double.parse(display);
    operator = op;
    isNewinput=true;
  }

  void onEqualPress() {
    if (display.isEmpty || operator.isEmpty) return;

    final secondNumber = double.parse(display);
    double result = 0;

    switch (operator) {
      case '+':
        result = firstNumber + secondNumber;
        break;
      case '-':
        result = firstNumber - secondNumber;
        break;
      case '*':
        result = firstNumber * secondNumber;
        break;
      case '/':
        result = secondNumber == 0 ? 0 : firstNumber / secondNumber;
        break;
    }

    setState(() {
      display = result.toStringAsFixed(0);
      operator = '';
      isNewinput=true;
    });
  }

  void onClear() {
    setState(() {
      display = '0';
      operator = '';
      firstNumber = 0;
      isNewinput=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          // Display
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              display.isEmpty ? '0' : display,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          // Buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(11),
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
              children: [
                ...['7','8','9','+',
                    '4','5','6','-',
                    '1','2','3','*',
                    '0','C','=','/']
                    .map((text) => ElevatedButton(
                      onPressed: () {
                        if (text == 'C') {
                          onClear();
                        } else if (text == '=') {
                          onEqualPress();
                        } else if ('+-*/'.contains(text)) {
                          onOperatorPress(text);
                        } else {
                          onNumberPress(text);
                        }
                      },
                      child: Text(text, style: const TextStyle(fontSize: 20)),
                    ))
              ],
            ),
          ),

          // Use Amount Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                final int? value=int.tryParse(display);
                if (value==null) return;
                Navigator.pop(context, 
                ExpenseModel(
                amount: value, 
                reason: ''));
              },
              child: const Text('Use Amount'),
            ),
          )
        ],
      ),
    );
  }
}
