import Combine
import Foundation
import GameController

struct InputEvent: Identifiable {
    let id = UUID()
    let source: GamepadButton
    let mapped: GamepadButton
    let value: Float
    let timestamp = Date()
}

enum GamepadButton: String, CaseIterable, Identifiable {
    case a
    case b
    case x
    case y
    case dpadUp
    case dpadDown
    case dpadLeft
    case dpadRight
    case r1
    case r2
    case r3
    case l1
    case l2
    case l3

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        case .x: return "X"
        case .y: return "Y"
        case .dpadUp: return "Pfeiltaste hoch"
        case .dpadDown: return "Pfeiltaste runter"
        case .dpadLeft: return "Pfeiltaste links"
        case .dpadRight: return "Pfeiltaste rechts"
        case .r1: return "R1"
        case .r2: return "R2"
        case .r3: return "R3"
        case .l1: return "L1"
        case .l2: return "L2"
        case .l3: return "L3"
        }
    }
}

@MainActor
final class ControllerInputMapper: ObservableObject {
    @Published private(set) var connectedControllerName = "Kein Controller verbunden"
    @Published private(set) var recentEvents: [InputEvent] = []

    let mapping: [GamepadButton: GamepadButton] = [
        .a: .x,
        .b: .r3,
        .x: .l1,
        .y: .r1,
        .dpadUp: .dpadUp,
        .dpadDown: .dpadDown,
        .dpadLeft: .dpadLeft,
        .dpadRight: .dpadRight,
        .r1: .r1,
        .r2: .y,
        .r3: .r2,
        .l1: .a,
        .l2: .l2,
        .l3: .b,
    ]

    private var observers: [NSObjectProtocol] = []
    private weak var activeController: GCController?

    init() {
        registerForControllerNotifications()
        attachFirstAvailableController()
    }

    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }

        activeController?.extendedGamepad?.valueChangedHandler = nil
    }

    func clearEvents() {
        recentEvents.removeAll()
    }

    private func registerForControllerNotifications() {
        let center = NotificationCenter.default

        observers.append(
            center.addObserver(
                forName: .GCControllerDidConnect,
                object: nil,
                queue: .main
            ) { [weak self] note in
                guard let controller = note.object as? GCController else { return }
                self?.attach(controller: controller)
            }
        )

        observers.append(
            center.addObserver(
                forName: .GCControllerDidDisconnect,
                object: nil,
                queue: .main
            ) { [weak self] note in
                guard let controller = note.object as? GCController else { return }
                self?.detach(controller: controller)
            }
        )
    }

    private func attachFirstAvailableController() {
        if let controller = GCController.controllers().first {
            attach(controller: controller)
        }
    }

    private func attach(controller: GCController) {
        activeController?.extendedGamepad?.valueChangedHandler = nil
        activeController = controller
        connectedControllerName = controller.vendorName ?? "Unbekannter Controller"

        guard let gamepad = controller.extendedGamepad else { return }

        gamepad.buttonA.pressedChangedHandler = makePressedHandler(for: .a)
        gamepad.buttonB.pressedChangedHandler = makePressedHandler(for: .b)
        gamepad.buttonX.pressedChangedHandler = makePressedHandler(for: .x)
        gamepad.buttonY.pressedChangedHandler = makePressedHandler(for: .y)
        gamepad.leftShoulder.pressedChangedHandler = makePressedHandler(for: .l1)
        gamepad.rightShoulder.pressedChangedHandler = makePressedHandler(for: .r1)
        gamepad.leftTrigger.pressedChangedHandler = makePressedHandler(for: .l2)
        gamepad.rightTrigger.pressedChangedHandler = makePressedHandler(for: .r2)
        gamepad.dpad.up.pressedChangedHandler = makePressedHandler(for: .dpadUp)
        gamepad.dpad.down.pressedChangedHandler = makePressedHandler(for: .dpadDown)
        gamepad.dpad.left.pressedChangedHandler = makePressedHandler(for: .dpadLeft)
        gamepad.dpad.right.pressedChangedHandler = makePressedHandler(for: .dpadRight)

        if #available(iOS 14.0, *) {
            gamepad.leftThumbstickButton?.pressedChangedHandler = makePressedHandler(for: .l3)
            gamepad.rightThumbstickButton?.pressedChangedHandler = makePressedHandler(for: .r3)
        }
    }

    private func detach(controller: GCController) {
        guard activeController === controller else { return }
        activeController?.extendedGamepad?.valueChangedHandler = nil
        activeController = nil
        connectedControllerName = "Kein Controller verbunden"
        recentEvents.removeAll()
        attachFirstAvailableController()
    }

    private func makePressedHandler(for button: GamepadButton) -> GCControllerButtonValueChangedHandler {
        { [weak self] _, value, pressed in
            guard pressed else { return }
            Task { @MainActor [weak self] in
                self?.record(button: button, value: value)
            }
        }
    }

    private func record(button: GamepadButton, value: Float) {
        let mappedButton = mapping[button] ?? button
        recentEvents.insert(InputEvent(source: button, mapped: mappedButton, value: value), at: 0)

        if recentEvents.count > 25 {
            recentEvents.removeLast(recentEvents.count - 25)
        }
    }
}
