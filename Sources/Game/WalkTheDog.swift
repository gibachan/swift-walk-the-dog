import Browser
import Engine
import JavaScriptKit
import JavaScriptEventLoop

let height: Int16 = 600
let lowPlatform: Int16 = 420
let highPlatform: Int16 = 375

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
        let platformResponse = await fetchJson(path: "tiles.json")
        let platformJSON = try await JSPromise(platformResponse.json().object!)!.value
        let platformSheet = try JSValueDecoder().decode(Sheet.self, from: platformJSON)
        let platformImage = await loadImage(source: "tiles.png")
        let platform = Platform(
          sheet: platformSheet,
          image: platformImage,
          position: .init(x: 370, y: lowPlatform)
        )
        let backgroundWidth: Int16 = Int16(background.width.number!)

        return WalkTheDog.loaded(Walk(
          boy: RedHatBoy(
            spriteSheet: sheet,
            image: image
          ),
          backgrounds: [
            Image(
              element: background,
              position: .init(x: 0, y: 0)
            ),
            Image(
              element: background,
              position: .init(x: backgroundWidth, y: 0)
            )
          ],
          stone: Image(
            element: stone,
            position: .init(x: 150, y: 546)
          ),
          platform: platform
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

      walk.platform.moveHorizontaly(walk.velocity)
      walk.stone.moveHorizontaly(walk.velocity)

      var firstBackground = walk.backgrounds[0]
      var secondBackground = walk.backgrounds[1]
      firstBackground.moveHorizontaly(walk.velocity)
      secondBackground.moveHorizontaly(walk.velocity)
      if firstBackground.right < 0 {
        firstBackground.setX(secondBackground.right)
      }
      if secondBackground.right < 0 {
        secondBackground.setX(firstBackground.right)
      }
      walk.backgrounds = [firstBackground, secondBackground]


      // collision with a platform
      walk.platform.boundingBoxes.forEach { boundingBox in
        if walk.boy.boundingBox.intersects(rect: boundingBox) {
          if walk.boy.velocityY > 0 &&
              walk.boy.posY < walk.platform.position.y {
            walk.boy.landOn(position: boundingBox.y)
          } else {
            walk.boy.knockOut()
          }
        }
      }

      // collision with a stone
      if walk.boy.boundingBox.intersects(rect: walk.stone.boundingBox) {
        walk.boy.knockOut()
      }
    }
  }

  public func draw(renderer: Renderer) {
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: height))
    if case let .loaded(walk) = self {
      walk.backgrounds.forEach { background in
        background.draw(renderer: renderer)
      }
      walk.boy.draw(renderer: renderer)
      walk.stone.draw(renderer: renderer)
      walk.platform.draw(renderer: renderer)
    }
  }
}
