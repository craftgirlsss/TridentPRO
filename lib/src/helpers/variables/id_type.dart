import 'package:get/get.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';

final List<IdentityCardType> idTypeList = [
  IdentityCardType(LanguageGlobalVar.ID_CARD.tr),
  IdentityCardType("Passport")
  // IdentityCardType(LanguageGlobalVar.TAX_CARD.tr)
];

class IdentityCardType {
  String name;
  IdentityCardType(this.name);
}