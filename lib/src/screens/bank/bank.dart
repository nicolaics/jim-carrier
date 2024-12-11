import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/api/bank_detail.dart';
import 'package:encrypt/encrypt.dart' as enc;
import '../../auth/encryption.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final TextEditingController _accountHolderName = TextEditingController();
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _bankAccountNo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBankDetails();
  }

  Future<void> _fetchBankDetails() async {
    try {
      // Fetch data from API
      final response = await getBankDetail();
      final message = response['message'];

      if (message != null) {
        // Attempt to decrypt data only if fields exist
        final encryptedHolderBase64 = message['accountHolder'] as String?;
        final encryptedNumberBase64 = message['accountNumber'] as String?;
        final bankName = message['bankName'] as String? ?? '';

        String accountHolderName = '';
        String accountNumber = '';

        if (encryptedHolderBase64 != null && encryptedNumberBase64 != null) {
          final encryptedHolder = enc.Encrypted.fromBase64(encryptedHolderBase64);
          final encryptedNumber = enc.Encrypted.fromBase64(encryptedNumberBase64);

          final decrypted = decryptData(
            accountHolder: encryptedHolder,
            accountNumber: encryptedNumber,
          );

          accountHolderName = decrypted['holder'] ?? '';
          accountNumber = decrypted['number'] ?? '';
        }

        // Populate controllers with decrypted data
        setState(() {
          _accountHolderName.text = accountHolderName;
          _bankName.text = bankName;
          _bankAccountNo.text = accountNumber;
        });
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching bank details: $e");
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _accountHolderName.dispose();
    _bankName.dispose();
    _bankAccountNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Holder Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _accountHolderName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Account Holder Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bank Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bankName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.house),
                labelText: "Bank Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bank Account Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bankAccountNo,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.numbers),
                labelText: "Account Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Handle Update
                  String bankName = _bankName.text.trim();
                  String accountHolder = _accountHolderName.text.trim();
                  String bankNumber = _bankAccountNo.text.trim();

                  // Validate Fields
                  if (bankName.isEmpty || accountHolder.isEmpty || bankNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Encrypt and Update
                    final encrypted = encryptData(
                      accountHolder: accountHolder,
                      accountNumber: bankNumber,
                    );

                    dynamic response = await updateBankDetail(
                      bankName: bankName,
                      accountNumber: encrypted["number"]!.base64,
                      accountHolder: encrypted["holder"]!.base64,
                    );

                    if (response['status'] == 'success') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        title: 'Success',
                        desc: 'Update Successful',
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {
                          Get.to(() => const BottomBar(0));
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.topSlide,
                        title: 'Update Failed',
                        desc: response["message"].toString().capitalizeFirst,
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Update Details',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
