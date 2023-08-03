import JavaScriptKit
import Engine

final class RedHatBoy {
  private var stateMachine: RedHatBoyStateMachine
  private let spriteSheet: Sheet
  private let image: JSValue //HtmlImageElement

  init(spriteSheet: Sheet, image: JSValue) {
    self.stateMachine = .idle(RedHatBoyState<Idle>())
    self.spriteSheet = spriteSheet
    self.image = image
  }

  func draw(renderer: Renderer) {
    let frameName = "\(stateMachine.frameName) (\(stateMachine.context.frame / 3 + 1)).png"
    let sprite = spriteSheet.frames[frameName]!

    renderer.draw(
      image: image,
      frame: .init(
        x: Float32(sprite.frame.x),
        y: Float32(sprite.frame.y),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      ),
      destination: .init(
        x: Float32(stateMachine.context.position.x),
        y: Float32(stateMachine.context.position.y),
        width: Float32(sprite.frame.w),
        height: Float32(sprite.frame.h)
      )
    )
  }

  func update() {
    stateMachine = stateMachine.update()
  }

  func runRight() {
    stateMachine = stateMachine.transition(event: .run)
  }
}
