import Foundation
import JavaScriptKit

public final class WalkTheDog {
  private let image: JSValue? // HtmlImageElement
  private let sheet: Sheet?
  private var frame: UInt8
  private var position: Point

  init(
    image: JSValue?,
    sheet: Sheet?,
    frame: UInt8,
    position: Point
  ) {
    self.image = image
    self.sheet = sheet
    self.frame = frame
    self.position = position
  }

  convenience init() {
    self.init(
      image: nil,
      sheet: nil,
      frame: 0,
      position: .init(x: 0, y: 0)
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
              image: image,
              sheet: sheet,
              frame: frame,
              position: position
            )
          )
        }
      }
    }
  }

  public func update(keyState: KeyState) {
    var velocity = Point(x: 0, y: 0)

    if keyState.isPressed(code: "ArrowDown") {
      velocity.y += 3
    }
    if keyState.isPressed(code: "ArrowUp") {
      velocity.y -= 3
    }
    if keyState.isPressed(code: "ArrowRight") {
      velocity.x += 3
    }
    if keyState.isPressed(code: "ArrowLeft") {
      velocity.x -= 3
    }

    position.x += velocity.x
    position.y += velocity.y

    if frame < 23 {
      frame += 1
    } else {
      frame = 0
    }
  }

  public func draw(renderer: Renderer) {
    let currentSprite = (frame / 3) + 1
    let frameName = "Run (\(currentSprite)).png"
    let sprite = sheet!.frames[frameName]!
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: 600))
    renderer.draw(
      image: image!,
      frame: .init(
        x: Float32(sprite.frame.x),
        y: Float32(sprite.frame.y),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      ),
      destination: .init(
        x: Float32(position.x),
        y: Float32(position.y),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      )
    )
  }
}
