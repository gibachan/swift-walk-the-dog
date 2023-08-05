public struct Point {
  public var x: Int16
  public var y: Int16

  public init(x: Int16, y: Int16) {
    self.x = x
    self.y = y
  }
}

public struct Rect {
  private(set) public var position: Point
  public let width: Int16
  public let height: Int16

  public init(
    x: Int16,
    y: Int16,
    width: Int16,
    height: Int16
  ) {
    self.init(position: .init(x: x, y: y), width: width, height: height)
  }

  public init(
    position: Point,
    width: Int16,
    height: Int16
  ) {
    self.position = position
    self.width = width
    self.height = height
  }
}

public extension Rect {
  var x: Int16 {
    position.x
  }

  var y: Int16 {
    position.y
  }

  var right: Int16 {
    x + width
  }

  var bottom: Int16 {
    y + height
  }

  func intersects(rect: Rect) -> Bool {
    x < rect.right && right > rect.x
    && y < rect.bottom && bottom > rect.y
  }

  mutating func setX(_ x: Int16) {
    position = .init(x: x, y: position.y)
  }
}
