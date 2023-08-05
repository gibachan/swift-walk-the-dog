import Engine
import Game
import Sound
import SwiftWalkTheDogLibrary
import JavaScriptKit
import JavaScriptEventLoop

JavaScriptEventLoop.installGlobalExecutor()

Task {
  let audio = Audio()
//  await audio.loadSound(fileName: "background_song.mp3")

  let game = WalkTheDog.new()
  let gameLoop = GameLoop()
  await gameLoop.start(game: game)
  print("OK")
}
