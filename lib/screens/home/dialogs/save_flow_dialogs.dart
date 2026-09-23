import 'package:flutter/material.dart';

import '../../../widgets/text_button_generic.dart';

Future<bool> confirmOverwrite(BuildContext context) async {
  final overwrite = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Substituir local salvo?'),
      content: const Text(
        'Você ainda não voltou ao local salvo anteriormente. '
        'Deseja substituí-lo pelo local atual?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Substituir'),
        ),
      ],
    ),
  );
  return overwrite ?? false;
}

Future<bool> askToTakePhoto(BuildContext context) async {
  final wantsPhoto = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tirar uma foto do local?'),
      content: const Text('Ajuda a lembrar o número da vaga, setor ou andar.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Agora não'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.photo_camera),
          label: const Text('Tirar foto'),
        ),
      ],
    ),
  );
  return wantsPhoto ?? false;
}

Future<String?> askForNote(BuildContext context) => showDialog<String>(
  context: context,
  builder: (context) => const NoteDialog(),
);

class NoteDialog extends StatefulWidget {
  const NoteDialog({super.key});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final note = _text.text.trim();
    Navigator.pop(context, note.isEmpty ? null : note);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar uma nota'),
      content: TextField(
        controller: _text,
        autofocus: true,
        maxLines: 5,
        minLines: 3,
        textCapitalization: .sentences,
        decoration: const InputDecoration(
          labelText: 'Opcional',
          hintText: 'Ex: Piso 2, Setor B, vaga 34',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButtonGeneric(() => Navigator.pop(context), 'Pular'),
        FilledButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }
}
