public struct Point {
  public var x: Int16
  public var y: Int16

  public init(x: Int16, y: Int16) {
    self.x = x
    self.y = y
  }
}

public struct Rect {
  public let x: Int16
  public let y: Int16
  public let width: Int16
  public let height: Int16

  public init(
    x: Int16,
    y: Int16,
    width: Int16,
    height: Int16
  ) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  }
}

public extension Rect {
  func intersects(rect: Rect) -> Bool {
    x < (rect.x + rect.width) && (x + width) > rect.x
    && y < (rect.y + rect.height) && (y + height) > rect.y
  }
}
