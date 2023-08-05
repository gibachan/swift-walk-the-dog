import JavaScriptKit

public final class SpriteSheet {
  let sheet: Sheet
  let image: JSValue

  public init(sheet: Sheet, image: JSValue) {
    self.sheet = sheet
    self.image = image
  }
}

public extension SpriteSheet {
  func cell(name: String) -> Cell? {
    sheet.frames[name]
  }

  func draw(renderer: Renderer, source: Rect, destination: Rect) {
    renderer.draw(image: image, frame: source, destination: destination)
  }
}
