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
