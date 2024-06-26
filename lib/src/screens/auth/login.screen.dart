import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/auth";
  static const String name = "Login Screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password;
  late FocusNode usernameFn, passwordFn;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController();
    password = TextEditingController();
    usernameFn = FocusNode();
    passwordFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title:
              const Text("Login", style: TextStyle(color: Colors.deepPurple)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            // Center the content
            child: Container(
              width: 300, // Define square size
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the square
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(12), // (For rounded corners)
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the form content vertically
                  children: [
                    TextFormField(
                      decoration: decoration.copyWith(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person),
                      ),
                      focusNode: usernameFn,
                      controller: username,
                      onEditingComplete: () => passwordFn.requestFocus(),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please fill out the username'),
                        MaxLengthValidator(32,
                            errorText: "Username cannot exceed 32 characters"),
                        PatternValidator(r'^[a-zA-Z0-9 ]+$',
                            errorText:
                                'Username cannot contain special characters'),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obfuscate,
                      decoration: decoration.copyWith(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => obfuscate = !obfuscate),
                          icon: Icon(obfuscate
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      focusNode: passwordFn,
                      controller: password,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Password is required"),
                        MinLengthValidator(12,
                            errorText:
                                "Password must be at least 12 characters long"),
                        MaxLengthValidator(128,
                            errorText: "Password cannot exceed 128 characters"),
                        PatternValidator(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                          errorText:
                              'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.',
                        ),
                      ]),
                    ),
                    const SizedBox(
                        height: 20), // Add some space before the login button
                    ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I
              .login(username.text.trim(), password.text.trim()));
    }
  }

  final OutlineInputBorder _baseBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple.shade100),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  InputDecoration get decoration => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        errorMaxLines: 3,
        disabledBorder: _baseBorder,
        enabledBorder: _baseBorder.copyWith(
          borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 1),
        ),
        focusedBorder: _baseBorder.copyWith(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: _baseBorder.copyWith(
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
        ),

        // errorStyle:
        // AppTypography.body.b5.copyWith(color: AppColors.highlight.shade900),
        // focusedErrorBorder: _baseBorder.copyWith(
        // borderSide: BorderSide(color: AppColors.highlight.shade900, width: 1),
        // ),
        // labelStyle: AppTypography.subheading.s1
        //     .copyWith(color: AppColors.secondary.shade2),
        // floatingLabelStyle: AppTypography.heading.h5
        //     .copyWith(color: AppColors.primary.shade400, fontSize: 18),
        // hintStyle: AppTypography.subheading.s1
        //     .copyWith(color: AppColors.secondary.shade2),
      );
}
