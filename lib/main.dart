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
      theme: ThemeData(
        brightness: Brightness.light, // 亮色模式
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _input = '';  // 用户输入的内容
  String _output = ''; // 计算结果

  // 定义按钮的配置
  final List<Map<String, dynamic>> buttons = [
    {'label': 'C', 'color': Color(0xFF769CDF), 'action': 'clear'},
    {'label': '←', 'color': Color(0xFF769CDF), 'action': 'backspace'},
    {'label': '%', 'color': Color(0xFF769CDF), 'action': 'operator'},
    {'label': '/', 'color': Color(0xFF769CDF), 'action': 'operator'},
    {'label': '7', 'color': Colors.white, 'action': 'number'},
    {'label': '8', 'color': Colors.white, 'action': 'number'},
    {'label': '9', 'color': Colors.white, 'action': 'number'},
    {'label': '*', 'color': Color(0xFF769CDF), 'action': 'operator'},
    {'label': '4', 'color': Colors.white, 'action': 'number'},
    {'label': '5', 'color': Colors.white, 'action': 'number'},
    {'label': '6', 'color': Colors.white, 'action': 'number'},
    {'label': '-', 'color': Color(0xFF769CDF), 'action': 'operator'},
    {'label': '1', 'color': Colors.white, 'action': 'number'},
    {'label': '2', 'color': Colors.white, 'action': 'number'},
    {'label': '3', 'color': Colors.white, 'action': 'number'},
    {'label': '+', 'color': Color(0xFF769CDF), 'action': 'operator'},
    {'label': '0', 'color': Colors.white, 'action': 'number'},
    {'label': '.', 'color': Colors.white, 'action': 'number'},
    {'label': '=', 'color': Color(0xFF769CDF), 'action': 'equals'},
    {'label': 'C', 'color': Color(0xFF769CDF), 'action': 'clear'},
  ];

  // 处理按键动作
  void _onButtonPressed(Map<String, dynamic> button) {
    setState(() {
      switch (button['action']) {
        case 'clear':
          _input = '';
          _output = '';
          break;
        case 'backspace':
          _input = _input.isNotEmpty ? _input.substring(0, _input.length - 1) : '';
          break;
        case 'operator':
          _input += button['label'];
          break;
        case 'number':
          _input += button['label'];
          break;
        case 'equals':
          _calculate(_input);
          _input = '';
          break;
      }
    });
  }

  // 计算表达式
  Future<void> _calculate(String expression) async {
    try {
      final exp = Expression.parse(expression);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(exp, {});
      setState(() {
        _output = result is double
            ? (result == result.toInt() ? result.toInt().toString() : result.toString())
            : result.toString();
      });
    } catch (e) {
      setState(() {
        _output = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.white, // 设置背景颜色为白色
      ),
      body: Column(
        children: [
          // 显示输入和输出
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 显示当前输入
                Text(
                  _input,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                // 显示计算结果
                Text(
                  _output.isEmpty ? '' : _output,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
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
                crossAxisCount: 4, // 四列
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemBuilder: (context, index) {
                Map<String, dynamic> button = buttons[index];
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(button),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20), // 按钮内边距
                    backgroundColor: button['color'], // 设置每个按钮的背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // 圆形按钮
                    ),
                    minimumSize: const Size(80, 80),
                    elevation: 4, // 阴影
                  ),
                  child: Text(
                    button['label'], // 按钮的标签
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
