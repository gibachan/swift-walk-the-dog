import Engine

final class Platform {
  let sheet: SpriteSheet
  private(set) public var boundingBoxes: [Rect]
  let sprites: [Cell]
  private(set) public var position: Point

  init(
    sheet: SpriteSheet,
    position: Point,
    spriteNames: [String],
    boundingBoxes: [Rect]
  ) {
    self.sheet = sheet
    self.position = position
    self.sprites = spriteNames.compactMap { sheet.cell(name: $0) }
    self.boundingBoxes = boundingBoxes.map { boundingBox in
        .init(
          x: boundingBox.x + position.x,
          y: boundingBox.y + position.y,
          width: boundingBox.width,
          height: boundingBox.height
        )
    }
  }
}

extension Platform {
  func moveHorizontaly(_ x: Int16) {
    position = .init(
      x: position.x + x,
      y: position.y
    )
    boundingBoxes = boundingBoxes.map {
      var _boundingBox = $0
      _boundingBox.setX($0.position.x + x)
      return _boundingBox
    }
  }
}

extension Platform: Obstacle {
  var right: Int16 {
    let box = boundingBoxes.last ?? .init(x: 0, y: 0, width: 0, height: 0)
    return box.right
  }

  func checkIntersection(boy: RedHatBoy) {
    guard let boxToLandOn = boundingBoxes.first(where: { boy.boundingBox.intersects(rect: $0) }) else {
      return
    }

    if boy.velocityY > 0 && boy.posY < position.y {
      boy.landOn(position: boxToLandOn.y)
    } else {
      boy.knockOut()
    }
  }

  func draw(renderer: Renderer) {
    var x: Int16 = 0
    sprites.forEach { sprite in
      sheet.draw(
        renderer: renderer,
        source: .init(
          x: sprite.frame.x,
          y: sprite.frame.y,
          width: sprite.frame.w,
          height: sprite.frame.h
        ),
        // Just use position and the standard widths in the tileset
        destination: .init(
          x: position.x + x,
          y: position.y,
          width: sprite.frame.w,
          height: sprite.frame.h
        )
      )
      x += sprite.frame.w
    }

    boundingBoxes.forEach { renderer.drawRect(boundingBox: $0) }
  }

  func moveHorizontally(x: Int16) {
    position = .init(x: position.x + x, y: position.y)
    boundingBoxes = boundingBoxes.map {
      var box = $0
      box.setX($0.position.x + x)
      return box
    }
  }
}
