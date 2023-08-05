import Engine

public final class Walk {
  let boy: RedHatBoy
  var backgrounds: [Image] // 2 images
  var obstacles: [any Obstacle]

  init(boy: RedHatBoy, backgrounds: [Image], obstacles: [any Obstacle]) {
    self.boy = boy
    self.backgrounds = backgrounds
    self.obstacles = obstacles
  }
}

extension Walk {
  var velocity: Int16 {
    -boy.walkingSpeed
  }
}
