import Engine
import JavaScriptKit

struct Platform {
  let sheet: Sheet
  let image: JSValue // HtmlImageElement
  var position: Point

  init(sheet: Sheet, image: JSValue, position: Point) {
    self.sheet = sheet
    self.image = image
    self.position = position
  }
}

extension Platform {
  var destinationBox: Rect {
    guard let platform = sheet.frames["13.png"] else { fatalError() }

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

  func draw(renderer: Renderer) {
    guard let platform = sheet.frames["13.png"] else { fatalError() }

    renderer.draw(
      image: image,
      frame: .init(
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

  mutating func moveHorizontaly(_ distance: Int16) {
    position = .init(
      x: position.x + distance,
      y: position.y
    )
  }
}
