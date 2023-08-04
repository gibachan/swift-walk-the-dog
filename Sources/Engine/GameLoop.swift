import Browser
import JavaScriptKit

public protocol Game {
  func initialize(callback: @escaping (any Game) -> Void)
  func update(keyState: KeyState)
  func draw(renderer: Renderer)
}

public class GameLoop {
  static let frameSize: Float64 = 1.0 / 60.0 * 1000.0

  private var game: (any Game)!
  private var lastFrame: Float64 = 0
  private var accumulatedDelta: Float64 = 0
  private var renderer: Renderer!

  public init() {}

  public func start(game: any Game) {
    prepareInput()

    game.initialize { [weak self] game in
      guard let self else { return }

      self.game = game
      self.lastFrame = getNow()
      self.accumulatedDelta = 0
      self.renderer = Renderer(context: getContext())

      let keyState = KeyState()
      requestAnimation { [weak self] perf in
        guard let self else { return }

        loop(perf: perf, keyState: keyState)
      }
    }
  }

  private func loop(perf: Float64, keyState: KeyState) {
    requestAnimation { [weak self] perf in
      guard let self else { return }

      processInput(state: keyState)

      accumulatedDelta += perf - lastFrame
      while accumulatedDelta > Self.frameSize {
        game.update(keyState: keyState)
        accumulatedDelta -= Self.frameSize
      }
      lastFrame = perf

      game.draw(renderer: renderer)

      loop(perf: perf, keyState: keyState)
    }
  }
}
