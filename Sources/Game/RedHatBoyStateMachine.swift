enum RedHatBoyStateMachine {
  case idle(RedHatBoyState<Idle>)
  case running(RedHatBoyState<Running>)
  case sliding(RedHatBoyState<Sliding>)
}

public enum Event {
  case run
  case slide
  case update
}

extension RedHatBoyStateMachine {
  var frameName: String {
    switch self {
    case let .idle(state):
      return state.frameName
    case let .running(state):
      return state.frameName
    case let .sliding(state):
      return state.frameName
    }
  }

  var context: RedHatBoyContext {
    switch self {
    case let .idle(state):
      return state.context
    case let .running(state):
      return state.context
    case let .sliding(state):
      return state.context
    }
  }

  func transition(event: Event) -> Self {
    switch (self, event) {
    case let (.idle(state), .run):
      return state.run().into()
    case let (.running(state), .slide):
      return state.slide().into()
    case let (.idle(state), .update):
      return state.update().into()
    case let (.running(state), .update):
      return state.update().into()
    case let (.sliding(state), .update):
      return state.update().into()
    default:
      return self
    }
  }

  func update() -> Self {
    transition(event: .update)
  }
}

extension RedHatBoyState where S == Idle {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.idle(self)
  }
}

extension RedHatBoyState where S == Running {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.running(self)
  }
}

extension RedHatBoyState where S == Sliding {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.sliding(self)
  }
}

extension SlidingEndState {
  func into() -> RedHatBoyStateMachine {
    switch self {
    case let .complete(state):
      return .running(state)
    case let .sliding(state):
      return .sliding(state)
    }
  }
}
