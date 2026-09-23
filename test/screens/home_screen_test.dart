import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ondeestacionei/app.dart';
import 'package:ondeestacionei/controllers/parking_controller.dart';
import 'package:ondeestacionei/controllers/theme_controller.dart';

import '../helpers/fakes.dart';

void main() {
  late FakeLocationService location;
  late ParkingController controller;

  setUp(() async {
    location = FakeLocationService();
    controller = ParkingController(
      repository: FakeRepository(),
      location: location,
      photos: FakePhotoService(),
      notifications: FakeNotificationService(),
    );
    await controller.load();
  });

  Future<void> pumpApp(WidgetTester tester) => tester.pumpWidget(
    OndeEstacioneiApp(
      controller: controller,
      themeController: ThemeController(),
      navigation: FakeNavigationLauncher(),
    ),
  );

  testWidgets('shows empty state when nothing is saved', (tester) async {
    await pumpApp(tester);

    expect(find.text('Nenhum local salvo'), findsOneWidget);
    expect(find.text('Salvar local do carro'), findsOneWidget);
    expect(find.text('Me leve até lá'), findsNothing);
  });

  testWidgets('without GPS, saves a spot with a manual note', (tester) async {
    location.nextCoordinates = null;
    await pumpApp(tester);

    Future<void> pumpDialog() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    await tester.tap(find.text('Salvar local do carro'));
    await pumpDialog();
    await tester.tap(find.text('Agora não'));
    await pumpDialog();
    await tester.enterText(find.byType(TextField), 'Piso 2, vaga 34');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(controller.current?.note, 'Piso 2, vaga 34');
    expect(find.text('Salvo sem GPS'), findsOneWidget);
    expect(find.text('Piso 2, vaga 34'), findsOneWidget);
  });

  testWidgets('history dialog lists previous spots', (tester) async {
    await controller.save(note: 'Shopping, piso 2');
    await controller.save(note: 'Trabalho');
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.history_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Histórico'), findsOneWidget);
    expect(find.text('Shopping, piso 2'), findsOneWidget);
  });

  testWidgets('theme sheet switches mode and palette', (tester) async {
    final themeController = ThemeController();
    await tester.pumpWidget(
      OndeEstacioneiApp(
        controller: controller,
        themeController: themeController,
        navigation: FakeNavigationLauncher(),
      ),
    );

    await tester.tap(find.byIcon(Icons.palette_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Aparência'), findsOneWidget);

    await tester.tap(find.text('Escuro'));
    await tester.pumpAndSettle();
    expect(themeController.mode, ThemeMode.dark);

    await tester.tap(find.text('Esmeralda'));
    await tester.pumpAndSettle();
    expect(themeController.palette.id, 'esmeralda');
  });

  testWidgets('asks for confirmation before overwriting an unvisited spot', (
    tester,
  ) async {
    await controller.save(note: 'Primeiro');
    await pumpApp(tester);

    await tester.tap(find.text('Salvar local do carro'));
    await tester.pumpAndSettle();

    expect(find.text('Substituir local salvo?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(controller.current?.note, 'Primeiro');
  });
}
