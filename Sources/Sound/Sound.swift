import JavaScriptKit

public func createAudioContext() -> JSObject {
  return JSObject.global["AudioContext"].function!.new()
}

func createBufferSource(ctx: JSObject) -> JSValue {
  guard let bufferSource = ctx.createBufferSource?() else { fatalError() }
  return bufferSource
}

func createTrackSource(
  ctx: JSObject,
  buffer: JSObject
) -> JSValue {
  var trackSource = createBufferSource(ctx: ctx)
  trackSource.buffer = .object(buffer)
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

  let gainNode = ctx.createGain!()
  _ = trackSource.connect(gainNode)
  _ = gainNode.connect(ctx.destination)

  let gain = gainNode.object!.gain
  gain.object!.value = 0.05

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
