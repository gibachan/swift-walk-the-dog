import Browser
import JavaScriptKit
import JavaScriptEventLoop
import Sound

public struct Audio {
  private let context: JSObject // AudioContext

  public init() {
    self.context = createAudioContext()
  }
}

public extension Audio {
  func loadSound(fileName: String) async -> Sound {
    let arrayBuffer = await fetchArrayBuffer(resource: fileName)
    let audioBuffer = await decodeAudioData(ctx: context, arrayBuffer: arrayBuffer)

    return .init(buffer: audioBuffer)
  }

  func play(sound: Sound) {
    playSound(
      ctx: context,
      buffer: sound.buffer,
      looping: .no
    )
  }

  func playLooping(sound: Sound) {
    playSound(
      ctx: context,
      buffer: sound.buffer,
      looping: .yes
    )
  }
}

public struct Sound {
  let buffer: JSObject // AudioBuffer
}
