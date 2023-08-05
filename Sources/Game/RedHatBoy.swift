import JavaScriptKit
import Engine

public final class RedHatBoy {
  private var stateMachine: RedHatBoyStateMachine
  private let spriteSheet: Sheet
  private let image: JSValue //HtmlImageElement

  init(
    spriteSheet: Sheet,
    image: JSValue,
    audio: Audio,
    jumpSound: Sound
  ) {
    self.stateMachine = .idle(RedHatBoyState<Idle>(audio: audio, jumpSound: jumpSound))
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
      x: stateMachine.context.position.x + sprite.spriteSourceSize.x,
      y: stateMachine.context.position.y + sprite.spriteSourceSize.y,
      width: sprite.frame.w,
      height: sprite.frame.h
    )
  }

  var boundingBox: Rect {
    let xOffset: Int16 = 18
    let yOffset: Int16 = 14
    let widthOffset: Int16 = 28
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

  var walkingSpeed: Int16 {
    stateMachine.context.velocity.x
  }

  func draw(renderer: Renderer) {
    guard let sprite = currentSprite else { fatalError("Cell not found") }

    renderer.draw(
      image: image,
      frame: .init(
        x: sprite.frame.x,
        y: sprite.frame.y,
        width: sprite.frame.w,
        height: sprite.frame.h
      ),
      destination: .init(
        x: stateMachine.context.position.x + sprite.spriteSourceSize.x,
        y: stateMachine.context.position.y + sprite.spriteSourceSize.y,
        width: sprite.frame.w,
        height: sprite.frame.h
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

  func landOn(position: Int16) {
    stateMachine = stateMachine.transition(event: .land(position))
  }
}
