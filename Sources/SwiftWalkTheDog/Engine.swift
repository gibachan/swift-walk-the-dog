import JavaScriptKit

public func loadImage(source: String, callback: @escaping (JSValue) -> Void) {
  var image = newImage()
  image.src = JSValue.string(source)
  image.onload = .object(JSClosure { _ in
    callback(image)
    return .undefined
  })
}

public struct Rect {
  let x: Float32
  let y: Float32
  let width: Float32
  let height: Float32
}

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

public protocol Game {
  func initialize(callback: @escaping (any Game) -> Void)
  func update()
  func draw(renderer: Renderer)
}

public class GameLoop {
  static let frameSize: Float64 = 1.0 / 60.0 * 1000.0

  private var game: (any Game)!
  private var lastFrame: Float64 = 0
  private var accumulatedDelta: Float64 = 0
  private var renderer: Renderer!

  public func start(game: any Game) {
    game.initialize { [weak self] game in
      guard let self else { return }

      self.game = game
      self.lastFrame = getNow()
      self.accumulatedDelta = 0
      self.renderer = Renderer(context: getContext())

      requestAnimation { [weak self] perf in
        guard let self else { return }
        loop(perf: perf)
      }
    }
  }

  private func loop(perf: Float64) {
    requestAnimation { [weak self] perf in
      guard let self else { return }

      accumulatedDelta += perf - lastFrame
      while accumulatedDelta > Self.frameSize {
        game.update()
        accumulatedDelta -= Self.frameSize
      }
      lastFrame = perf

      game.draw(renderer: renderer)

      loop(perf: perf)
    }
  }
}
