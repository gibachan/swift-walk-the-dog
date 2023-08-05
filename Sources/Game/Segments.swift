import Engine
import JavaScriptKit

//private let lowPlatform: Int16 = 420
//private let highPlatform: Int16 = 375
//private let firstPlatform: Int16 = 370

private let stoneOnGround: Int16 = 546

private let floatingPlatformSprites: [String] = ["13.png", "14.png", "15.png"]
private let platformWidth: Int16 = 384
private let platformHeight: Int16 = 93
private let platformEdgeWidth: Int16 = 60
private let platformEdgeHeight: Int16 = 54
private let floatingPlatformBoundingBoxes: [Rect] = [
  .init(x: 0, y: 0, width: platformEdgeWidth, height: platformEdgeHeight),
  .init(x: platformEdgeWidth, y: 0, width: platformWidth - platformEdgeWidth * 2, height: platformHeight),
  .init(x: platformWidth - platformEdgeWidth, y: 0, width: platformEdgeWidth, height: platformEdgeHeight)
]

func stoneAndPlatform(
  stone: JSValue, // HtmlImageElement
  spriteSheet: SpriteSheet,
  offsetX: Int16
) -> [any Obstacle] {
  let initialStoneOffset: Int16 = 150
  return [
    Barrier(image: Image(
      element: stone,
      position: .init(x: offsetX + initialStoneOffset, y: stoneOnGround)
    )),
    createFloatingPlatform(
      spriteSheet: spriteSheet,
      position: Point(x: offsetX + firstPlatform, y: lowPlatform)
    )
  ]
}

func platformAndStone(
  stone: JSValue, // HtmlImageElement
  spriteSheet: SpriteSheet,
  offsetX: Int16
) -> [any Obstacle] {
  let initialStoneOffset: Int16 = 400
  let initialPlatformOffset: Int16 = 200
  return [
    Barrier(image: Image(
      element: stone,
      position: .init(x: offsetX + initialStoneOffset, y: stoneOnGround)
    )),
    createFloatingPlatform(
      spriteSheet: spriteSheet,
      position: Point(x: offsetX + initialPlatformOffset, y: highPlatform)
    )
  ]
}

func createFloatingPlatform(
  spriteSheet: SpriteSheet,
  position: Point
) -> Platform {
  .init(
    sheet: spriteSheet,
    position: position,
    spriteNames: floatingPlatformSprites,
    boundingBoxes: floatingPlatformBoundingBoxes
  )
}
