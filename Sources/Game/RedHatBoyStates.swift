/// TODO: The file should be extracted as another package to encapsulate the inner implementation from the Game package. This technique can prevent unexpected creation of an illegal state.
import Engine

private let floor: Int16 = 475

private let idleFrameName = "Idle"
private let runFrameName = "Run"

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
      _context: _context,
      _state: Running()
    )
  }

  func nextFrame() -> Self {
    var frame = _context.frame
    if frame < 29 {
      frame += 1
    } else {
      frame = 0
    }
    return .init(
      _context: .init(
        frame: frame,
        position: _context.position,
        velocity: _context.velocity
      ),
      _state: Idle()
    )
  }
}

public struct Running {
}

public extension RedHatBoyState where S == Running {
  var frameName: String {
    runFrameName
  }
}
