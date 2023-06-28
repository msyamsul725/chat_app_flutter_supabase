import 'package:flutter/material.dart';
import 'package:hyper_ui/state_util.dart';

import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  Widget build(context, LoginController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.16),
              // Center(
              //   child: Image.asset(
              //     "assets/icons/logo_group.png",
              //     width: 180.0,
              //     fit: BoxFit.fill,
              //   ),
              // ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                !!controller.signUp
                    ? "Sign in to your account"
                    : "Sign up for free",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    controller.signUp
                        ? Text(
                            "",
                            style: TextStyle(
                              fontSize: 1.0,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 26.0,
                            ),
                            height: MediaQuery.of(context).size.height * 0.058,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    validator: (value) {
                                      // Validator.email(value);
                                      return null;
                                    },
                                    controller: controller.username,
                                    initialValue: null,
                                    decoration: const InputDecoration.collapsed(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      hintText: "Your UserName",
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onFieldSubmitted: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 26.0,
                      ),
                      height: MediaQuery.of(context).size.height * 0.058,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              validator: (value) {
                                // Validator.email(value);
                                return null;
                              },
                              controller: controller.email,
                              initialValue: null,
                              decoration: const InputDecoration.collapsed(
                                filled: true,
                                fillColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                hintText: "Your Email",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              onFieldSubmitted: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    controller.signUp
                        ? Text(
                            "",
                            style: TextStyle(
                              fontSize: 1.0,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 26.0,
                            ),
                            height: MediaQuery.of(context).size.height * 0.058,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    obscureText: true,
                                    validator: (value) {
                                      // Validator.required(value);
                                      return null;
                                    },
                                    controller: controller.password,
                                    initialValue: null,
                                    decoration: const InputDecoration.collapsed(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      hintText: "Your Password",
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onFieldSubmitted: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      controller.signUp
                          ? controller.doLogin()
                          : controller.doCreateUser();
                    }

                    // ? await _signIn()
                    // : await createUser(
                    //     email: email.text, password: password.text);
                  },
                  child: Text(
                    controller.signUp ? "Sign In" : "Sign up",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 60.0,
              ),
              controller.signUp
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.signUp = !controller.signUp;
                            controller.update();
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Back to  ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.signUp = !controller.signUp;
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<LoginView> createState() => LoginController();
}
