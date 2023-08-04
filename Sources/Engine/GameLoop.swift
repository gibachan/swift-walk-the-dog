import Browser
import JavaScriptKit

public protocol Game {
  func initialize() async -> Game
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

  public func start(game: any Game) async {
    prepareInput()

    self.game = await game.initialize()
    self.lastFrame = getNow()
    self.accumulatedDelta = 0
    self.renderer = Renderer(context: getContext())

    let keyState = KeyState()
    // Capture self to keep it available on requestAnimation
    requestAnimation { [self] perf in
      loop(perf: perf, keyState: keyState)
    }
  }

  private func loop(perf: Float64, keyState: KeyState) {
    requestAnimation { [self] perf in
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
