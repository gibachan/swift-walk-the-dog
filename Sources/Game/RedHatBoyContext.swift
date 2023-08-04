import Engine

public struct RedHatBoyContext {
  let frame: UInt8
  let position: Point
  let velocity: Point
}

extension RedHatBoyContext {
  func update(frameCount: UInt8) -> Self {
    var newVelocity = velocity
    if velocity.y < terminalVelocity {
      newVelocity.y += gravity
    }

    var newFrame = frame
    if frame < frameCount {
      newFrame += 1
    } else {
      newFrame = 0
    }

    var newPosition = Point(
      x: position.x,
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
      y: 0
    )

    return .init(
      frame: frame,
      position: position,
      velocity: newVelocity
    )
  }

  func setOn(position: Int16) -> Self {
    let newPositionY = position - playerHeight
    return .init(
      frame: frame,
      position: .init(x: self.position.x, y: newPositionY),
      velocity: velocity
    )
  }
}
