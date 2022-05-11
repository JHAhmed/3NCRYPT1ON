import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:encryption_app/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String alphabet = "abcdefghijklmnopqrstuvwxyz";

  var alphabetList = List.empty(growable: true);

  var numbers = List.empty(growable: true);

  var numbersList = List.empty(growable: true);

  var connection1 = {};

  var connection2 = {};

  var output = List.empty(growable: true);

  void addLetters() {
    for (var i = 0; i < alphabet.length; i++) {
      connection1[i] = alphabet[i].toString();
      connection2[alphabet[i].toString()] = i;
    }
  }

  int findKey(String inputKey) {
    var key = connection1.keys
        .firstWhere((k) => connection1[k] == inputKey, orElse: () => null);

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

    var output2 = List.empty(growable: true);
    var numbers2 = List.empty(growable: true);
    for (var i = 0; i < inputText.length; i++) {
      numbers2.add(findKey(inputText[i]) - 1);
    }
    for (var i = 0; i < numbers2.length; i++) {
      output2.add(findValue(numbers2[i]));
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
      alphabetList.add(inputText[i]);
      numbers.add(findKey(inputText[i]));
    }

    for (var i = 0; i < numbers.length; i++) {
      numbers[i] += 1;
      output.add(findValue(numbers[i]));
    }

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
                  globals.decryptValue = value;
                },
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
                onSubmitted: (value) {
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
            const SizedBox(
              height: 10,
            ),
            // Expanded(child: Container()),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     "Made with love,\nand lots of code",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w300,
            //       letterSpacing: 2,
            //     ),
            //   ),
            // ),
            // const Icon(Icons.favorite),
            // const SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }
}
