import Foundation
import JavaScriptKit

public final class WalkTheDog {
  private let image: JSValue? // HtmlImageElement
  private let sheet: Sheet?
  private var frame: UInt8

  init(
    image: JSValue?,
    sheet: Sheet?,
    frame: UInt8
  ) {
    self.image = image
    self.sheet = sheet
    self.frame = frame
  }

  convenience init() {
    self.init(
      image: nil,
      sheet: nil,
      frame: 0
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
              frame: frame
            )
          )
        }
      }
    }
  }

  public func update() {
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
      frame: .init(x: sprite.frame.x, y: sprite.frame.y, width: sprite.frame.w, height: sprite.frame.h),
      destination: .init(x: 300, y: 300, width: sprite.frame.w, height: sprite.frame.h)
    )
  }
}
