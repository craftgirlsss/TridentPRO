import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/helpers/formatters/number_formatter.dart';
import 'package:tridentpro/src/models/trades/trading_account_models.dart';
import 'package:tridentpro/src/views/accounts/change_password_real.dart';
import 'package:tridentpro/src/views/trade/deposit.dart';
import 'package:tridentpro/src/views/trade/deriv_chart_page.dart';
import 'package:tridentpro/src/views/trade/internal_transfer.dart';
import 'package:tridentpro/src/views/trade/withdrawal.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({super.key, this.loginID});
  final String? loginID;

    @override
    State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  int _tabIndex = 0; // Untuk tab ACTIONS / INFO
  RxString selectedLoginID = "".obs;

  TradingController tradingController = Get.find();
  Real? selectedAccount;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var result = tradingController.tradingAccountModels.value?.response.real;
      if(result != null){
        for(int i = 0; i < result.length; i++){
          if(result[i].login == widget.loginID){
            selectedLoginID(result[i].id);
            setState(() {
              selectedAccount = result[i];
            });
            break; 
          }
        }
        await tradingController.getSymbols();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Account", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: CustomColor.secondaryColor, height: 1.0,)),
            Text("Information", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: Colors.black)),
            const SizedBox(height: 5.0),
            Text("Informasi lengkap mengenai akun trading ${widget.loginID}.", style: TextStyle(color: CustomColor.textThemeLightSoftColor, fontSize: 15)),
            const SizedBox(height: 10.0),
            // Header card
            _buildAccountCard(),
        
            // Tab switcher
            _buildTabBar(),
        
            // Menu list (ACTIONS tab)
            if (_tabIndex == 0) _buildActionList(size),
            if (_tabIndex == 1) _buildInfoTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/mt5.png', width: 20.0),
                  const SizedBox(width: 5.0),
                  Text("MetaTrader 5", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 4),
              Text(selectedAccount?.login != null ? selectedAccount!.login.toString() : "-", style: TextStyle(fontSize: 16)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColor.backgroundIcon.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("RATE ${selectedAccount?.rate != null ? NumberFormatter.formatCurrency(selectedAccount!.rate, currency: selectedAccount!.currency!) : ""}", style: TextStyle(color: CustomColor.secondaryColor, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              Text("\$${selectedAccount?.balance ?? 0}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColor.secondaryColor)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabItem("ACTIONS", 0),
        _tabItem("INFO", 1),
      ],
    );
  }

  Widget _tabItem(String label, int index) {
    bool selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? CustomColor.secondaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? CustomColor.secondaryColor : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActionList(Size size) {
    return Expanded(
      child: ListView(
        children: [
          _menuItem(Iconsax.wallet_2_outline, 'Deposit', onPressed: () => Get.to(() => Deposit(idLogin: widget.loginID))),
          _menuItem(Iconsax.chart_2_outline, 'Trade', onPressed: () {
            print(selectedAccount?.balance);
            CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Market Symbols", children: List.generate(tradingController.symbols.length, (i){
              return ListTile(
                title: Text(tradingController.symbols[i]['symbol'], style: GoogleFonts.inter(color: CustomColor.textThemeLightColor)),
                onTap: () async {
                  Get.back();
                  Get.to(() => DerivChartPage(login: int.parse(widget.loginID!), marketName: tradingController.symbols[i]['symbol'], balance: selectedAccount?.balance));
                },
              );
            }));
          }),
          _menuItem(Bootstrap.box_arrow_up, 'Withdrawal', onPressed: () => Get.to(() => Withdrawal(idLogin: widget.loginID))),
          _menuItem(MingCute.transfer_4_line, 'Internal transfer', onPressed: () => Get.to(() => InternalTransfer(loginID: selectedLoginID.value, loginNumber: widget.loginID))),
          _menuItem(TeenyIcons.history, 'Operation history'),
          _menuItem(Iconsax.lock_1_outline, 'Change Password', onPressed: () => Get.to(() => ChangePasswordReal(loginID: widget.loginID, tradingID: selectedAccount?.id))),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    // Contoh dummy data, ganti sesuai data aslimu
    String marginFree = NumberFormatter.formatCurrency(selectedAccount?.marginFree, currency: 'USD');
    String leverage = '1:${selectedAccount?.leverage != null ? NumberFormatter.formatWithoutTrailingZeros(selectedAccount!.leverage) : '0'}';
    String totalDeposit = selectedAccount?.totalDeposit != null ? NumberFormatter.formatCurrency(selectedAccount!.totalDeposit, currency: selectedAccount!.currency!) : '0';
    String minimumDeposit = selectedAccount?.minDeposit != null ? NumberFormatter.formatCurrency(selectedAccount!.minDeposit, currency: selectedAccount!.currency!) : '0';
    String fixedRate = selectedAccount?.rate != "Floating" ? 'Yes' : 'No';
    String server = 'RRFX-Real';
    String currency = selectedAccount?.currency ?? "USD";
    String accountTypeName = selectedAccount?.namaTipeAkun ?? '-';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Account details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _infoItem('Margin Free', marginFree),
            _infoItem('Leverage', leverage),
            _infoItem('Fixed rate', fixedRate),
            _infoItem('Server', server),
            _infoItem('Currency', currency),
            _infoItem('Account Type Name', accountTypeName),
            _infoItem('Minimum Deposit', minimumDeposit),
            _infoItem('Total Deposit', totalDeposit),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: TextStyle(color: Colors.black)),
      ],
    ),
  );
}


  Widget _menuItem(IconData icon, String title, {VoidCallback? onPressed}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onPressed,
    );
  }
}
