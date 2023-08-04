import Browser
import Engine
import Foundation
import JavaScriptKit
import JavaScriptEventLoop

public struct Walk {
  let boy: RedHatBoy
  let background: Image
  let stone: Image
}

public enum WalkTheDog {
  case loading
  case loaded(Walk)
}

public extension WalkTheDog {
  static func new() -> Self {
    .loading
  }
}

extension WalkTheDog: Game {
  public func initialize() async -> Game {
    switch self {
    case .loading:
      do {
        let response = await fetchJson(path: "rhb.json")
        let json = try await JSPromise(response.json().object!)!.value
        let sheet = try JSValueDecoder().decode(Sheet.self, from: json)
        let background = await loadImage(source: "BG.png")
        let stone = await loadImage(source: "Stone.png")
        let image = await loadImage(source: "rhb.png")

        return WalkTheDog.loaded(Walk(
          boy: RedHatBoy(
            spriteSheet: sheet,
            image: image
          ),
          background: Image(
            element: background,
            position: .init(x: 0, y: 0)
          ),
          stone: Image(
            element: stone,
            position: .init(x: 150, y: 546)
          )
        ))
      } catch {
        fatalError("Error: \(error)")
      }
    case .loaded:
      fatalError("Error: Game is already initialized!")
    }
  }

  public func update(keyState: KeyState) {
    if case let .loaded(walk) = self {
      if keyState.isPressed(code: "ArrowDown") {
        walk.boy.slide()
      }
      if keyState.isPressed(code: "ArrowUp") {
      }
      if keyState.isPressed(code: "ArrowRight") {
        walk.boy.runRight()
      }
      if keyState.isPressed(code: "ArrowLeft") {
      }
      if keyState.isPressed(code: "Space") {
        walk.boy.jump()
      }

      walk.boy.update()
    }
  }

  public func draw(renderer: Renderer) {
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: 600))
    if case let .loaded(walk) = self {
      walk.background.draw(renderer: renderer)
      walk.boy.draw(renderer: renderer)
      walk.stone.draw(renderer: renderer)
    }
  }
}
