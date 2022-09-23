import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/ui/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/core/utils/validators.dart';
import 'package:greengrocer/src/modules/auth/auth_controller.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final emailEC = TextEditingController();

  ForgotPasswordDialog({
    required String email,
    Key? key,
  }) : super(key: key) {
    emailEC.text = email;
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formFieldKey = GlobalKey<FormFieldState>();
  final controller = Get.find<AuthController>();

  @override
  void dispose() {
    widget.emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conteudo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titulo
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recuperação de senha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Descrição
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    'Digite seu e-mail para recuperar sua senha',
                    textAlign: TextAlign.center,
                  ),
                ),

                // Campo de email
                CustomTextField(
                  formFieldKey: _formFieldKey,
                  controller: widget.emailEC,
                  icon: Icons.email,
                  label: 'E-mail',
                  validator: emailValidator(),
                ),

                // Botão confirmar
                ElevatedButton(
                  onPressed: () {
                    var isValid = _formFieldKey.currentState?.validate() ?? false;
                    if (isValid) {
                      controller.resetPassword(email: widget.emailEC.text);
                      Get.back(result: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                  child: const Text(
                    'Recuperar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Botão para fechar o dialog
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
