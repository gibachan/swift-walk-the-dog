/// TODO: The file should be extracted as another package to encapsulate the inner implementation from the Game package. This technique can prevent unexpected creation of an illegal state.
import Engine

private let floor: Int16 = 475

private let idleFrameName = "Idle"
private let idleFrames: UInt8 = 29

private let runFrameName = "Run"
private let runningFrames: UInt8 = 23
private let runningSpeed: Int16 = 3

public struct RedHatBoyState<S> {
  private let _context: RedHatBoyContext
  private let _state: S
}

extension RedHatBoyState {
  var context: RedHatBoyContext {
    _context
  }
}

public struct RedHatBoyContext {
  let frame: UInt8
  let position: Point
  let velocity: Point
}

extension RedHatBoyContext {
  func update(frameCount: UInt8) -> Self {
    var newFrame = frame
    if frame < frameCount {
      newFrame += 1
    } else {
      newFrame = 0
    }

    let newPosition = Point(
      x: position.x + velocity.x,
      y: position.y + velocity.y
    )

    return .init(
      frame: newFrame,
      position: newPosition,
      velocity: velocity
    )
  }

  func resetFrame() -> Self {
    .init(
      frame: 0,
      position: position,
      velocity: velocity
    )
  }

  func runRight() -> Self {
    let newVelocity = Point(
      x: velocity.x + runningSpeed,
      y: velocity.y
    )

    return .init(
      frame: 0,
      position: position,
      velocity: newVelocity
    )
  }
}

public struct Idle {
}

public extension RedHatBoyState where S == Idle {
  init() {
    self._context = RedHatBoyContext(
      frame: 0,
      position: .init(x: 0, y: floor),
      velocity: .init(x: 0, y: 0)
    )
    self._state = Idle()
  }

  var frameName: String {
    idleFrameName
  }

  func run() -> RedHatBoyState<Running> {
    RedHatBoyState<Running>(
      _context: _context.resetFrame().runRight(),
      _state: Running()
    )
  }

  func update() -> Self {
    return .init(
      _context: _context.update(frameCount: idleFrames),
      _state: _state
    )
  }
}

public struct Running {
}

public extension RedHatBoyState where S == Running {
  var frameName: String {
    runFrameName
  }

  func update() -> Self {
    return .init(
      _context: _context.update(frameCount: runningFrames),
      _state: _state
    )
  }
}
