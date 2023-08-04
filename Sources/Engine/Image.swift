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
  let position: Point

  public init(
    element: JSValue,
    position: Point
  ) {
    self.element = element
    self.position = position
  }
}

public extension Image {
  func draw(renderer: Renderer) {
    renderer.drawEntireImage(image: element, position: position)
  }
}
