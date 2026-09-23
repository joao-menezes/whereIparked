# App: Onde Estacionei

App mobile pessoal para salvar e localizar onde o carro foi estacionado. Foco em simplicidade — um app leve, sem backend na v1.

## Stack

- **Flutter (Dart)** — Android, iOS (web apenas para desenvolvimento)
- Armazenamento local: `shared_preferences` (JSON serializado — local atual + histórico de até 3 locais); migrar para `sqflite` se o histórico crescer
- `geolocator` — captura de GPS, permissões de localização e stream de posição para o geofencing em primeiro plano (cálculo de distância com `Geolocator.distanceBetween`)
- `image_picker` (ou `camera`, se precisar de UI de câmera customizada) — foto do local
- `path_provider` — salvar a foto no diretório de documentos do app (`getApplicationDocumentsDirectory`), não na galeria
- `google_maps_flutter` (exige chave de API do Google Maps) ou `flutter_map` + OpenStreetMap (sem chave) — exibição do pin no mapa
- `url_launcher` — abrir Google Maps/Waze com as coordenadas salvas
- `flutter_local_notifications` — notificação local do aviso de geofencing
- Geofencing em segundo plano (futuro): avaliar `native_geofence` ou `flutter_background_geolocation`

## Escopo da v1

### Núcleo
- Botão principal: "Salvar local do carro" → captura GPS.
- Tela com mapa mostrando o pin do local salvo.
- Botão "Me leve até lá" → abre app de navegação externo (Google Maps/Waze) com as coordenadas.

### Foto do local
- Ao salvar o local, oferecer opção de tirar uma foto (referência visual: número da vaga, setor, andar etc.).
- Foto salva em diretório interno do app (`path_provider`), não na galeria do usuário.

### Histórico
- Ao salvar um novo local, o local atual vai para o histórico (mais recente primeiro).
- **Limite: os 3 últimos locais anteriores** (além do local atual). Ao passar do limite, o mais antigo é descartado junto com a foto dele.
- Acessado pelo ícone de histórico na barra superior; cada item mostra data/hora, nota e foto, e permite abrir a navegação se tiver GPS.
- Persistido junto com o local atual (`shared_preferences`, chave `car_location_history`).

### Regras de negócio
- **1 veículo por usuário** (sem suporte a múltiplos veículos na v1).
- Ao salvar um **novo local** enquanto o local anterior ainda não foi marcado como "visitado": exibir aviso de confirmação antes de sobrescrever.
- **Marcação de "visitado"**: automática, via geofencing — quando o usuário se aproxima das coordenadas salvas, o app dispara uma notificação local e marca o registro como visitado.
  - Decisão pendente: usar geofencing em segundo plano (permissão de localização "Sempre", mais invasivo, exige justificativa nas lojas) vs. geofencing apenas em primeiro plano (só funciona com o app aberto, permissão mais simples). Avaliar antes de implementar — recomendação inicial é começar com a versão em primeiro plano para a v1 e migrar para segundo plano em versão futura se fizer sentido.
- **Permissão de localização negada**: o app permanece funcional — permite salvar o local apenas com foto e/ou nota manual, sem coordenadas GPS.
- **Permissão de câmera negada**: permite salvar o local sem foto, apenas com GPS.

### Modelo de dados (rascunho)

```dart
class CarLocation {
  final String id;
  final double? latitude;
  final double? longitude;
  final String? photoFileName; // nome do arquivo em <documentos do app>/photos (relativo: o caminho absoluto muda entre atualizações no iOS)
  final String? note;
  final DateTime timestamp;
  final bool visited;
}
```

## Fora do escopo da v1 (ideias para versões futuras)

- Suporte a múltiplos veículos.
- Anotação de texto livre como campo padrão (ex: "Piso 2, Setor B, vaga 34") — já previsto no modelo de dados, mas não como fluxo obrigatório na v1.
- Histórico maior que 3 locais / locais recorrentes.
- Compartilhamento de localização do carro com outra pessoa.
- Widget de tela inicial para salvar o local com um toque.
- Geofencing em segundo plano (background).

## Monetização (a definir, não bloqueia a v1)

Lançar grátis e simples primeiro para validar uso real. Caminhos possíveis para depois:
- Freemium por assinatura (histórico ilimitado, múltiplos veículos, geofencing em segundo plano, widget).
- Compra única para desbloquear extras.
- Ads (menos indicado dado o baixo volume de aberturas do app por uso esperado).