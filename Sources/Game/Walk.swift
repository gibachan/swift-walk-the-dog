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
}
