import JavaScriptKit

public func addClickHandler(elem: JSValue, callback: @escaping () -> Void) {
  elem.object?.onclick = .object(JSClosure { _ in
    callback()
    return .undefined
  })
}
