import JavaScriptKit
import Engine

public final class RedHatBoy {
  private var stateMachine: RedHatBoyStateMachine
  private let spriteSheet: Sheet
  private let image: JSValue //HtmlImageElement

  init(spriteSheet: Sheet, image: JSValue) {
    self.stateMachine = .idle(RedHatBoyState<Idle>())
    self.spriteSheet = spriteSheet
    self.image = image
  }

  var frameName: String {
    "\(stateMachine.frameName) (\(stateMachine.context.frame / 3 + 1)).png"
  }

  var currentSprite: Cell? {
    spriteSheet.frames[frameName]
  }

  var destinationBox: Rect {
    guard let sprite = currentSprite else { fatalError("Cell not found") }
    
    return .init(
      x: Float32(stateMachine.context.position.x + Int16(sprite.spriteSourceSize.x)),
      y: Float32(stateMachine.context.position.y + Int16(sprite.spriteSourceSize.y)),
      width: Float32(sprite.frame.w),
      height: Float32(sprite.frame.h)
    )
  }

  var boundingBox: Rect {
    let xOffset: Float32 = 18
    let yOffset: Float32 = 14
    let widthOffset: Float32 = 28
    let box = destinationBox

    return .init(
      x: box.x + xOffset,
      y: box.y + yOffset,
      width: box.width - widthOffset,
      height: box.height - yOffset
    )
  }

  var posY: Int16 {
    stateMachine.context.position.y
  }

  var velocityY: Int16 {
    stateMachine.context.velocity.y
  }

  func draw(renderer: Renderer) {
    guard let sprite = currentSprite else { fatalError("Cell not found") }

    renderer.draw(
      image: image,
      frame: .init(
        x: Float32(sprite.frame.x),
        y: Float32(sprite.frame.y),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      ),
      destination: .init(
        x: Float32(stateMachine.context.position.x + Int16(sprite.spriteSourceSize.x)),
        y: Float32(stateMachine.context.position.y + Int16(sprite.spriteSourceSize.y)),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      )
    )

    // BoundingBox
    renderer.drawRect(boundingBox: boundingBox)
  }

  func update() {
    stateMachine = stateMachine.update()
  }

  func runRight() {
    stateMachine = stateMachine.transition(event: .run)
  }

  func slide() {
    stateMachine = stateMachine.transition(event: .slide)
  }

  func jump() {
    stateMachine = stateMachine.transition(event: .jump)
  }

  func knockOut() {
    stateMachine = stateMachine.transition(event: .knockOut)
  }

  func landOn(position: Float32) {
    stateMachine = stateMachine.transition(event: .land(position))
  }
}
