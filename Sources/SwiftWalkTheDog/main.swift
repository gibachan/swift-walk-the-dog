import Engine
import Game
import SwiftWalkTheDogLibrary
import JavaScriptKit
import JavaScriptEventLoop

JavaScriptEventLoop.installGlobalExecutor()

let game = WalkTheDog.new()
let gameLoop = GameLoop()
gameLoop.start(game: game)
