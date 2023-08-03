import JavaScriptKit

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

public func fetchJson(path: String, callback: @escaping (JSValue) -> Void) {
  fetch(path)
    .then { response in
      callback(response)
      return JSValue.undefined
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
