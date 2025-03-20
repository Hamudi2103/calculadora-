import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '0';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '0';
      } else if (value == '←') {
        // Eliminar el último carácter
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
        output = input.isEmpty ? '0' : input;
      } else if (value == '=') {
        try {
          if (input.isNotEmpty) {
            Parser p = Parser();
            String expression = input.replaceAll('×', '*').replaceAll('%', '/');
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            output = eval.toStringAsFixed(2);
          }
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    input,
                    style: const TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    output,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              buildButtonRow(['C', '←', '/']),
              buildButtonRow(['7', '8', '9', '*']),
              buildButtonRow(['4', '5', '6', '-']),
              buildButtonRow(['1', '2', '3', '+']),
              buildButtonRow(['0', ' ', '.', '=']),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          buttons.map((btn) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor:
                        btn == '=' ? Colors.orange : Colors.grey[800],
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () => onButtonPressed(btn),
                  child: Text(
                    btn,
                    style: TextStyle(
                      fontSize: 32,
                      color: btn == '=' ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
