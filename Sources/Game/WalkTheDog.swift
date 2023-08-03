import Browser
import Engine
import Foundation
import JavaScriptKit
import JavaScriptEventLoop

public enum WalkTheDog {
  case loading
  case loaded(RedHatBoy)
}

public extension WalkTheDog {
  static func new() -> Self {
    .loading
  }
}

extension WalkTheDog: Game {
  public func initialize(callback: @escaping (any Game) -> Void) {
    switch self {
    case .loading:
      fetchJson(path: "rhb.json") { response in
        Task {
          let json = try await JSPromise(response.json().object!)!.value
          let sheet = try JSValueDecoder().decode(Sheet.self, from: json)
          loadImage(source: "rhb.png") { image in
            callback(
              WalkTheDog.loaded(RedHatBoy(
                  spriteSheet: sheet,
                  image: image
                )
              )
            )
          }
        }
      }
    case .loaded:
      fatalError("Error: Game is already initialized!")
    }
  }

  public func update(keyState: KeyState) {
    if case let .loaded(rhb) = self {
      if keyState.isPressed(code: "ArrowDown") {
        rhb.slide()
      }
      if keyState.isPressed(code: "ArrowUp") {
      }
      if keyState.isPressed(code: "ArrowRight") {
        rhb.runRight()
      }
      if keyState.isPressed(code: "ArrowLeft") {
      }
      if keyState.isPressed(code: "Space") {
        rhb.jump()
      }

      rhb.update()
    }
  }

  public func draw(renderer: Renderer) {
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: 600))
    if case let .loaded(rhb) = self {
      rhb.draw(renderer: renderer)
    }
  }
}
