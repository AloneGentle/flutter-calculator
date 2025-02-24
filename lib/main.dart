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
        brightness: Brightness.dark, // 深色模式，符合计算器的风格
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

  final List<String> buttons = [
    'C', '←', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', 'C',
  ];

  // 异步计算表达式
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

  // 按钮点击处理
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
      } else if (value == '←') {
        // 删除一个单位
        _input = _input.isNotEmpty ? _input.substring(0, _input.length - 1) : '';
      } else {
        // 拼接输入
        _input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black, // 设置背景颜色为黑色
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
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // 显示计算结果
                Text(
                  _output.isEmpty ? '' : _output,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
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
                // 根据按钮类型改变样式
                Color buttonColor = (buttons[index] == 'C' || buttons[index] == '=' || buttons[index] == '←')
                    ? Colors.orangeAccent // 特殊按钮使用橙色
                    : Colors.grey[800]!; // 数字按钮使用深灰色

                return ElevatedButton(
                  onPressed: () => _onButtonPressed(buttons[index]),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20), // 按钮内边距
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // 圆角按钮
                    ),
                    minimumSize: const Size(80, 80),
                    elevation: 4, // 阴影
                  ),
                  child: Text(
                    buttons[index],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
