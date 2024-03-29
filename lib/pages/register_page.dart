import 'package:flutter/material.dart';
import 'package:flutter_validation/constants/string_constants.dart';
import 'package:flutter_validation/widgets/button_widget.dart';
import 'package:flutter_validation/widgets/my_custon_clipper_widget.dart';
import 'package:flutter_validation/widgets/text_form_widget.dart';
import 'package:flutter_validation/widgets/text_widget.dart';
import '../constants/error_constants.dart';
import '../controller/validate_fields.dart';
import '../routes/routes.dart';
import '../service/register_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final TextEditingController _mailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool saved = false;

  Future<bool?> showConfirmationDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(StringConstants.desejaSair),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(StringConstants.cancel),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(StringConstants.close),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!saved) {
          final confirmation = await showConfirmationDialog();
          return confirmation ?? false;
        }
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _custonClipper(),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _mailField(),
                      const SizedBox(height: 10),
                      _passwordField(),
                      const SizedBox(height: 10),
                      _confirmPasswordField(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _textLogin(context),
                const SizedBox(height: 30),
                _registerLogin(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerLogin(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_passwordController.text == _confirmPasswordController.text) {
          _register();
          Navigator.pushNamed(context, RoutesPage.loginPage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(ErrorConstants.senhaNaoConfere),
            ),
          );
        }
      },
      child: ButtonWidget(
        text: StringConstants.register,
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      RegisterLoginService().singUp(
        context,
        _mailController.text,
        _passwordController.text,
      );
    }

    _mailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  _textLogin(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesPage.loginPage);
      },
      child: Textwidget(
        cadastro: StringConstants.registerLogin,
        login: StringConstants.loginName,
      ),
    );
  }

  _mailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
      ),
      child: TextFormWidget(
        StringConstants.email,
        StringConstants.typeEmail,
        const Icon(
          Icons.email,
          color: Colors.green,
        ),
        controller: _mailController,
        obscureText: false,
        validator: Validate().validateEmail,
      ),
    );
  }

  _passwordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
      ),
      child: TextFormWidget(
        StringConstants.password,
        StringConstants.registerPassword,
        const Icon(
          Icons.vpn_key,
          color: Colors.green,
        ),
        sulfixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        controller: _passwordController,
        obscureText: _obscureText,
        validator: Validate().validatePassword,
      ),
    );
  }

  _confirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
      ),
      child: TextFormWidget(
        StringConstants.confirmPassword,
        StringConstants.confirmPassword,
        const Icon(
          Icons.vpn_key,
          color: Colors.green,
        ),
        sulfixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        controller: _confirmPasswordController,
        obscureText: _obscureText,
        validator: Validate().validatePassword,
      ),
    );
  }

  _custonClipper() {
    return ClipPath(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(90),
          ),
          gradient: LinearGradient(
              colors: [(Colors.green), (Colors.black)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        height: 180,
      ),
      clipper: MycustonClipper(),
    );
  }
}
