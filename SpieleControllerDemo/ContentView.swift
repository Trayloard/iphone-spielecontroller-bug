import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var mapper: ControllerInputMapper

    var body: some View {
        NavigationStack {
            List {
                Section("Controller") {
                    LabeledContent("Verbunden", value: mapper.connectedControllerName)
                }

                Section("Aktive Belegung") {
                    ForEach(GamepadButton.allCases) { button in
                        HStack {
                            Text(button.displayName)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                            Text((mapper.mapping[button] ?? button).displayName)
                                .foregroundStyle(.blue)
                        }
                    }
                }

                Section {
                    if mapper.recentEvents.isEmpty {
                        Text("Noch keine Eingaben registriert.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(mapper.recentEvents) { event in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(event.source.displayName) → \(event.mapped.displayName)")
                                    .font(.headline)
                                Text(event.timestamp.formatted(date: .omitted, time: .standard))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                } header: {
                    HStack {
                        Text("Letzte Eingaben")
                        Spacer()
                        if !mapper.recentEvents.isEmpty {
                            Button("Leeren") {
                                mapper.clearEvents()
                            }
                            .font(.caption)
                        }
                    }
                } footer: {
                    Text("Die Demo zeigt Controller-Eingaben an und mappt sie intern auf deine gewünschte Zielbelegung.")
                }
            }
            .navigationTitle("Controller Demo")
        }
    }
}
