import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/encounter_data.dart';
import '../models/game_state.dart';

enum _EncounterStep { enterEncounter, enterDieRoll, enterCityNumber, showResult }

class EncounterScreen extends StatefulWidget {
  const EncounterScreen({super.key});

  @override
  State<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen> {
  String _inputNumber = '';
  int? _encounterNum;
  int? _dieRoll;
  int? _cityNumber;
  int? _destinyBonus;
  int? _totalRoll;
  String? _resultName;
  String? _resultMatrix;
  String? _errorMessage;
  _EncounterStep _step = _EncounterStep.enterEncounter;

  int _getDestinyBonus(int destinyPoints) {
    if (destinyPoints >= 5) return 2;
    if (destinyPoints >= 3) return 1;
    return 0;
  }

  void _addDigit(String digit) {
    final maxLen = _step == _EncounterStep.enterEncounter ? 3 : 1;
    if (_inputNumber.length < maxLen) {
      setState(() {
        _inputNumber += digit;
        _errorMessage = null;
      });
    }
  }

  void _backspace() {
    if (_inputNumber.isNotEmpty) {
      setState(() {
        _inputNumber = _inputNumber.substring(0, _inputNumber.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _submit() {
    if (_inputNumber.isEmpty) return;

    if (_step == _EncounterStep.enterEncounter) {
      final encounterNum = int.tryParse(_inputNumber);
      if (encounterNum == null || encounterNum < 1 || encounterNum > 121) {
        setState(() => _errorMessage = 'Enter a number between 1 and 121');
        return;
      }
      if (!EncounterData.isValidEncounter(encounterNum)) {
        setState(() => _errorMessage = 'Encounter $encounterNum does not exist');
        return;
      }
      setState(() {
        _encounterNum = encounterNum;
        _inputNumber = '';
        _errorMessage = null;
        _step = _EncounterStep.enterDieRoll;
      });
    } else if (_step == _EncounterStep.enterDieRoll) {
      final dieRoll = int.tryParse(_inputNumber);
      if (dieRoll == null || dieRoll < 1 || dieRoll > 6) {
        setState(() => _errorMessage = 'Enter your die roll (1-6)');
        return;
      }
      setState(() {
        _dieRoll = dieRoll;
        _inputNumber = '';
        _errorMessage = null;
        _step = _EncounterStep.enterCityNumber;
      });
    } else if (_step == _EncounterStep.enterCityNumber) {
      final cityNum = int.tryParse(_inputNumber);
      if (cityNum == null || cityNum < 0 || cityNum > 9) {
        setState(() => _errorMessage = 'Enter the city/gem number (0-9)');
        return;
      }
      _calculateResult(cityNum);
    }
  }

  void _calculateResult(int cityNum) {
    final state = Provider.of<GameState>(context, listen: false);
    final destinyBonus = _getDestinyBonus(state.currentPlayer.destinyPoints);
    var total = _dieRoll! + cityNum + destinyBonus;
    if (total > 12) total = 12;
    if (total < 1) total = 1;

    final encounterIndex = _encounterNum! - 1;
    final rollIndex = total - 1; // convert 1-12 to 0-11

    final name = EncounterData.getName(encounterIndex, rollIndex);
    final matrix = EncounterData.getMatrix(encounterIndex, rollIndex);

    setState(() {
      _cityNumber = cityNum;
      _destinyBonus = destinyBonus;
      _totalRoll = total;
      _resultName = name;
      _resultMatrix = matrix;
      _errorMessage = null;
      _step = _EncounterStep.showResult;
    });
  }

  void _clear() {
    setState(() {
      _inputNumber = '';
      _encounterNum = null;
      _dieRoll = null;
      _cityNumber = null;
      _destinyBonus = null;
      _totalRoll = null;
      _resultName = null;
      _resultMatrix = null;
      _errorMessage = null;
      _step = _EncounterStep.enterEncounter;
    });
  }

  String get _promptText {
    switch (_step) {
      case _EncounterStep.enterEncounter:
        return 'Enter Encounter Number';
      case _EncounterStep.enterDieRoll:
        return 'Enter Die Roll (1-6)';
      case _EncounterStep.enterCityNumber:
        return 'Enter City/Gem Number';
      case _EncounterStep.showResult:
        return '';
    }
  }

  String get _placeholder {
    switch (_step) {
      case _EncounterStep.enterEncounter:
        return '___';
      case _EncounterStep.enterDieRoll:
      case _EncounterStep.enterCityNumber:
        return '_';
      case _EncounterStep.showResult:
        return '';
    }
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_step != _EncounterStep.showResult) ...[
                      Text(
                        _promptText,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      if (_step == _EncounterStep.enterCityNumber)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Number inside the gem/city icon (0 if none)',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 16),
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
                          _inputNumber.isEmpty ? _placeholder : _inputNumber,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      // Show context of what's been entered so far
                      if (_encounterNum != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Encounter #$_encounterNum',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                        ),
                      ],
                      if (_dieRoll != null)
                        Text(
                          'Die roll: $_dieRoll',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                        ),
                    ],
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    if (_step == _EncounterStep.showResult) ...[
                      // Calculation breakdown
                      Card(
                        color: const Color(0xFF16213E),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Roll Calculation',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _rollChip('Die', _dieRoll!),
                                  const Text(' + ',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 18)),
                                  _rollChip('City', _cityNumber!),
                                  if (_destinyBonus! > 0) ...[
                                    const Text(' + ',
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 18)),
                                    _rollChip('Destiny', _destinyBonus!),
                                  ],
                                  const Text(' = ',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 18)),
                                  _rollChip('Total', _totalRoll!,
                                      highlight: true),
                                ],
                              ),
                              if (_dieRoll! + _cityNumber! + _destinyBonus! > 12)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    '(capped at 12)',
                                    style: TextStyle(
                                        color: Colors.white38, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Result card
                      Card(
                        color: const Color(0xFF0F3460),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Encounter #$_encounterNum',
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _resultName ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFD4A574),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4A574)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Matrix ${_resultMatrix ?? ''}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4A574),
                                    fontSize: 22,
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
                        _step == _EncounterStep.showResult ? 'NEW' : '✓',
                        onTap: _step == _EncounterStep.showResult
                            ? _clear
                            : _submit,
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

  Widget _rollChip(String label, int value, {bool highlight = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: highlight
                ? const Color(0xFFD4A574).withValues(alpha: 0.3)
                : const Color(0xFF0F3460),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              color: highlight ? const Color(0xFFD4A574) : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
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
