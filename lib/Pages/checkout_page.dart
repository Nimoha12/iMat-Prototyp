import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:imat_repo/model/imat/credit_card.dart';
import 'package:imat_repo/model/imat/customer.dart';
import 'package:imat_repo/model/imat/user.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const double _stageWidth = 860;
  static const double _backButtonWidth = 170;
  static const double _buttonGap = 14;

  int _step = 0;
  int _selectedDate = 0;
  int _selectedTime = 0;
  String _payment = 'Faktura';
  bool _loadedCustomer = false;
  bool _orderPlaced = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _invoiceEmailController = TextEditingController();
  final _swishPhoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _cardMonthController = TextEditingController();
  final _cardYearController = TextEditingController();

  final List<_DeliveryDate> _dates = List.generate(6, (index) {
    final date = DateTime.now().add(Duration(days: index + 1));

    const weekdays = [
      'Måndag',
      'Tisdag',
      'Onsdag',
      'Torsdag',
      'Fredag',
      'Lördag',
      'Söndag',
    ];

    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'maj',
      'jun',
      'jul',
      'aug',
      'sep',
      'okt',
      'nov',
      'dec',
    ];

    return _DeliveryDate(
      weekdays[date.weekday - 1],
      '${date.day} ${months[date.month - 1]}',
    );
  });
  final List<String> _times = const [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
  ];

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_refreshLoginButton);
    _passwordController.addListener(_refreshLoginButton);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final iMat = context.watch<ImatDataHandler>();
    final customer = iMat.getCustomer();

    if (_loadedCustomer && !_shouldLoadCustomer(customer)) {
      return;
    }

    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _phoneController.text = customer.mobilePhoneNumber;
    _addressController.text = customer.address;
    _postCodeController.text = customer.postCode;
    _cityController.text = customer.postAddress;
    _invoiceEmailController.text = customer.email;
    _swishPhoneController.text = customer.mobilePhoneNumber;
    _emailController.text = iMat.getUser().userName;
    _loadedCustomer = true;
  }

  @override
  void dispose() {
    _emailController.removeListener(_refreshLoginButton);
    _passwordController.removeListener(_refreshLoginButton);
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _invoiceEmailController.dispose();
    _swishPhoneController.dispose();
    _cardNumberController.dispose();
    _cvcController.dispose();
    _cardMonthController.dispose();
    _cardYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return IMatScaffold(
      body: Container(
        color: IMatColors.beige,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CheckoutSidebar(
              step: _step,
              onBackToShop: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 28, 40, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _stageWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: _buildStepContent(isLoggedIn),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (!_orderPlaced && (_step > 0 || isLoggedIn))
                          _buildNavigation(isLoggedIn),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(bool isLoggedIn) {
    switch (_step) {
      case 0:
        return isLoggedIn ? _buildLoggedInCard() : _buildLoginCard();
      case 1:
        return _buildDeliveryCard();
      case 2:
        return _buildDetailsCard();
      case 3:
        return _buildPaymentCard();
      case 4:
        return _buildReviewCard();
      default:
        return _buildLoggedInCard();
    }
  }

  Widget _buildLoginCard() {
    return _Panel(
      width: 500,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Logga in', textAlign: TextAlign.center, style: IMatText.h1),
          const SizedBox(height: 24),
          _LabeledField(
            label: 'E-postadress',
            hint: 'din.epost@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          _LabeledField(
            label: 'Lösenord',
            hint: 'Ange ditt lösenord',
            controller: _passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: _canLogin ? _login : null,
              style: _primaryStyle(),
              child: const Text('Logga in'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInCard() {
    return _Panel(
      width: 480,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Du är inloggad',
                  style: IMatText.headingM.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Dina uppgifter fylls i automatiskt i nästa steg.',
                  style: IMatText.bodyM.copyWith(
                    color: IMatColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: IMatColors.green, size: 38),
        ],
      ),
    );
  }

  bool _shouldLoadCustomer(Customer customer) {
    final hasCustomerData = [
      customer.firstName,
      customer.lastName,
      customer.mobilePhoneNumber,
      customer.email,
      customer.address,
      customer.postCode,
      customer.postAddress,
    ].any((value) => value.trim().isNotEmpty);

    final fieldsAreEmpty = [
      _firstNameController,
      _lastNameController,
      _phoneController,
      _addressController,
      _postCodeController,
      _cityController,
      _invoiceEmailController,
      _swishPhoneController,
    ].every((controller) => controller.text.trim().isEmpty);

    return hasCustomerData && fieldsAreEmpty;
  }

  void _refreshLoginButton() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildDeliveryCard() {
    return _Panel(
      width: 820,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(icon: Icons.local_shipping, title: 'Leveranstid'),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OptionGrid(
                  title: 'Datum',
                  children: [
                    for (int index = 0; index < _dates.length; index++)
                      _SelectableTile(
                        selected: _selectedDate == index,
                        onTap: () => setState(() => _selectedDate = index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _dates[index].weekday,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: IMatText.bodyS,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dates[index].date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: IMatText.bodyS.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _OptionGrid(
                  title: 'Tid',
                  children: [
                    for (int index = 0; index < _times.length; index++)
                      _SelectableTile(
                        selected: _selectedTime == index,
                        onTap: () => setState(() => _selectedTime = index),
                        child: Center(
                          child: Text(
                            _times[index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: IMatText.bodyS.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return _Panel(
      width: 820,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dina uppgifter',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IMatText.h1,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _LabeledField(
                  label: 'Förnamn',
                  controller: _firstNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _LabeledField(
                  label: 'Postnummer',
                  controller: _postCodeController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _LabeledField(label: 'Ort', controller: _cityController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Efternamn',
                  controller: _lastNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _LabeledField(
                  label: 'Gatuadress',
                  controller: _addressController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Mobilnummer',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _LabeledField(
                  label: 'E-postadress',
                  controller: _invoiceEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return _Panel(
      width: 760,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(icon: Icons.credit_card, title: 'Välj betalningssätt'),
          const SizedBox(height: 20),
          Row(
            children: [
              for (final method in ['Faktura', 'Betalkort', 'Swish']) ...[
                Expanded(
                  child: _PaymentTab(
                    label: method,
                    selected: _payment == method,
                    onTap: () => setState(() => _payment = method),
                  ),
                ),
                if (method != 'Swish') const SizedBox(width: 12),
              ],
            ],
          ),
          const SizedBox(height: 20),
          if (_payment == 'Faktura')
            _LabeledField(
              label: 'E-post för faktura',
              controller: _invoiceEmailController,
              keyboardType: TextInputType.emailAddress,
            )
          else if (_payment == 'Swish')
            _LabeledField(
              label: 'Mobilnummer för Swish',
              controller: _swishPhoneController,
              keyboardType: TextInputType.phone,
            )
          else
            Column(
              children: [
                _LabeledField(
                  label: 'Kortnummer',
                  hint: 'XXXX-XXXX-XXXX-XXXX',
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'CVC',
                        hint: '123',
                        controller: _cvcController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _LabeledField(
                        label: 'Giltighetsmånad',
                        hint: 'MM',
                        controller: _cardMonthController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _LabeledField(
                        label: 'Giltighetsår',
                        hint: 'ÅÅ',
                        controller: _cardYearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;
    final total = iMat.shoppingCartTotal();

    if (_orderPlaced) {
      return _Panel(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: IMatColors.green, size: 72),
            const SizedBox(height: 16),
            Text(
              'Tack för din beställning!',
              style: IMatText.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Din order är skickad.',
              textAlign: TextAlign.center,
              style: IMatText.bodyM.copyWith(color: IMatColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return _Panel(
      width: 820,
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Granska din beställning',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IMatText.h1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  title: 'Leveranstid',
                  lines: [
                    _dates[_selectedDate].fullLabel,
                    _times[_selectedTime],
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SummaryBox(
                  title: 'Leveransadress',
                  lines: [_addressController.text, _addressLine],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  title: 'Kontaktinformation',
                  lines: [
                    _fullName,
                    _phoneController.text,
                    _invoiceEmailController.text,
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SummaryBox(title: 'Betalning', lines: [_payment]),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _OrderSummary(items: items, total: total),
        ],
      ),
    );
  }

  Widget _buildNavigation(bool isLoggedIn) {
    if (_step == 0) {
      return Center(
        child: SizedBox(
          width: _stageWidth - _backButtonWidth - _buttonGap,
          height: 62,
          child: ElevatedButton(
            onPressed: _canContinue(isLoggedIn) ? _next : null,
            style: _primaryStyle(),
            child: const Text('Fortsätt →'),
          ),
        ),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: _backButtonWidth,
          height: 62,
          child: OutlinedButton(
            onPressed: () => setState(() => _step--),
            style: OutlinedButton.styleFrom(
              foregroundColor: IMatColors.green,
              side: const BorderSide(color: IMatColors.green, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
            ),
            child: const Text('← Tillbaka'),
          ),
        ),
        const SizedBox(width: _buttonGap),
        Expanded(
          child: SizedBox(
            height: 62,
            child: ElevatedButton(
              onPressed: _canContinue(isLoggedIn) ? _next : null,
              style: _primaryStyle(),
              child: Text(_step == 4 ? '✓ Slutför köp' : 'Fortsätt →'),
            ),
          ),
        ),
      ],
    );
  }

  bool get _canLogin =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  bool _canContinue(bool isLoggedIn) {
    if (_step == 0) {
      return isLoggedIn;
    }
    return true;
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    context.read<ImatDataHandler>().setUser(User(email, password));
    context.read<AuthState>().login();

    setState(() {});
  }

  Future<void> _next() async {
    if (_step == 2) {
      _saveCustomer();
    }

    if (_step == 3) {
      _savePayment();
    }

    if (_step == 4) {
      final iMat = context.read<ImatDataHandler>();

      await iMat.placeOrder();

      if (!mounted) {
        return;
      }

      setState(() => _orderPlaced = true);

      final customer = iMat.getCustomer();

      customer.firstName = _firstNameController.text;
      customer.lastName = _lastNameController.text;
      customer.mobilePhoneNumber = _phoneController.text;
      customer.email = _invoiceEmailController.text;
      customer.address = _addressController.text;
      customer.postCode = _postCodeController.text;
      customer.postAddress = _cityController.text;

      iMat.setCustomer(customer);

      return;
    }

    setState(() => _step++);
  }

  void _saveCustomer() {
    context.read<ImatDataHandler>().setCustomer(
      Customer(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        '',
        _phoneController.text.trim(),
        _invoiceEmailController.text.trim(),
        _addressController.text.trim(),
        _postCodeController.text.trim(),
        _cityController.text.trim(),
      ),
    );
  }

  void _savePayment() {
    if (_payment != 'Betalkort') {
      return;
    }

    context.read<ImatDataHandler>().setCreditCard(
      CreditCard(
        'Visa',
        _fullName,
        int.tryParse(_cardMonthController.text.trim()) ?? 0,
        int.tryParse(_cardYearController.text.trim()) ?? 0,
        _cardNumberController.text.trim(),
        int.tryParse(_cvcController.text.trim()) ?? 0,
      ),
    );
  }

  String get _fullName =>
      '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
          .trim();

  String get _addressLine =>
      '${_postCodeController.text.trim()} ${_cityController.text.trim()}'
          .trim();

  ButtonStyle _primaryStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: IMatColors.green,
      disabledBackgroundColor: IMatColors.border,
      foregroundColor: IMatColors.white,
      disabledForegroundColor: IMatColors.textSecondary,
      elevation: 0,
      textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _CheckoutSidebar extends StatelessWidget {
  final int step;
  final VoidCallback onBackToShop;

  const _CheckoutSidebar({required this.step, required this.onBackToShop});

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Inloggning',
      'Leveranstid',
      'Dina uppgifter',
      'Betalning',
      'Granska beställning',
    ];

    return Container(
      width: 300,
      color: const Color(0xFFF1EDE4),
      padding: const EdgeInsets.fromLTRB(28, 34, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onBackToShop,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Tillbaka till handla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IMatColors.green,
                foregroundColor: IMatColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          for (int index = 0; index < labels.length; index++)
            _StepIndicator(
              number: index + 1,
              label: labels[index],
              isActive: step == index,
              isDone: step > index,
              showLine: index < labels.length - 1,
            ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isDone;
  final bool showLine;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isDone,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive || isDone
        ? IMatColors.green
        : const Color(0xFFB8B2A4);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: IMatColors.white, size: 20)
                    : Text(
                        '$number',
                        style: IMatText.bodyS.copyWith(
                          color: IMatColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
            if (showLine)
              Container(width: 3, height: 44, color: const Color(0xFFB8B2A4)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IMatText.bodyS.copyWith(
                color: isActive || isDone
                    ? IMatColors.black
                    : IMatColors.textSecondary,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;

  const _Panel({
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PanelTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: IMatColors.green, size: 36),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IMatText.h1,
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: IMatText.bodyM,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: IMatText.bodyM.copyWith(color: Colors.grey.shade500),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: IMatColors.green, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionGrid extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _OptionGrid({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: IMatColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 24) / 3;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final child in children)
                    SizedBox(width: tileWidth, height: 82, child: child),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectableTile({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? IMatColors.greenLight : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? IMatColors.green : IMatColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _PaymentTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: IMatColors.black,
          backgroundColor: selected ? IMatColors.greenLight : Colors.white,
          side: BorderSide(
            color: selected ? IMatColors.green : IMatColors.border,
            width: selected ? 2 : 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _SummaryBox({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    final visibleLines = lines
        .where((line) => line.trim().isNotEmpty)
        .take(2)
        .toList();

    final hiddenCount =
        lines.where((line) => line.trim().isNotEmpty).length -
        visibleLines.length;

    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: IMatColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (final line in visibleLines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
              ),
            ),
          if (hiddenCount > 0)
            Text(
              '+ $hiddenCount rad${hiddenCount == 1 ? '' : 'er'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IMatText.bodyXS.copyWith(color: IMatColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final List<dynamic> items;
  final double total;

  const _OrderSummary({required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.take(2).toList();
    final hiddenCount = items.length - visibleItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: IMatColors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Ordersammanfattning',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: IMatText.h3,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _itemCountLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: IMatText.bodyS,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in visibleItems) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    '${item.total.toStringAsFixed(2)} kr',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatAmount(item.amount)} x ${item.product.price.toStringAsFixed(2)} kr',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IMatText.bodyS,
            ),
            const SizedBox(height: 10),
          ],
          if (hiddenCount > 0) ...[
            Text(
              '+ $hiddenCount fler varor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
            ),
            const SizedBox(height: 10),
          ],
          const Divider(height: 18, color: IMatColors.green),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Totalt:', style: IMatText.h3),
              Flexible(
                child: Text(
                  '${total.toStringAsFixed(2)} kr',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: IMatText.h3.copyWith(color: IMatColors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }

    return amount.toStringAsFixed(1);
  }

  String get _itemCountLabel {
    if (items.length == 1) {
      return '1 vara';
    }

    return '${items.length} varor';
  }
}

class _DeliveryDate {
  final String weekday;
  final String date;

  const _DeliveryDate(this.weekday, this.date);

  String get fullLabel => '$weekday $date';
}
