enum RedHatBoyStateMachine {
  case idle(RedHatBoyState<Idle>)
  case running(RedHatBoyState<Running>)
}

public enum Event {
  case run
}

extension RedHatBoyStateMachine {
  var frameName: String {
    switch self {
    case let .idle(state):
      return state.frameName
    case let .running(state):
      return state.frameName
    }
  }

  var context: RedHatBoyContext {
    switch self {
    case let .idle(state):
      return state.context
    case let .running(state):
      return state.context
    }
  }

  func transition(event: Event) -> Self {
    switch (self, event) {
    case let (.idle(state), .run):
      return .running(state.run())
    default:
      return self
    }
  }

  func update() -> Self {
    switch self {
    case let .idle(state):
      return .idle(state.update())
    case let .running(state):
      return .running(state.update())
    }
  }
}
