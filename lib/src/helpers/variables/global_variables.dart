import 'package:get/get.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';

class GlobalVariable {
  static final List<String> gender = [LanguageGlobalVar.MEN.tr, LanguageGlobalVar.FEMALE.tr];
  static final List<String> marital = [LanguageGlobalVar.SINGLE.tr, LanguageGlobalVar.MARRIED.tr, LanguageGlobalVar.DIVORCED.tr];
  static final List<String> relation = [LanguageGlobalVar.FATHER.tr, LanguageGlobalVar.MOTHER.tr, LanguageGlobalVar.YOUNR_BROTHER.tr, LanguageGlobalVar.BROTHER.tr];
  static final List<String> investmentGoal = ["Hedging", "Speculation", "Gain", "Other"];
}