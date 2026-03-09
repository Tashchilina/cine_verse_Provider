import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_notifier.dart';
import 'otp_page.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String _fullPhoneNumber = '';

  void _onContinuePressed(AuthNotifier auth) {
    if (_fullPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    final phoneNumberToSend = _fullPhoneNumber;

    auth.verifyPhoneNumber(
      phoneNumberToSend,
      onCodeSent: () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage(phoneNumber: phoneNumberToSend)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter the phone number')),
      body: Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                IntlPhoneField(
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  initialCountryCode: 'RU',
                  onChanged: (phone) {
                    setState(() {
                    _fullPhoneNumber = phone.completeNumber;
                    });
                  },
                ),
                const SizedBox(height: 20),

                auth.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _onContinuePressed(auth),
                          child: const Text('Continue'),
                        ),
                      ),

                // Отображение ошибки, если она есть
                if (auth.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      auth.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
