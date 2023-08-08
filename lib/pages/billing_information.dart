import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/my_api.dart';
import 'home.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String id = '0';
  int syid = 1;
  int semid = 1;
  String selectedYear = '';
  List<String> years = [];
  List<Ledger> data = [];
  List<EnrollmentInfo> enInfoData = [];

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // enrollment info dropdown yearly
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 0, bottom: 0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            color: Colors.indigo[
                                800], // Replace with your desired tinted color
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.filter_alt_outlined,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    'School Year',
                                    style: GoogleFonts.prompt(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              selectedYear.isNotEmpty
                                  ? DropdownButton<String>(
                                      value: selectedYear,
                                      hint: const Text('Select Year'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYear = newValue!;
                                          for (var yr in enInfoData) {
                                            if (yr.sydesc == selectedYear) {
                                              syid = yr.syid;
                                              semid = yr.semid;
                                              getLedger();
                                            }
                                          }
                                        });
                                      },
                                      items:
                                          years.map<DropdownMenuItem<String>>(
                                        (String year) {
                                          return DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(
                                              year,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .white, // Replace with your desired text color
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      style: const TextStyle(
                                        color: Colors
                                            .black, // Replace with your desired text color
                                      ),
                                      underline:
                                          Container(), // To hide the underline
                                      dropdownColor: Colors.indigo[
                                          500], // Replace with your desired dropdown background color
                                    )
                                  : const CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: data.isNotEmpty
                          ? data.map((item) {
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: ListTile(
                                    title: Text(item.particulars),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Amount: ${item.amount}'),
                                        Text('Payment: ${item.payment}'),
                                        item.particulars
                                                .toLowerCase()
                                                .contains('total')
                                            ? Text('Balance: ${item.balance}')
                                            : const SizedBox(
                                                width: 0,
                                              ),
                                      ],
                                    ),
                                    leading: const Icon(Icons.payment),
                                  ),
                                ),
                              );
                            }).toList()
                          : [const Text('Empty Billing')],
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }

  Future<void> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('studid');

    if (json != null) {
      setState(() {
        id = json;
      });
      getEnrollment();
    }
  }

  getLedger() async {
    await CallApi().getStudLedger(id, syid, semid).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        data = list.map((model) {
          return Ledger.fromJson(model);
        }).toList();
      });
    });
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(id).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          // years2.add(Yearly(syid: element.syid, year: element.sydesc));
          years.add(element.sydesc);
        }
        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();
        selectedYear = enInfoData[enInfoData.length - 1].sydesc;
        for (var yr in enInfoData) {
          if (yr.sydesc == selectedYear) {
            print("has match");
            setState(() {
              syid = yr.syid;
              semid = yr.semid;
            });
            getLedger();
          }
        }
      });
    });
  }
}

class Ledger {
  final String particulars;
  final String amount;
  final String payment;
  final String balance;

  Ledger({
    required this.particulars,
    required this.amount,
    required this.payment,
    required this.balance,
  });

  factory Ledger.fromJson(Map json) {
    var particulars = json['particulars'] ?? '';
    var amount = json['amount'] ?? '';
    var payment = json['payment'] ?? '';
    var balance = json['balance'] ?? '';
    return Ledger(
        particulars: particulars,
        amount: amount,
        payment: payment,
        balance: balance);
  }
}
