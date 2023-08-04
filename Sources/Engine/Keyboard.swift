import Browser
import JavaScriptKit

public typealias KeyboardEventCode = String

public struct KeyboardEvent {
  let code: KeyboardEventCode
}

enum KeyPress {
  case keyUp(KeyboardEvent)
  case keyDown(KeyboardEvent)
}

private var keyEventReceiver: [KeyPress] = []

public func prepareInput() {
  var window = getWindow()
  _ = window.onkeydown = .object(JSClosure { value in
    let code: KeyboardEventCode = value.first?.object?.code.string ?? "??"
    let event: KeyboardEvent = .init(code: code)
    keyEventReceiver.append(.keyDown(event))
    return .undefined
  })
  _ = window.onkeyup = .object(JSClosure { value in
    let code: KeyboardEventCode = value.first?.object?.code.string ?? "??"
    let event: KeyboardEvent = .init(code: code)
    keyEventReceiver.append(.keyUp(event))
    return .undefined
  })
}

public final class KeyState {
  private var pressedKey: [KeyboardEventCode: KeyboardEvent] = [:]

  public func isPressed(code: KeyboardEventCode) -> Bool {
    return pressedKey.keys.contains(code)
  }

  public func setPressed(code: KeyboardEventCode, event: KeyboardEvent) {
    pressedKey[code] = event
  }

  public func setReleased(code: KeyboardEventCode) {
    pressedKey[code] = nil
  }
}

public func processInput(
  state: KeyState
) {
  while true {
    if let keyEvent = keyEventReceiver.first {
      keyEventReceiver.removeFirst()
      switch keyEvent {
      case let .keyUp(event):
        state.setReleased(code: event.code)
      case let .keyDown(event):
        state.setPressed(code: event.code, event: event)
      }
    } else {
      break
    }
  }
}
