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

public extension Rect {
  func intersects(rect: Rect) -> Bool {
    x < (rect.x + rect.width) && (x + width) > rect.x
    && y < (rect.y + rect.height) && (y + height) > rect.y
  }
}
