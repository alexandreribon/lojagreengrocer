import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/ui/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/core/utils/validators.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/modules/auth/auth_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    var user = UserModel();

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizeScreen.height,
          width: sizeScreen.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
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
                            icon: Icons.email,
                            label: 'Email',
                            textInputType: TextInputType.emailAddress,
                            validator: emailValidator(),
                            onSaved: (value) => user.email = value,
                          ),
                          CustomTextField(
                            icon: Icons.lock,
                            label: 'Senha',
                            isSecret: true,
                            validator: passwordValidator('Senha'),
                            onSaved: (value) => user.password = value,
                          ),
                          CustomTextField(
                            icon: Icons.person,
                            label: 'Nome',
                            validator: nameValidator(),
                            onSaved: (value) => user.name = value,
                          ),
                          CustomTextField(
                            icon: Icons.phone,
                            label: 'Celular',
                            inputFormatters: [phoneFormatter],
                            textInputType: TextInputType.phone,
                            validator: phoneValidator(),
                            onSaved: (value) => user.phone = value,
                          ),
                          CustomTextField(
                            icon: Icons.file_copy,
                            label: 'CPF',
                            inputFormatters: [cpfFormatter],
                            textInputType: TextInputType.number,
                            validator: cpfValidator(),
                            onSaved: (value) => user.cpf = value,
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
                                  _formKey.currentState!.save();
                                  controller.signUp(user);
                                }
                              },
                              child: const Text(
                                'Cadastrar Usuário',
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
              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
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
