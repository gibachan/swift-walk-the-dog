import Engine
import JavaScriptKit

public final class Walk {
  let obstacleSheet: SpriteSheet
  let boy: RedHatBoy
  var backgrounds: [Image] // 2 images
  var obstacles: [any Obstacle]
  let stone: JSValue // HtmlImageElment
  var timeline: Int16

  init(
    obstacleSheet: SpriteSheet,
    boy: RedHatBoy,
    backgrounds: [Image],
    obstacles: [any Obstacle],
    stone: JSValue,
    timeline: Int16
  ) {
    self.obstacleSheet = obstacleSheet
    self.boy = boy
    self.backgrounds = backgrounds
    self.obstacles = obstacles
    self.stone = stone
    self.timeline = timeline
  }
}

extension Walk {
  var velocity: Int16 {
    -boy.walkingSpeed
  }

  var knockedOut: Bool {
    boy.knockedOut
  }

  func generateNextSegment() {
    let nextSegment = (0...1).randomElement()!
    let nextObstacles: [any Obstacle]

    switch nextSegment {
    case 0:
      nextObstacles = stoneAndPlatform(
        stone: stone,
        spriteSheet: obstacleSheet,
        offsetX: timeline + obstacleBuffer
      )
    case 1:
      nextObstacles = platformAndStone(
        stone: stone,
        spriteSheet: obstacleSheet,
        offsetX: timeline + obstacleBuffer
      )
    default:
      nextObstacles = []
    }

    timeline = rightMost(obstacleList: nextObstacles)
    obstacles = obstacles + nextObstacles
  }

  func draw(renderer: Renderer) {
    backgrounds.forEach { background in
      background.draw(renderer: renderer)
    }

    boy.draw(renderer: renderer)

    obstacles.forEach { obstacle in
      obstacle.draw(renderer: renderer)
    }
  }

  static func reset(_ walk: Walk) -> Walk {
    let startingObstacles = stoneAndPlatform(
      stone: walk.stone,
      spriteSheet: walk.obstacleSheet,
      offsetX: 0
    )
    let timeline = rightMost(obstacleList: startingObstacles)

    return Walk(
      obstacleSheet: walk.obstacleSheet,
      boy: RedHatBoy.reset(walk.boy),
      backgrounds: walk.backgrounds,
      obstacles: startingObstacles,
      stone: walk.stone,
      timeline: timeline
    )
  }
}
