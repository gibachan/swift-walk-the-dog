import Browser
import JavaScriptKit

public func loadImage(source: String, callback: @escaping (JSValue) -> Void) {
  var image = newImage()
  image.src = JSValue.string(source)
  image.onload = .object(JSClosure { _ in
    callback(image)
    return .undefined
  })
}

public struct Image {
  let element: JSValue // HtmlImageElement
  let position: Point

  init(
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
