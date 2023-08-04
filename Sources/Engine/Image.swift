import Browser
import JavaScriptKit

public func loadImage(source: String) async -> JSValue {
  await withCheckedContinuation { continuation in
    var image = newImage()
    image.src = JSValue.string(source)
    image.onload = .object(JSClosure { _ in
      continuation.resume(with: .success(image))
      return .undefined
    })
  }
}

public struct Image {
  let element: JSValue // HtmlImageElement
  private(set) var position: Point
  private(set) public var boundingBox: Rect

  public init(
    element: JSValue,
    position: Point
  ) {
    self.element = element
    self.position = position
    self.boundingBox = Rect(
      x: Float32(position.x),
      y: Float32(position.y),
      width: Float32(element.width.number!),
      height: Float32(element.height.number!)
    )
  }
}

public extension Image {
  var right: Int16 {
    Int16(boundingBox.x + boundingBox.width)
  }

  func draw(renderer: Renderer) {
    renderer.drawEntireImage(image: element, position: position)
  }

  mutating func moveHorizontaly(_ distance: Int16) {
    boundingBox = .init(
      x: boundingBox.x + Float32(distance),
      y: boundingBox.y,
      width: boundingBox.width,
      height: boundingBox.height
    )
    position = .init(
      x: position.x + distance,
      y: position.y
    )
  }

  mutating func setX(_ x: Int16) {
    boundingBox = .init(
      x: Float32(x),
      y: boundingBox.y,
      width: boundingBox.width,
      height: boundingBox.height
    )
    position = .init(
      x: x,
      y: position.y
    )
  }
}
