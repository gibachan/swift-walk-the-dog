import Engine

class Barrier {
  private var image: Image

  init(image: Image) {
    self.image = image
  }
}

extension Barrier: Obstacle {
  var right: Int16 {
    image.right
  }

  func checkIntersection(boy: RedHatBoy) {
    if boy.boundingBox.intersects(rect: image.boundingBox) {
      boy.knockOut()
    }
  }

  func draw(renderer: Engine.Renderer) {
    image.draw(renderer: renderer)

    renderer.drawRect(boundingBox: image.boundingBox)
  }

  func moveHorizontally(x: Int16) {
    image.moveHorizontaly(x)
  }
}
