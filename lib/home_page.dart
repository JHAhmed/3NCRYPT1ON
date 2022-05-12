import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:encryption_app/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String alphabet = "abcdefghijklmnopqrstuvwxyz";

  var alphabetList = List.empty(growable: true);
  var numbers = List.empty(growable: true);
  var numbersList = List.empty(growable: true);
  var connection1 = {};
  var connection2 = {};
  var output2 = List.empty(growable: true);
  var numbers2 = List.empty(growable: true);
  var output = List.empty(growable: true);

  void clearData() {
    alphabetList.clear();
    numbers.clear();
    numbers2.clear();
    numbersList.clear();
    connection1.clear();
    connection2.clear();
    output.clear();
    output2.clear();
    _controller1.clear();
    _controller2.clear();
  }

  void addLetters() {
    for (var i = 0; i < alphabet.length; i++) {
      connection1[i] = alphabet[i].toString();
      connection2[alphabet[i].toString()] = i;
    }
  }

  int findKey(String inputKey) {
    var key = connection1.keys
        .firstWhere((k) => connection1[k] == inputKey, orElse: () => 500);

    return key;
  }

  String findValue(int inputValue) {
    var value = connection2.keys
        .firstWhere((k) => connection2[k] == inputValue, orElse: () => null);

    return value.toString();
  }

  String decryptText(String inputText) {
    addLetters();
    addLetters();

    for (var i = 0; i < inputText.length; i++) {
      if (inputText[i] == "\\") {
        numbers2.add(100);
      } else {
        numbers2.add(findKey(inputText[i]) - 1);
      }
    }

    for (var i = 0; i < numbers2.length; i++) {
      if (numbers2[i] == 100) {
        output2.add(" ");
      } else {
        output2.add(findValue(numbers2[i]));
      }
    }

    log(output2.join().toString());
    return output2.join().toString();
  }

  String encryptText(String inputText) {
    for (var i = 0; i < alphabet.length; i++) {
      connection1[i] = alphabet[i].toString();
      connection2[alphabet[i].toString()] = i;
      numbersList.add(i);
    }

    addLetters();

    for (var i = 0; i < inputText.length; i++) {
      if (inputText[i] == " ") {
        alphabetList.add("\\");
        numbers.add(100);
      } else {
        alphabetList.add(inputText[i]);
        numbers.add(findKey(inputText[i]));
      }
    }

    for (var i = 0; i < numbers.length; i++) {
      numbers[i] += 1;
      if (numbers[i] < 100) {
        output.add(findValue(numbers[i]));
      } else {
        output.add("\\");
      }
    }
    log(output.toString());
    return output.join().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "3ncrypt1on".toUpperCase(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 10),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(
              globals.outputValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  value = value.toLowerCase();
                  globals.decryptValue = value;
                },
                controller: _controller1,
                decoration: const InputDecoration(
                  hintText: "Encrypted text...",
                  labelText: "Enter encrypted text:",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                globals.outputValue = decryptText(globals.decryptValue);
                setState(() {});
                clearData();
              },
              child: const Text(
                "DECRYPT",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {},
                controller: _controller2,
                onSubmitted: (value) {
                  value = value.toLowerCase();
                  globals.copyValue = value;
                },
                decoration: const InputDecoration(
                  hintText: "Normal text...",
                  labelText: "Enter normal text:",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: encryptText(globals.copyValue)));
                clearData();
              },
              child: const Text(
                "COPY",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 5),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     clearData();
            //   },
            //   child: const Text(
            //     "CLEAR",
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w700,
            //         fontSize: 14,
            //         letterSpacing: 5),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
