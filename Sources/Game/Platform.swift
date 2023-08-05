import Engine

final class Platform {
  let sheet: SpriteSheet
  var position: Point

  init(sheet: SpriteSheet, position: Point) {
    self.sheet = sheet
    self.position = position
  }
}

extension Platform {
  var destinationBox: Rect {
    guard let platform = sheet.cell(name: "13.png") else { fatalError() }

    return .init(
      x: position.x,
      y: position.y,
      width: platform.frame.w * 3,
      height: platform.frame.h
    )
  }

  var boundingBoxes: [Rect] {
    let xOffset: Int16 = 60
    let endHeight: Int16 = 54

    let box = destinationBox

    let boundingBoxOne = Rect(
      x: box.x,
      y: box.y,
      width: xOffset,
      height: endHeight
    )

    let boundingBoxTwo = Rect(
      x: box.x + Int16(xOffset),
      y: box.y,
      width: box.width - (xOffset * 2),
      height: box.height
    )

    let boundingBoxThree = Rect(
      x: box.x + box.width - xOffset,
      y: box.y,
      width: xOffset,
      height: endHeight
    )

    return [boundingBoxOne, boundingBoxTwo, boundingBoxThree]
  }

  func moveHorizontaly(_ distance: Int16) {
    position = .init(
      x: position.x + distance,
      y: position.y
    )
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

    if boy.velocityY > 0 &&
        boy.posY < position.y {
      boy.landOn(position: boxToLandOn.y)
    } else {
      boy.knockOut()
    }
  }

  func draw(renderer: Renderer) {
    guard let platform = sheet.cell(name: "13.png") else { fatalError() }

    sheet.draw(
      renderer: renderer,
      source: .init(
        x: platform.frame.x,
        y: platform.frame.y,
        width: platform.frame.w * 3,
        height: platform.frame.h
      ),
      destination: .init(
        x: position.x,
        y: position.y,
        width: platform.frame.w * 3,
        height: platform.frame.h
      )
    )
  }

  func moveHorizontally(x: Int16) {
    position = .init(x: position.x + x, y: position.y)
  }
}
