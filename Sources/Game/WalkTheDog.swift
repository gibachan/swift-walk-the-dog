import Browser
import Engine
import JavaScriptKit
import JavaScriptEventLoop

let height: Int16 = 600
let firstPlatform: Int16 = 370
let lowPlatform: Int16 = 420
let highPlatform: Int16 = 375

let timelineMinimum: Int16 = 1000
let obstacleBuffer: Int16 = 20

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

        let spriteSheet = SpriteSheet(
          sheet: platformSheet,
          image: platformImage
        )
        let platform = Platform(
          sheet: spriteSheet,
          position: .init(x: firstPlatform, y: lowPlatform),
          spriteNames: ["13.png", "14.png", "15.png"],
          boundingBoxes: [
            .init(x: 0, y: 0, width: 60, height: 54),
            .init(x: 60, y: 0, width: Int16(384 - (60 * 2)), height: 93),
            .init(x: Int16(384 - 60), y: 0, width: 60, height: 54)
          ]
        )
        let backgroundWidth: Int16 = Int16(background.width.number!)

        let startingObstacles = stoneAndPlatform(stone: stone, spriteSheet: spriteSheet, offsetX: 0)
        let timeline = rightMost(obstacleList: startingObstacles)

        return WalkTheDog.loaded(Walk(
          obstacleSheet: spriteSheet,
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
          obstacles: startingObstacles,
          stone: stone,
          timeline: timeline
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

      // Boy
      walk.boy.update()

      // Background
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

      // Obstacles
      walk.obstacles = walk.obstacles.filter { $0.right > 0 }
      walk.obstacles.forEach { obstacle in
        obstacle.moveHorizontally(x: walk.velocity)
        obstacle.checkIntersection(boy: walk.boy)
      }

      // Timeline
      if walk.timeline < timelineMinimum {
        walk.generateNextSegment()
      } else {
        walk.timeline += walk.velocity
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
      walk.obstacles.forEach { obstacle in
        obstacle.draw(renderer: renderer)
      }
    }
  }
}
