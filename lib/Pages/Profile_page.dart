import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/LogoutButton%20.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/CloseProfile_Button.dart';
import 'package:imat_repo/Widgets/Profile_Parts/profile_constants.dart';
import 'package:imat_repo/Widgets/Profile_Parts/profile_editable_field.dart';
import 'package:imat_repo/Widgets/Profile_Parts/profile_module_tabs.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

const String accountTabTitle = 'Kontoinformation';
const String addressTabTitle = 'Adress';
const String paymentTabTitle = 'Betalningsinformation';
const String accountHelperText =
    'Uppdatera namn, kontaktuppgifter och inloggningsnamn.';
const String addressHelperText =
    'Spara den adress som används som förval vid leverans.';
const String paymentHelperText =
    'Hantera sparade uppgifter för kort och faktura.';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _initialized = false;
  bool _syncedLoadedProfileData = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobilePhoneController;
  late final TextEditingController _phoneController;
  late final TextEditingController _userNameController;

  late final TextEditingController _addressController;
  late final TextEditingController _postCodeController;
  late final TextEditingController _cityController;

  late final TextEditingController _cardHolderController;
  late final TextEditingController _cardTypeController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardCvvController;
  late final TextEditingController _cardMonthController;
  late final TextEditingController _cardYearController;
  late final TextEditingController _invoiceEmailController;
  late final TextEditingController _invoicePhoneController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    final handler = context.read<ImatDataHandler>();
    final customer = handler.getCustomer();
    final card = handler.getCreditCard();
    final user = handler.getUser();

    _firstNameController = TextEditingController(text: customer.firstName);
    _lastNameController = TextEditingController(text: customer.lastName);
    _emailController = TextEditingController(text: customer.email);
    _mobilePhoneController = TextEditingController(
      text: customer.mobilePhoneNumber,
    );
    _phoneController = TextEditingController(text: customer.phoneNumber);
    _userNameController = TextEditingController(text: user.userName);

    _addressController = TextEditingController(text: customer.address);
    _postCodeController = TextEditingController(text: customer.postCode);
    _cityController = TextEditingController(text: customer.postAddress);

    _cardHolderController = TextEditingController(text: card.holdersName);
    _cardTypeController = TextEditingController(text: card.cardType);
    _cardNumberController = TextEditingController(text: card.cardNumber);
    _cardCvvController = TextEditingController(
      text: card.verificationCode.toString(),
    );
    _cardMonthController = TextEditingController(
      text: card.validMonth.toString(),
    );
    _cardYearController = TextEditingController(
      text: card.validYear.toString(),
    );
    _invoiceEmailController = TextEditingController(text: customer.email);
    _invoicePhoneController = TextEditingController(
      text: customer.mobilePhoneNumber,
    );

    _initialized = true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobilePhoneController.dispose();
    _phoneController.dispose();
    _userNameController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _cardHolderController.dispose();
    _cardTypeController.dispose();
    _cardNumberController.dispose();
    _cardCvvController.dispose();
    _cardMonthController.dispose();
    _cardYearController.dispose();
    _invoiceEmailController.dispose();
    _invoicePhoneController.dispose();
    super.dispose();
  }

  void _saveCustomer({
    String? firstName,
    String? lastName,
    String? email,
    String? mobilePhone,
    String? phone,
    String? address,
    String? postCode,
    String? city,
  }) {
    final handler = context.read<ImatDataHandler>();
    final customer = handler.getCustomer();

    customer.firstName = firstName ?? customer.firstName;
    customer.lastName = lastName ?? customer.lastName;
    customer.email = email ?? customer.email;
    customer.mobilePhoneNumber = mobilePhone ?? customer.mobilePhoneNumber;
    customer.phoneNumber = phone ?? customer.phoneNumber;
    customer.address = address ?? customer.address;
    customer.postCode = postCode ?? customer.postCode;
    customer.postAddress = city ?? customer.postAddress;

    handler.setCustomer(customer);
  }

  void _saveUserName(String userName) {
    final handler = context.read<ImatDataHandler>();
    final user = handler.getUser();
    user.userName = userName;
    handler.setUser(user);
  }

  void _saveCard({
    String? holder,
    String? type,
    String? number,
    String? cvv,
    String? month,
    String? year,
  }) {
    final handler = context.read<ImatDataHandler>();
    final card = handler.getCreditCard();

    card.holdersName = holder ?? card.holdersName;
    card.cardType = type ?? card.cardType;
    card.cardNumber = number ?? card.cardNumber;
    card.verificationCode = int.tryParse(cvv ?? '') ?? card.verificationCode;
    card.validMonth = int.tryParse(month ?? '') ?? card.validMonth;
    card.validYear = int.tryParse(year ?? '') ?? card.validYear;

    handler.setCreditCard(card);
  }

  void _syncLoadedProfileData(ImatDataHandler handler) {
    if (!_initialized || _syncedLoadedProfileData) {
      return;
    }

    final customer = handler.getCustomer();
    final card = handler.getCreditCard();
    final user = handler.getUser();
    final hasLoadedProfileData =
        customer.firstName.isNotEmpty ||
        customer.lastName.isNotEmpty ||
        customer.email.isNotEmpty ||
        customer.address.isNotEmpty ||
        card.cardNumber.isNotEmpty ||
        user.userName.isNotEmpty;

    if (!hasLoadedProfileData) {
      return;
    }

    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _emailController.text = customer.email;
    _mobilePhoneController.text = customer.mobilePhoneNumber;
    _phoneController.text = customer.phoneNumber;
    _userNameController.text = user.userName;

    _addressController.text = customer.address;
    _postCodeController.text = customer.postCode;
    _cityController.text = customer.postAddress;

    _cardHolderController.text = card.holdersName;
    _cardTypeController.text = card.cardType;
    _cardNumberController.text = card.cardNumber;
    _cardCvvController.text = card.verificationCode.toString();
    _cardMonthController.text = card.validMonth.toString();
    _cardYearController.text = card.validYear.toString();
    _invoiceEmailController.text = customer.email;
    _invoicePhoneController.text = customer.mobilePhoneNumber;

    _syncedLoadedProfileData = true;
  }

  @override
  Widget build(BuildContext context) {
    _syncLoadedProfileData(context.watch<ImatDataHandler>());

    return Scaffold(
      backgroundColor: profilePageBackground,
      appBar: const IMatNavbar(activePage: NavbarPage.profile),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 900 ? 20.0 : 40.0;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      96,
                      horizontalPadding,
                      34,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: profileMaxWidth,
                        ),
                        child: ProfileModuleTabs(
                          tabs: [
                            ProfileModuleTab(
                              title: accountTabTitle,
                              icon: Icons.person,
                              child: _buildAccountModule(),
                            ),
                            ProfileModuleTab(
                              title: addressTabTitle,
                              icon: Icons.home,
                              child: _buildAddressModule(),
                            ),
                            ProfileModuleTab(
                              title: paymentTabTitle,
                              icon: Icons.credit_card,
                              child: _buildPaymentModule(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(top: 24, left: 24, child: LogoutButton()),
                const Positioned(
                  top: 12,
                  right: 16,
                  child: CloseProfileButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountModule() {
    return ProfileModuleSurface(
      title: accountTabTitle,
      helperText: accountHelperText,
      icon: Icons.person,
      groups: [
        ProfileFieldGroup(
          fields: [
            ProfileEditableField(
              label: 'Förnamn',
              controller: _firstNameController,
              onSave: (value) => _saveCustomer(firstName: value),
            ),
            ProfileEditableField(
              label: 'E-post',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onSave: (value) {
                _invoiceEmailController.text = value;
                _saveCustomer(email: value);
              },
            ),
            ProfileEditableField(
              label: 'Efternamn',
              controller: _lastNameController,
              onSave: (value) => _saveCustomer(lastName: value),
            ),

            ProfileEditableField(
              label: 'Mobilnummer',
              controller: _mobilePhoneController,
              keyboardType: TextInputType.phone,
              onSave: (value) {
                _invoicePhoneController.text = value;
                _saveCustomer(mobilePhone: value);
              },
            ),
            ProfileEditableField(
              label: 'Telefon',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onSave: (value) => _saveCustomer(phone: value),
            ),
            ProfileEditableField(
              label: 'Användarnamn',
              controller: _userNameController,
              onSave: _saveUserName,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressModule() {
    return ProfileModuleSurface(
      title: addressTabTitle,
      helperText: addressHelperText,
      icon: Icons.home,
      groups: [
        ProfileFieldGroup(
          fields: [
            ProfileEditableField(
              label: 'Gatuadress',
              controller: _addressController,
              onSave: (value) => _saveCustomer(address: value),
            ),
            ProfileEditableField(
              label: 'Postnummer',
              controller: _postCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onSave: (value) => _saveCustomer(postCode: value),
            ),
            ProfileEditableField(
              label: 'Ort',
              controller: _cityController,
              onSave: (value) => _saveCustomer(city: value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentModule() {
    return ProfileModuleSurface(
      title: paymentTabTitle,
      helperText: paymentHelperText,
      icon: Icons.credit_card,
      groups: [
        ProfileFieldGroup(
          title: 'Betalkort',
          fields: [
            ProfileEditableField(
              label: 'Kortinnehavare',
              controller: _cardHolderController,
              onSave: (value) => _saveCard(holder: value),
            ),
            ProfileEditableField(
              label: 'Korttyp',
              controller: _cardTypeController,
              onSave: (value) => _saveCard(type: value),
            ),
            ProfileEditableField(
              label: 'Kortnummer',
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 19,
              onSave: (value) => _saveCard(number: value),
            ),
            ProfileEditableField(
              label: 'CVV',
              controller: _cardCvvController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              onSave: (value) => _saveCard(cvv: value),
            ),
            ProfileEditableField(
              label: 'Månad',
              controller: _cardMonthController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              onSave: (value) => _saveCard(month: value),
            ),
            ProfileEditableField(
              label: 'År',
              controller: _cardYearController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              onSave: (value) => _saveCard(year: value),
            ),
          ],
        ),
        ProfileFieldGroup(
          title: 'Faktura',
          fields: [
            ProfileEditableField(
              label: 'Faktura e-post',
              controller: _invoiceEmailController,
              keyboardType: TextInputType.emailAddress,
              onSave: (value) {
                _emailController.text = value;
                _saveCustomer(email: value);
              },
            ),
            ProfileEditableField(
              label: 'Faktura telefon',
              controller: _invoicePhoneController,
              keyboardType: TextInputType.phone,
              onSave: (value) {
                _mobilePhoneController.text = value;
                _saveCustomer(mobilePhone: value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
