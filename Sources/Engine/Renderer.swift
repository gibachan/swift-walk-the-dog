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

  func drawEntireImage(
    image: JSValue, // HtmlImageElement
    position: Point
  ) {
    _ = context.drawImage(
      image,
      position.x,
      position.y
    )
  }

  public func drawRect(boundingBox: Rect) {
    var _context = context
    _context.strokeStyle = .string("#FF0000")
    _ = context.beginPath()
    _ = context.rect(
      boundingBox.x,
      boundingBox.y,
      boundingBox.width,
      boundingBox.height
    )
    _ = context.stroke()
  }
}
