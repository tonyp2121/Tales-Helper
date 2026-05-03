import 'dart:math';
import 'package:flutter/material.dart';
import '../data/encounter_data.dart';

class EncounterScreen extends StatefulWidget {
  const EncounterScreen({super.key});

  @override
  State<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen> {
  String _inputNumber = '';
  String? _resultName;
  String? _resultMatrix;
  String? _errorMessage;
  bool _hasResult = false;

  void _addDigit(String digit) {
    if (_inputNumber.length < 3) {
      setState(() {
        _inputNumber += digit;
        _errorMessage = null;
        _hasResult = false;
      });
    }
  }

  void _backspace() {
    if (_inputNumber.isNotEmpty) {
      setState(() {
        _inputNumber = _inputNumber.substring(0, _inputNumber.length - 1);
        _errorMessage = null;
        _hasResult = false;
      });
    }
  }

  void _submit() {
    if (_inputNumber.isEmpty) return;

    final encounterNum = int.tryParse(_inputNumber);
    if (encounterNum == null || encounterNum < 1 || encounterNum > 121) {
      setState(() {
        _errorMessage = 'Enter a number between 1 and 121';
        _hasResult = false;
      });
      return;
    }

    if (!EncounterData.isValidEncounter(encounterNum)) {
      setState(() {
        _errorMessage = 'Encounter $encounterNum does not exist';
        _hasResult = false;
      });
      return;
    }

    final encounterIndex = encounterNum - 1;
    final dieRoll = Random().nextInt(12); // 0-11

    final name = EncounterData.getName(encounterIndex, dieRoll);
    final matrix = EncounterData.getMatrix(encounterIndex, dieRoll);

    setState(() {
      _resultName = name;
      _resultMatrix = matrix;
      _errorMessage = null;
      _hasResult = true;
    });
  }

  void _clear() {
    setState(() {
      _inputNumber = '';
      _resultName = null;
      _resultMatrix = null;
      _errorMessage = null;
      _hasResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encounter Lookup'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter Encounter Number',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(height: 16),
                    // Input display
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD4A574),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _inputNumber.isEmpty ? '___' : _inputNumber,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    if (_hasResult) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: const Color(0xFF0F3460),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Text(
                                "You've encountered a",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _resultName ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFD4A574),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'type of creature',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFD4A574).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Matrix ${_resultMatrix ?? ''}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4A574),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Number pad
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF16213E),
              child: Column(
                children: [
                  _buildNumRow(['1', '2', '3']),
                  const SizedBox(height: 8),
                  _buildNumRow(['4', '5', '6']),
                  const SizedBox(height: 8),
                  _buildNumRow(['7', '8', '9']),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumButton('⌫', onTap: _backspace),
                      const SizedBox(width: 8),
                      _buildNumButton('0', onTap: () => _addDigit('0')),
                      const SizedBox(width: 8),
                      _buildNumButton(
                        _hasResult ? 'NEW' : '✓',
                        onTap: _hasResult ? _clear : _submit,
                        isAction: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits
          .map((d) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildNumButton(d, onTap: () => _addDigit(d)),
              ))
          .toList(),
    );
  }

  Widget _buildNumButton(String label,
      {required VoidCallback onTap, bool isAction = false}) {
    return SizedBox(
      width: 80,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isAction ? const Color(0xFFD4A574) : const Color(0xFF0F3460),
          foregroundColor: isAction ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isAction ? 16 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
