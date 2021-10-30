import 'package:flutter/material.dart';
import 'package:testapi/services/api.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var _input = '';
  static const PIN_LENGTH = 6;

  @override

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
              _buildNumPad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [-2, 0, -1],
        ].map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((item) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginButton(
                  number: item,
                  onClick: () {
                    _handleClickButton(item);
                  },
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  _handleClickButton(int num) async {
    print('You pressed $num');

    if (num == -1) {
      if (_input.length > 0) {
        setState(() {
          _input = _input.substring(0, _input.length - 1);
        });
      }
    } else {
      setState(() {
        _input = '$_input$num';
      });
    }

    if (_input.length == PIN_LENGTH) {
      var isLogin = await _login(_input);

      if (isLogin == null) return;

      if (isLogin) {
        setState(() {
          _input = '';
        });
        _showMaterialDialog('LOGIN SUCCESS', 'OK.');
      } else {
        setState(() {
          _input = '';
        });
        _showMaterialDialog('LOGIN FAILED', 'Invalid PIN. Please try again.');
      }
    }

  }
  _login(String pin) async{
    var _isLogin = await Api().submit("login", {"pin" : pin}) as bool;
    return _isLogin;
  }

}



class LoginButton extends StatelessWidget {
  final int number;
  final Function() onClick;

  const LoginButton({
    required this.number,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      onTap: number == -2 ? null : onClick,
      child: Container(
        width: 75.0,
        height: 75.0,
        decoration: number == -2
            ? null
            : BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.5),
          border: Border.all(
            width: 3.0,
            color: Theme.of(context).textTheme.headline1!.color!,
          ),
        ),
        child: Center(
          child: number >= 0
              ? Text(
            '$number', // number.toString()
            style: Theme.of(context).textTheme.headline6,
          )
              : (number == -1
              ? Icon(
            Icons.backspace_outlined,
            size: 28.0,
          )
              : SizedBox.shrink()),
        ),
      ),
    );
  }
}
