import Browser
import JavaScriptKit

public func loadImage(source: String, callback: @escaping (JSValue) -> Void) {
  var image = newImage()
  image.src = JSValue.string(source)
  image.onload = .object(JSClosure { _ in
    callback(image)
    return .undefined
  })
}

public struct Point {
  public var x: Int16
  public var y: Int16

  public init(x: Int16, y: Int16) {
    self.x = x
    self.y = y
  }
}

public struct Rect {
  let x: Float32
  let y: Float32
  let width: Float32
  let height: Float32

  public init(
    x: Float32,
    y: Float32,
    width: Float32,
    height: Float32
  ) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  }
}

public class Renderer {
  private let context: JSValue // CanvasRenderingContext2d

  public init(context: JSValue) {
    self.context = context
  }

  public func clear(rect: Rect) {
    _ = context.clearRect(
      rect.x,
      rect.y,
      rect.width,
      rect.height
    )
  }

  public func draw(
    image: JSValue, // HtmlImageElement
    frame: Rect,
    destination: Rect
  ) {
    _ = context.drawImage(
      image,
      frame.x,
      frame.y,
      frame.width,
      frame.height,
      destination.x,
      destination.y,
      destination.width,
      destination.height
    )
  }
}

public protocol Game {
  func initialize(callback: @escaping (any Game) -> Void)
  func update(keyState: KeyState)
  func draw(renderer: Renderer)
}

public class GameLoop {
  static let frameSize: Float64 = 1.0 / 60.0 * 1000.0

  private var game: (any Game)!
  private var lastFrame: Float64 = 0
  private var accumulatedDelta: Float64 = 0
  private var renderer: Renderer!

  public init() {}

  public func start(game: any Game) {
    prepareInput()

    game.initialize { [weak self] game in
      guard let self else { return }

      self.game = game
      self.lastFrame = getNow()
      self.accumulatedDelta = 0
      self.renderer = Renderer(context: getContext())

      let keyState = KeyState()
      requestAnimation { [weak self] perf in
        guard let self else { return }

        loop(perf: perf, keyState: keyState)
      }
    }
  }

  private func loop(perf: Float64, keyState: KeyState) {
    requestAnimation { [weak self] perf in
      guard let self else { return }

      processInput(state: keyState)

      accumulatedDelta += perf - lastFrame
      while accumulatedDelta > Self.frameSize {
        game.update(keyState: keyState)
        accumulatedDelta -= Self.frameSize
      }
      lastFrame = perf

      game.draw(renderer: renderer)

      loop(perf: perf, keyState: keyState)
    }
  }
}

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
