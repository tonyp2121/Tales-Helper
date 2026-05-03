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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF152238),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white60, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Encounter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_step != _EncounterStep.showResult) ...[
                        // Step indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _stepDot(0,
                                active: _step.index >= 0, label: 'Chart'),
                            _stepLine(active: _step.index >= 1),
                            _stepDot(1,
                                active: _step.index >= 1, label: 'Die'),
                            _stepLine(active: _step.index >= 2),
                            _stepDot(2,
                                active: _step.index >= 2, label: 'City'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _promptText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (_step == _EncounterStep.enterCityNumber)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Number inside the gem/city icon (0 if none)',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 24),
                        Container(
                          width: 160,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD4A574)
                                  .withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _inputNumber.isEmpty
                                ? _placeholder
                                : _inputNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w300,
                              color: _inputNumber.isEmpty
                                  ? Colors.white24
                                  : Colors.white,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                        if (_encounterNum != null || _dieRoll != null) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            children: [
                              if (_encounterNum != null)
                                _contextChip(
                                    'Chart #$_encounterNum'),
                              if (_dieRoll != null)
                                _contextChip('Die: $_dieRoll'),
                            ],
                          ),
                        ],
                      ],
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 13),
                          ),
                        ),
                      ],
                      if (_step == _EncounterStep.showResult) ...[
                        // Calculation breakdown
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'ROLL BREAKDOWN',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  _rollChip('Die', _dieRoll!),
                                  _opText('+'),
                                  _rollChip('City', _cityNumber!),
                                  if (_destinyBonus! > 0) ...[
                                    _opText('+'),
                                    _rollChip(
                                        'Destiny', _destinyBonus!),
                                  ],
                                  _opText('='),
                                  _rollChip('Total', _totalRoll!,
                                      highlight: true),
                                ],
                              ),
                              if (_dieRoll! +
                                      _cityNumber! +
                                      _destinyBonus! >
                                  12)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'capped at 12',
                                    style: TextStyle(
                                        color: Colors.white24,
                                        fontSize: 11),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Result card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1B3A5C),
                                const Color(0xFF0F2640),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFD4A574)
                                  .withValues(alpha: 0.25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4A574)
                                    .withValues(alpha: 0.08),
                                blurRadius: 24,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Encounter #$_encounterNum',
                                style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _resultName ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFF0D9B5),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4A574)
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFD4A574)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  'Matrix ${_resultMatrix ?? ''}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4A574),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Number pad
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B2A),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildNumRow(['1', '2', '3']),
                    const SizedBox(height: 10),
                    _buildNumRow(['4', '5', '6']),
                    const SizedBox(height: 10),
                    _buildNumRow(['7', '8', '9']),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNumButton('⌫', onTap: _backspace),
                        const SizedBox(width: 10),
                        _buildNumButton('0',
                            onTap: () => _addDigit('0')),
                        const SizedBox(width: 10),
                        _buildNumButton(
                          _step == _EncounterStep.showResult
                              ? 'NEW'
                              : '→',
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
      ),
    );
  }

  Widget _stepDot(int index,
      {required bool active, required String label}) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFFD4A574).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: active
                  ? const Color(0xFFD4A574)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: active ? const Color(0xFFD4A574) : Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white54 : Colors.white24,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _stepLine({required bool active}) {
    return Container(
      width: 40,
      height: 1.5,
      margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      color: active
          ? const Color(0xFFD4A574).withValues(alpha: 0.5)
          : Colors.white.withValues(alpha: 0.08),
    );
  }

  Widget _contextChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }

  Widget _opText(String op) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(op,
          style: const TextStyle(color: Colors.white30, fontSize: 16)),
    );
  }

  Widget _rollChip(String label, int value, {bool highlight = false}) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: highlight
                ? const Color(0xFFD4A574).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: highlight
                  ? const Color(0xFFD4A574).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                color: highlight ? const Color(0xFFD4A574) : Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white30, fontSize: 10)),
      ],
    );
  }

  Widget _buildNumRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits
          .map((d) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _buildNumButton(d, onTap: () => _addDigit(d)),
              ))
          .toList(),
    );
  }

  Widget _buildNumButton(String label,
      {required VoidCallback onTap, bool isAction = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 52,
        decoration: BoxDecoration(
          color: isAction
              ? const Color(0xFFD4A574)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: isAction
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isAction ? 15 : 20,
              fontWeight: isAction ? FontWeight.w700 : FontWeight.w400,
              color: isAction ? const Color(0xFF0D1B2A) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
