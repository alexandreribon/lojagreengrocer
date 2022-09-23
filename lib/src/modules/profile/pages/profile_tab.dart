import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/ui/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/core/utils/validators.dart';
import 'package:greengrocer/src/modules/profile/profile_controller.dart';

class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = controller.authService.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do usuário',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          // Email
          CustomTextField(
            readOnly: true,
            initialValue: user.email,
            icon: Icons.email,
            label: 'Email',
          ),

          // Nome
          CustomTextField(
            readOnly: true,
            initialValue: user.name,
            icon: Icons.person,
            label: 'Nome',
          ),

          // Celular
          CustomTextField(
            readOnly: true,
            initialValue: user.phone,
            icon: Icons.phone,
            label: 'Celular',
          ),

          // CPF
          CustomTextField(
            readOnly: true,
            initialValue: user.cpf,
            icon: Icons.file_copy,
            label: 'CPF',
            isSecret: true,
          ),

          // Botão para atualizar a senha
          SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                _updatePassword(context);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                  color: Colors.green,
                ),
              ),
              child: const Text(
                'Atualizar senha',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _updatePassword(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordEC = TextEditingController();
    final newPasswordEC = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Atualização de senha',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: currentPasswordEC,
                        icon: Icons.lock,
                        label: 'Senha atual',
                        isSecret: true,
                        validator: passwordValidator('Senha atual'),
                      ),
                      CustomTextField(
                        controller: newPasswordEC,
                        icon: Icons.lock_outline,
                        label: 'Nova senha',
                        isSecret: true,
                        validator: passwordValidator('Nova senha'),
                      ),
                      CustomTextField(
                        icon: Icons.lock_outline,
                        label: 'Confirmar nova senha',
                        isSecret: true,
                        validator: comparePasswordValidator(newPasswordEC),
                      ),
                      SizedBox(
                        height: 45,
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus(); //tira o teclado

                                    final formValid = formKey.currentState?.validate() ?? false;
                                    if (formValid) {
                                      controller.changePassword(
                                        currentPassword: currentPasswordEC.text,
                                        newPassword: newPasswordEC.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: controller.isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Atualizar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () => Get.back(), //Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
