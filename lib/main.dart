import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '';  // 初始化为空字符串
  String _input = '';
  final List<String> buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'C',  // 添加 'C' 按钮用于清除
  ];

  // 异步计算表达式
  Future<void> _calculate(String expression) async {
    try {
      // 通过异步计算表达式
      final exp = Expression.parse(expression);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(exp, {});

      // 检查结果并更新状态
      setState(() {
        _output = result is double
            ? (result == result.toInt() ? result.toInt().toString() : result.toString())
            : result.toString();
      });
    } catch (e) {
      // 异常处理
      setState(() {
        _output = 'Error';
      });
    }
  }

  // 更新输入内容
  void _onButtonPressed(String value) {
    setState(() {
      if (value == '=') {
        // 只有在输入完整式子后点击 '=' 时进行计算
        _calculate(_input);
        _input = ''; // 清空输入
      } else if (value == 'C') {
        // 清空输入和输出
        _input = '';
        _output = '';
      } else {
        _input += value; // 添加数字或符号到输入
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          // 显示输入和输出
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  _input, // 显示当前输入
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                // 显示输出，只有计算后才会更新
                Text(
                  _output.isEmpty ? '' : _output, // 只有当输出不为空时显示结果
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // 显示计算器按钮
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(buttons[index]),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(80, 80),
                  ),
                  child: Text(
                    buttons[index],
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//git remote add origin https://github.com/AloneGentle/flutter-calculator.git