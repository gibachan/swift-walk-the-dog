import JavaScriptKit

public func createAudioContext() -> JSObject {
  return JSObject.global["AudioContext"].function!.new()
}

func createBufferSource(ctx: JSObject) -> JSValue {
  guard let bufferSource = ctx.createBufferSource?() else { fatalError() }
  return bufferSource
}

func connectWithAudioNode(
  bufferSource: JSValue,
  destination: JSValue
) {
  _ = bufferSource.connect(destination)
}

func createTrackSource(
  ctx: JSObject,
  buffer: JSObject
) -> JSValue {
  var trackSource = createBufferSource(ctx: ctx)
  trackSource.buffer = .object(buffer)
  connectWithAudioNode(bufferSource: trackSource, destination: ctx.destination)
  return trackSource
}

public enum Looping {
  case no, yes
}

public func playSound(
  ctx: JSObject,
  buffer: JSObject,
  looping: Looping
) {
  let trackSource = createTrackSource(ctx: ctx, buffer: buffer)
  if case .yes = looping {
    _ = trackSource.object!.loop = JSValue.boolean(true)
  }

  setVolume(ctx: ctx, trackSource: trackSource, volume: 0.1)

  _ = trackSource.start()
}

public func decodeAudioData(
  ctx: JSObject, // AudioContext
  arrayBuffer: JSValue // ArrayBuffer
) async -> JSObject {
  await withCheckedContinuation { continuation in
    let promise = JSPromise(from: ctx.decodeAudioData!(arrayBuffer))!
    promise.then { value in
      let object = value.object! // AudioBuffer
      continuation.resume(returning: object)
      return JSValue.undefined
    }
  }
}

func setVolume(ctx: JSObject, trackSource: JSValue, volume: Double) {
  let gainNode = ctx.createGain!()
  let gain = gainNode.object!.gain
  _ = trackSource.connect(gainNode)
  _ = gainNode.connect(ctx.destination)
  gain.object!.value = .number(volume)
}
