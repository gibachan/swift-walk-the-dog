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
}
