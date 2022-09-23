import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/core/ui/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/core/ui/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/core/utils/validators.dart';
import 'package:greengrocer/src/modules/auth/auth_controller.dart';
import 'package:greengrocer/src/modules/auth/components/forgot_password_dialog.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final senhaEC = TextEditingController();

  final controller = Get.find<AuthController>();
  final utilService = Get.find<UtilsService>();

  @override
  void dispose() {
    emailEC.dispose();
    senhaEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizeScreen.height,
          width: sizeScreen.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppNameWidget(
                      greenTitleColor: Colors.white,
                      textTitleSize: 40,
                    ),
                    SizedBox(
                      height: 30,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Frutas'),
                            FadeAnimatedText('Verduras'),
                            FadeAnimatedText('Legumes'),
                            FadeAnimatedText('Carnes'),
                            FadeAnimatedText('Cereais'),
                            FadeAnimatedText('Laticíneos'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: emailEC,
                        icon: Icons.email,
                        label: 'E-mail',
                        validator: emailValidator(),
                      ),
                      CustomTextField(
                        controller: senhaEC,
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
                        validator: passwordValidator('Senha'),
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus(); //tira o teclado

                            final formValid = _formKey.currentState?.validate() ?? false;
                            if (formValid) {
                              controller.signIn(
                                email: emailEC.text,
                                password: senhaEC.text,
                              );
                              //Get.offAllNamed(PagesRoutes.baseRoute);
                            }
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final bool? result = await showDialog(
                              context: context,
                              builder: (_) => ForgotPasswordDialog(email: emailEC.text),
                            );
                            if (result ?? false) {
                              utilService.showToast(
                                message:
                                    'Um link de recuperação da senha foi enviado para seu e-mail',
                              );
                            }
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: CustomColors.customContrastColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Get.toNamed(PagesRoutes.signUpRoute),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
