import JavaScriptKit
import JavaScriptEventLoop

private func fetch(_ url: String) -> JSPromise {
  let jsFetch = JSObject.global.fetch.function!
  return JSPromise(jsFetch(url).object!)!
}

public func getWindow() -> JSValue {
  JSObject.global.window
}

public func getDocument() -> JSValue {
  getWindow().document
}

public func getCanvas() -> JSValue {
  getDocument().getElementById("canvas")
}

public func getContext() -> JSValue {
  getCanvas().getContext("2d")
}

public func fetchJson(path: String) async -> JSValue {
  await withCheckedContinuation { continuation in
    fetch(path)
      .then { response in
        let json = try await JSPromise(response.json().object!)!.value
        continuation.resume(returning: json)
        return JSValue.undefined
      }
  }
}

public func fetchArrayBuffer(resource: String) async -> JSValue {
  await withCheckedContinuation { continuation in
    fetch(resource)
      .then { response in
        let arrayBuffer = try await JSPromise(response.arrayBuffer().object!)!.value
        continuation.resume(returning: arrayBuffer)
        return JSValue.undefined
      }
  }
}

public func newImage() -> JSValue {
  getDocument().createElement("img")
}

public func requestAnimation(callback: @escaping (Float64) -> Void) {
  _ = getWindow().requestAnimationFrame(JSClosure { value in
    let perf = value.first?.number ?? 0
    callback(perf)
    return .undefined
  })
}

public func getNow() -> Float64 {
  getWindow().performance.now().number ?? 0
}
