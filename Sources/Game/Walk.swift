import Engine

public final class Walk {
  let boy: RedHatBoy
  var backgrounds: [Image] // 2 images
  var stone: Image
  var platform: Platform

  init(boy: RedHatBoy, backgrounds: [Image], stone: Image, platform: Platform) {
    self.boy = boy
    self.backgrounds = backgrounds
    self.stone = stone
    self.platform = platform
  }
}

extension Walk {
  var velocity: Int16 {
    -boy.walkingSpeed
  }
}
