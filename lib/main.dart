import 'package:material_ui/material_ui.dart';

import 'domain/bmi.dart';

void main() => runApp(const BmiApp());

class BmiApp extends StatelessWidget {
  const BmiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Calculadora de IMC',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006B64)),
      scaffoldBackgroundColor: const Color(0xFFF6F7F4),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(20),
      ),
    ),
    home: const BmiPage(),
  );
}

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _form = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _weightFocus = FocusNode();
  final _heightFocus = FocusNode();
  HeightUnit _unit = HeightUnit.centimeters;
  BodyMeasurements? _result;
  bool _submitted = false;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _weightFocus.dispose();
    _heightFocus.dispose();
    super.dispose();
  }

  String? _validate(double Function() parse) {
    try {
      parse();
      return null;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  void _calculate() {
    setState(() => _submitted = true);
    if (!_form.currentState!.validate()) {
      setState(() => _result = null);
      if (_validate(() => BodyMeasurements.parseWeight(_weight.text)) != null) {
        _weightFocus.requestFocus();
      } else {
        _heightFocus.requestFocus();
      }
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _result = BodyMeasurements.parse(_weight.text, _height.text, _unit);
    });
  }

  void _reset() {
    _form.currentState!.reset();
    _weight.clear();
    _height.clear();
    setState(() {
      _result = null;
      _unit = HeightUnit.centimeters;
      _submitted = false;
    });
    _weightFocus.requestFocus();
  }

  void _changeUnit(Set<HeightUnit> selection) {
    final weight = _weight.text;
    _form.currentState!.reset();
    _weight.text = weight;
    _height.clear();
    setState(() {
      _unit = selection.single;
      _submitted = false;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final panels = [_buildForm(), _ResultCard(result: _result)];
                    if (constraints.maxWidth < 800 ||
                        MediaQuery.textScalerOf(context).scale(16) > 24) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          panels[0],
                          const SizedBox(height: 24),
                          panels[1],
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: panels[0]),
                        const SizedBox(width: 24),
                        Expanded(child: panels[1]),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const _ReferenceCard(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildForm() => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _form,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        onChanged: () => setState(() => _result = null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '01 / Suas medidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use vírgula ou ponto decimal, sem separador de milhar.',
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('weight'),
              controller: _weight,
              focusNode: _weightFocus,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                hintText: 'Ex.: 70,5',
                helperText: 'De 20 a 500 kg',
                errorMaxLines: 3,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _heightFocus.requestFocus(),
              validator: (_) =>
                  _validate(() => BodyMeasurements.parseWeight(_weight.text)),
            ),
            const SizedBox(height: 24),
            const Text('Unidade da altura'),
            const SizedBox(height: 8),
            SegmentedButton<HeightUnit>(
              segments: const [
                ButtonSegment(
                  value: HeightUnit.centimeters,
                  label: Text('Centímetros'),
                ),
                ButtonSegment(value: HeightUnit.meters, label: Text('Metros')),
              ],
              selected: {_unit},
              onSelectionChanged: _changeUnit,
              showSelectedIcon: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('height'),
              controller: _height,
              focusNode: _heightFocus,
              decoration: InputDecoration(
                labelText: 'Altura (${_unit.symbol})',
                hintText: _unit == HeightUnit.centimeters
                    ? 'Ex.: 175'
                    : 'Ex.: 1,75',
                helperText: _unit == HeightUnit.centimeters
                    ? 'De 100 a 250 cm'
                    : 'De 1 a 2,5 m',
                errorMaxLines: 3,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _calculate(),
              validator: (_) => _validate(
                () => BodyMeasurements.parseHeight(_height.text, _unit),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _calculate,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('Calcular IMC'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _reset,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('Reiniciar'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ao trocar a unidade, preencha a altura novamente. As medidas ficam apenas nesta sessão.',
            ),
          ],
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'FLUTTER / LAB DE FORMULÁRIOS',
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: const Color(0xFF006B64), letterSpacing: 1.5),
      ),
      const SizedBox(height: 16),
      Text(
        'Calculadora de IMC',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF172D39),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Entenda o cálculo. Confira suas medidas.',
        style: TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 12),
      const Text(
        'Referência geral para adultos de 20 anos ou mais, fora da gestação. O IMC isolado não é um diagnóstico.',
      ),
    ],
  );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final BodyMeasurements? result;
  @override
  Widget build(BuildContext context) {
    final value = result;
    return Semantics(
      liveRegion: true,
      child: Card(
        margin: EdgeInsets.zero,
        color: const Color(0xFF173D43),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '02 / Resultado',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                if (value == null) ...[
                  const Icon(
                    Icons.calculate_outlined,
                    size: 48,
                    color: Color(0xFFBCEDE2),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Seu resultado aparece aqui',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Preencha peso e altura e selecione Calcular IMC.',
                  ),
                ] else ...[
                  Text(
                    value.bmi.toStringAsFixed(1).replaceAll('.', ','),
                    style: const TextStyle(
                      fontSize: 64,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('kg/m² · índice de massa corporal'),
                  const SizedBox(height: 24),
                  Text(
                    value.category.label,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text('Faixa de referência: ${value.category.range}.'),
                  const SizedBox(height: 16),
                  const Text(
                    'A classificação usa o valor completo. O número exibido foi arredondado para uma casa decimal.',
                  ),
                ],
                const SizedBox(height: 28),
                const Divider(color: Color(0xFF79999A)),
                const SizedBox(height: 12),
                const Text(
                  'Como calculamos',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text('IMC = peso (kg) ÷ altura (m)²'),
                const SizedBox(height: 12),
                const Text(
                  'O índice não diferencia músculo e gordura. Sua interpretação depende de contexto e avaliação profissional.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  const _ReferenceCard();
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: const Color(0xFFE7EEEA),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entenda as faixas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Referência: CDC, Adult BMI Categories. A fórmula e estas faixas não mudam por gênero.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: [
              for (final category in BmiCategory.values)
                SizedBox(
                  width: 270,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('${category.range} kg/m²'),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Exemplo educativo: limites de entrada de 20–500 kg e 1–2,5 m. Não são limites clínicos. Não use estas faixas para crianças, adolescentes ou gestantes; elas exigem critérios específicos.',
          ),
        ],
      ),
    ),
  );
}
