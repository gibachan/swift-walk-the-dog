import Engine
import Game
import SwiftWalkTheDogLibrary
import JavaScriptKit
import JavaScriptEventLoop

JavaScriptEventLoop.installGlobalExecutor()

Task {
  let game = WalkTheDog.new()
  let gameLoop = GameLoop()
  await gameLoop.start(game: game)
}
