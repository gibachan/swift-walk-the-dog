/// TODO: The file should be extracted as another package to encapsulate the inner implementation from the Game package. This technique can prevent unexpected creation of an illegal state.
import Engine

private let floor: Int16 = 479
private let startingPoint: Int16 = -20

private let idleFrameName = "Idle"
private let idleFrames: UInt8 = 29

private let runFrameName = "Run"
private let runningFrames: UInt8 = 23
private let runningSpeed: Int16 = 3

private let slidingFrameName = "Slide"
private let slidingFrames: UInt8 = 14

private let jumpingFrameName = "Jump"
private let jumpingFrames: UInt8 = 35
private let jumpSpeed: Int16 = -25

private let fallingFrameName = "Dead"
private let fallingFrames: UInt8 = 29

private let gravity: Int16 = 1

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

    let newVelocity = Point(
      x: velocity.x,
      y: velocity.y + gravity
    )

    var newPosition = Point(
      x: position.x + newVelocity.x,
      y: position.y + newVelocity.y
    )
    if newPosition.y > floor {
      newPosition.y = floor
    }

    return .init(
      frame: newFrame,
      position: newPosition,
      velocity: newVelocity
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
      frame: frame,
      position: position,
      velocity: newVelocity
    )
  }

  func setVerticalVelocity(y: Int16) -> Self {
    let newVelocity = Point(
      x: velocity.x,
      y: y
    )

    return .init(
      frame: frame,
      position: position,
      velocity: newVelocity
    )
  }

  func stop() -> Self {
    let newVelocity = Point(
      x: 0,
      y: velocity.y
    )

    return .init(
      frame: frame,
      position: position,
      velocity: newVelocity
    )
  }
}

public struct Idle {}

public extension RedHatBoyState where S == Idle {
  init() {
    self._context = RedHatBoyContext(
      frame: 0,
      position: .init(x: startingPoint, y: floor),
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

public struct Running {}

public extension RedHatBoyState where S == Running {
  var frameName: String {
    runFrameName
  }

  func slide() -> RedHatBoyState<Sliding> {
    RedHatBoyState<Sliding>(
      _context: _context.resetFrame(),
      _state: Sliding()
    )
  }

  func update() -> Self {
    return .init(
      _context: _context.update(frameCount: runningFrames),
      _state: _state
    )
  }

  func jump() -> RedHatBoyState<Jumping> {
    RedHatBoyState<Jumping>(
      _context: _context.setVerticalVelocity(y: jumpSpeed).resetFrame(),
      _state: Jumping()
    )
  }

  func knockOut() -> RedHatBoyState<Falling> {
    RedHatBoyState<Falling>(
      _context: _context.resetFrame().stop(),
      _state: Falling()
    )
  }
}

public struct Sliding {}

public extension RedHatBoyState where S == Sliding {
  var frameName: String {
    slidingFrameName
  }

  func update() -> SlidingEndState {
    let newContext = _context.update(frameCount: slidingFrames)
    if newContext.frame >= slidingFrames {
      return .complete(self.stand())
    } else {
      return .sliding(.init(
        _context: newContext,
        _state: _state
      ))
    }
  }

  func stand() -> RedHatBoyState<Running> {
    return .init(_context: _context.resetFrame(), _state: Running())
  }

  func knockOut() -> RedHatBoyState<Falling> {
    RedHatBoyState<Falling>(
      _context: _context.resetFrame().stop(),
      _state: Falling()
    )
  }
}

public enum SlidingEndState {
  case complete(RedHatBoyState<Running>)
  case sliding(RedHatBoyState<Sliding>)
}

public struct Jumping {}

public extension RedHatBoyState where S == Jumping {
  var frameName: String {
    jumpingFrameName
  }

  func update() -> JumpingEndState {
    let newContext = _context.update(frameCount: jumpingFrames)
    if context.position.y >= floor {
      return .complete(self.land())
    } else {
      return .jumping(.init(
        _context: newContext,
        _state: _state
      ))
    }
  }

  func land() -> RedHatBoyState<Running> {
    return .init(_context: _context.resetFrame(), _state: Running())
  }

  func knockOut() -> RedHatBoyState<Falling> {
    RedHatBoyState<Falling>(
      _context: _context.resetFrame().stop(),
      _state: Falling()
    )
  }
}

public enum JumpingEndState {
  case complete(RedHatBoyState<Running>)
  case jumping(RedHatBoyState<Jumping>)
}

public struct Falling {}

public extension RedHatBoyState where S == Falling {
  var frameName: String {
    fallingFrameName
  }

  func update() -> FallingEndState {
    let newContext = _context.update(frameCount: fallingFrames)
    if newContext.frame >= fallingFrames {
      return .knockedOut(self.knockOut())
    } else {
      return .falling(.init(_context: newContext, _state: _state))
    }
  }

  func knockOut() -> RedHatBoyState<KnockedOut> {
    RedHatBoyState<KnockedOut>(
      _context: _context,
      _state: KnockedOut()
    )
  }
}

public enum FallingEndState {
  case knockedOut(RedHatBoyState<KnockedOut>)
  case falling(RedHatBoyState<Falling>)
}

public struct KnockedOut {}

public extension RedHatBoyState where S == KnockedOut {
  var frameName: String {
    fallingFrameName
  }
}
