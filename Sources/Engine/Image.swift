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
  private(set) public var boundingBox: Rect

  public init(
    element: JSValue,
    position: Point
  ) {
    self.element = element
    self.boundingBox = Rect(
      x: position.x,
      y: position.y,
      width: Int16(element.width.number!),
      height: Int16(element.height.number!)
    )
  }
}

public extension Image {
  var right: Int16 {
    boundingBox.right
  }

  func draw(renderer: Renderer) {
    renderer.drawEntireImage(image: element, position: boundingBox.position)
  }

  mutating func moveHorizontaly(_ distance: Int16) {
    boundingBox.setX(boundingBox.x + distance)
  }

  mutating func setX(_ x: Int16) {
    boundingBox.setX(x)
  }
}
