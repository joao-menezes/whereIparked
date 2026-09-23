# Onde Estacionei

App mobile (Flutter) para salvar onde o carro foi estacionado e encontrá-lo depois. Tudo fica no aparelho — sem backend.

- Salva o local com GPS, foto opcional e nota (quando não há GPS)
- Mapa com o pin do carro e atalho "Me leve até lá" (Google Maps / Waze)
- Marca o carro como encontrado automaticamente ao voltar perto dele (geofencing com o app aberto)
- Histórico dos 3 últimos locais

Especificação completa: [docs/spec.md](docs/spec.md).

## Desenvolvimento

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

## Estrutura

```
lib/
  main.dart            inicialização (serviços, splash)
  app.dart             MaterialApp e tema
  controllers/         estado e regras de negócio (ParkingController)
  data/                persistência (shared_preferences)
  models/              CarLocation
  services/            wrappers dos plugins (GPS, câmera, notificações, navegação)
  screens/home/        tela principal + widgets/ e dialogs/ próprios
  screens/             outras telas (visualizador de foto)
  widgets/             widgets compartilhados
  utils/               formatação de data
test/                  mesma estrutura de lib/
docs/spec.md           especificação do produto
assets/splash/         logo da splash screen
```
