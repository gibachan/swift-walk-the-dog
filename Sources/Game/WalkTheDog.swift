import Browser
import Engine
import JavaScriptKit
import JavaScriptEventLoop

let height: Int16 = 600
let firstPlatform: Int16 = 370
let lowPlatform: Int16 = 420
let highPlatform: Int16 = 375

let timelineMinimum: Int16 = 1000
let obstacleBuffer: Int16 = 20

struct WalkTheDogState<T> {
  let _state: T
  let walk: Walk
}

extension WalkTheDogState {
  func draw(renderer: Renderer) {
    walk.draw(renderer: renderer)
  }
}

struct Ready {}

enum ReadyEndState {
  case complete(WalkTheDogState<Walking>)
  case `continue`(WalkTheDogState<Ready>)
}

extension ReadyEndState {
  func into() -> WalkTheDogStateMachine {
    switch self {
    case let .complete(walking):
      return walking.into()
    case let .continue(ready):
      return ready.into()
    }
  }
}

extension WalkTheDogState where T == Ready {
  init(walk: Walk) {
    self._state = Ready()
    self.walk = walk
  }

  func update(keyState: KeyState) -> ReadyEndState {
    walk.boy.update()

    if keyState.isPressed(code: "ArrowRight") {
      return .complete(startRunning())
    } else {
      return .continue(self)
    }
  }

  func into() -> WalkTheDogStateMachine {
    WalkTheDogStateMachine.ready(self)
  }

  func startRunning() -> WalkTheDogState<Walking> {
    runRight()
    return WalkTheDogState<Walking>(
      _state: Walking(),
      walk: walk
    )
  }

  func runRight() {
    walk.boy.runRight()
  }
}


struct Walking {}

extension WalkTheDogState where T == Walking {
  func update(keyState: KeyState) -> WalkTheDogState<Walking> {
    // Keyboard handling
    if keyState.isPressed(code: "ArrowDown") {
      walk.boy.slide()
    }
    if keyState.isPressed(code: "ArrowUp") {
    }
    if keyState.isPressed(code: "ArrowLeft") {
    }
    if keyState.isPressed(code: "Space") {
      walk.boy.jump()
    }

    // Boy
    walk.boy.update()

    let walkingSpeed = walk.velocity

    // Background
    var firstBackground = walk.backgrounds[0]
    var secondBackground = walk.backgrounds[1]
    firstBackground.moveHorizontaly(walkingSpeed)
    secondBackground.moveHorizontaly(walkingSpeed)
    if firstBackground.right < 0 {
      firstBackground.setX(secondBackground.right)
    }
    if secondBackground.right < 0 {
      secondBackground.setX(firstBackground.right)
    }
    walk.backgrounds = [firstBackground, secondBackground]

    // Obstacles
    walk.obstacles = walk.obstacles.filter { $0.right > 0 }
    walk.obstacles.forEach { obstacle in
      obstacle.moveHorizontally(x: walkingSpeed)
      obstacle.checkIntersection(boy: walk.boy)
    }

    // Timeline
    if walk.timeline < timelineMinimum {
      walk.generateNextSegment()
    } else {
      walk.timeline += walkingSpeed
    }

    return self
  }

  func into() -> WalkTheDogStateMachine {
    WalkTheDogStateMachine.walking(self)
  }
}

struct GameOver {}

extension WalkTheDogState where T == GameOver {
  func update() -> WalkTheDogState<GameOver> {
    self
  }

  func into() -> WalkTheDogStateMachine {
    WalkTheDogStateMachine.gameOver(self)
  }
}

enum WalkTheDogStateMachine {
  case ready(WalkTheDogState<Ready>)
  case walking(WalkTheDogState<Walking>)
  case gameOver(WalkTheDogState<GameOver>)
}

extension WalkTheDogStateMachine {
  init(walk: Walk) {
    self = WalkTheDogStateMachine.ready(WalkTheDogState<Ready>(walk: walk))
  }
}

extension WalkTheDogStateMachine {
  func update(keyState: KeyState) -> Self {
    switch self {
    case let .ready(state):
      return state.update(keyState: keyState).into()
    case let .walking(state):
      return state.update(keyState: keyState).into()
    case let .gameOver(state):
      return state.update().into()
    }
  }

  func draw(renderer: Renderer) {
    switch self {
    case let .ready(state):
      state.draw(renderer: renderer)
    case let .walking(state):
      state.draw(renderer: renderer)
    case let .gameOver(state):
      state.draw(renderer: renderer)
    }
  }
}

public final class WalkTheDog {
  var machine: WalkTheDogStateMachine?

  init(machine: WalkTheDogStateMachine?) {
    self.machine = machine
  }
}

public extension WalkTheDog {
  static func new() -> WalkTheDog {
    return WalkTheDog(machine: nil)
  }
}

extension WalkTheDog: Game {
  public func initialize() async -> Game {
    switch machine {
    case nil:
      do {
        let json = await fetchJson(path: "rhb.json")
        let sheet = try JSValueDecoder().decode(Sheet.self, from: json)
        let background = await loadImage(source: "BG.png")
        let stone = await loadImage(source: "Stone.png")
        let image = await loadImage(source: "rhb.png")
        let platformJSON = await fetchJson(path: "tiles.json")
        let platformSheet = try JSValueDecoder().decode(Sheet.self, from: platformJSON)
        let platformImage = await loadImage(source: "tiles.png")

        let spriteSheet = SpriteSheet(
          sheet: platformSheet,
          image: platformImage
        )
        let backgroundWidth: Int16 = Int16(background.width.number!)

        let startingObstacles = stoneAndPlatform(stone: stone, spriteSheet: spriteSheet, offsetX: 0)
        let timeline = rightMost(obstacleList: startingObstacles)

        let audio = Audio()
        let jumpSound = await audio.loadSound(fileName: "SFX_Jump_23.mp3")
        let backgroundMusic = await audio.loadSound(fileName: "background_song.mp3")
        audio.playLooping(sound: backgroundMusic)

        let machine = WalkTheDogStateMachine(walk: Walk(
          obstacleSheet: spriteSheet,
          boy: RedHatBoy(
            spriteSheet: sheet,
            image: image,
            audio: audio,
            jumpSound: jumpSound
          ),
          backgrounds: [
            Image(
              element: background,
              position: .init(x: 0, y: 0)
            ),
            Image(
              element: background,
              position: .init(x: backgroundWidth, y: 0)
            )
          ],
          obstacles: startingObstacles,
          stone: stone,
          timeline: timeline
        ))

        return WalkTheDog(machine: machine)
      } catch {
        fatalError("Error: \(error)")
      }
    case .some:
      fatalError("Error: Game is already initialized!")
    }
  }

  public func update(keyState: KeyState) {
    if let machine {
      self.machine = machine.update(keyState: keyState)
    }
    assert(machine != nil)
  }

  public func draw(renderer: Renderer) {
    renderer.clear(rect: .init(x: 0, y: 0, width: 600, height: height))

    if let machine  {
      machine.draw(renderer: renderer)
    }
  }
}
