# iphone-spielecontroller-bug

Dieses Repository enthält jetzt eine minimale iPhone-Demo-App in SwiftUI, die Controller-Eingaben mit Apples `GameController`-Framework erkennt und auf die gewünschte Zielbelegung mappt.

## Enthalten

- `SpieleControllerDemo.xcodeproj`: Xcode-Projekt für die Demo-App
- `SpieleControllerDemo/ControllerInputMapper.swift`: zentrale Mapping-Logik
- `SpieleControllerDemo/ContentView.swift`: Anzeige der aktuellen Belegung und letzter Eingaben
- `SpieleControllerDemo/SpieleControllerDemoApp.swift`: App-Einstiegspunkt

## Aktive Belegung

- A → X
- B → R3
- X → L1
- Y → R1
- Pfeiltaste hoch → Pfeiltaste hoch
- Pfeiltaste runter → Pfeiltaste runter
- Pfeiltaste links → Pfeiltaste links
- Pfeiltaste rechts → Pfeiltaste rechts
- R1 → R1
- R2 → Y
- R3 → R2
- L1 → A
- L2 → L2
- L3 → B

## Verwendung

1. Repository in Xcode auf einem Mac öffnen.
2. `SpieleControllerDemo.xcodeproj` starten.
3. Die App auf iPhone oder Simulator ausführen.
4. Einen kompatiblen Controller verbinden.
5. In der App prüfen, welche physische Eingabe auf welche Zielaktion gemappt wird.

## Hinweis

Die Demo mappt die Eingaben **innerhalb der App**. Sie ändert keine systemweite iOS-Controllerbelegung für andere Apps oder Spiele.
