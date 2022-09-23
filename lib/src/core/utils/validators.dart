import 'package:flutter/cupertino.dart';
import 'package:validatorless/validatorless.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

String? Function(String?)? emailValidator() {
  return Validatorless.multiple([
    Validatorless.required('E-mail obrigatório'),
    Validatorless.email('E-mail inválido'),
  ]);
}

String? Function(String?)? passwordValidator(String campo) {
  return Validatorless.multiple([
    Validatorless.required('$campo obrigatória'),
    Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
  ]);
}

String? Function(String?)? comparePasswordValidator(TextEditingController controller) {
  return Validatorless.multiple([
    Validatorless.required('Confirmar nova senha obrigatória'),
    Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
    Validatorless.compare(controller, 'As senhas não conferem'),
  ]);
}

String? Function(String?)? nameValidator() {
  return Validatorless.multiple([
    Validatorless.required('Nome obrigatório'),
    (String? name) {
      final names = name?.split(' ') ?? [''];
      if (names.length == 1) return 'Digite seu nome completo';
      return null;
    },
  ]);
}

String? Function(String?)? phoneValidator() {
  return Validatorless.multiple([
    Validatorless.required('Celular obrigatório'),
    (String? phone) {
      if (phone != null) {
        if (phone.length < 14 || !phone.isPhoneNumber) {
          return 'Digite um celular válido';
        }
      }
      return null;
    }
  ]);
}

String? Function(String?)? cpfValidator() {
  return Validatorless.multiple([
    Validatorless.required('CPF obrigatório'),
    Validatorless.cpf('CPF inválido'),
  ]);
}
