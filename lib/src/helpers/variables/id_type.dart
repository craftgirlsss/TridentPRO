final List<IdentityCardType> idTypeList = [
  IdentityCardType("KTP"),
  IdentityCardType("Passport")
  // IdentityCardType(LanguageGlobalVar.TAX_CARD.tr)
];

class IdentityCardType {
  String name;
  IdentityCardType(this.name);
}