import Browser
import Engine
import Foundation
import JavaScriptKit
import JavaScriptEventLoop

public final class WalkTheDog {
  private let rhb: RedHatBoy?

  private init(
    rhb: RedHatBoy?
  ) {
    self.rhb = rhb
  }

  public convenience init() {
    self.init(
      rhb: nil
    )
  }
}

extension WalkTheDog: Game {
  public func initialize(callback: @escaping (any Game) -> Void) {
    fetchJson(path: "rhb.json") { response in
      Task {
        let json = try await JSPromise(response.json().object!)!.value
        let sheet = try JSValueDecoder().decode(Sheet.self, from: json)
        loadImage(source: "rhb.png") { [weak self] image in
          guard let self else { return }
          callback(
            WalkTheDog(
              rhb: RedHatBoy(
                spriteSheet: sheet,
                image: image
              )
            )
          )
        }
      }
    }
  }

  public func update(keyState: KeyState) {
    if keyState.isPressed(code: "ArrowDown") {
    }
    if keyState.isPressed(code: "ArrowUp") {
    }
    if keyState.isPressed(code: "ArrowRight") {
      rhb!.runRight()
    }
    if keyState.isPressed(code: "ArrowLeft") {
    }

    rhb!.update()
  }

  public func draw(renderer: Renderer) {
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: 600))
    rhb?.draw(renderer: renderer)
  }
}
