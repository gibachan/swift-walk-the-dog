import Engine
import JavaScriptKit

struct Platform {
  let sheet: Sheet
  let image: JSValue // HtmlImageElement
  let position: Point

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
      x: Float32(position.x),
      y: Float32(position.y),
      width: Float32((platform.frame.w * 3)),
      height: Float32(platform.frame.h)
    )
  }

  var boundingBoxes: [Rect] {
    let xOffset: Float32 = 60
    let endHeight: Float32 = 54

    let box = destinationBox

    let boundingBoxOne = Rect(
      x: box.x,
      y: box.y,
      width: xOffset,
      height: endHeight
    )

    let boundingBoxTwo = Rect(
      x: box.x + xOffset,
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
        x: Float32(platform.frame.x),
        y: Float32(platform.frame.y),
        width: Float32((platform.frame.w * 3)),
        height: Float32((platform.frame.h))
      ),
      destination: .init(
        x: Float32(position.x),
        y: Float32(position.y),
        width: Float32((platform.frame.w * 3)),
        height: Float32(platform.frame.h)
      )
    )
  }
}
