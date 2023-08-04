import JavaScriptKit

public class Renderer {
  private let context: JSValue // CanvasRenderingContext2d

  public init(context: JSValue) {
    self.context = context
  }

  public func clear(rect: Rect) {
    _ = context.clearRect(
      rect.x,
      rect.y,
      rect.width,
      rect.height
    )
  }

  public func draw(
    image: JSValue, // HtmlImageElement
    frame: Rect,
    destination: Rect
  ) {
    _ = context.drawImage(
      image,
      frame.x,
      frame.y,
      frame.width,
      frame.height,
      destination.x,
      destination.y,
      destination.width,
      destination.height
    )
  }
}
