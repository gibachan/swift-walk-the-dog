enum RedHatBoyStateMachine {
  case idle(RedHatBoyState<Idle>)
  case running(RedHatBoyState<Running>)
  case sliding(RedHatBoyState<Sliding>)
  case jumping(RedHatBoyState<Jumping>)
  case falling(RedHatBoyState<Falling>)
  case knockedOut(RedHatBoyState<KnockedOut>)
}

public enum Event {
  case run
  case slide
  case jump
  case knockOut
  case update
  case land(Int16)
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
    case let .jumping(state):
      return state.frameName
    case let .falling(state):
      return state.frameName
    case let .knockedOut(state):
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
    case let .jumping(state):
      return state.context
    case let .falling(state):
      return state.context
    case let .knockedOut(state):
      return state.context
    }
  }

  func transition(event: Event) -> Self {
    switch (self, event) {
    // run
    case let (.idle(state), .run):
      return state.run().into()

    // slide
    case let (.running(state), .slide):
      return state.slide().into()

    // jump
    case let (.running(state), .jump):
      return state.jump().into()

    // update
    case let (.idle(state), .update):
      return state.update().into()
    case let (.running(state), .update):
      return state.update().into()
    case let (.jumping(state), .update):
      return state.update().into()
    case let (.sliding(state), .update):
      return state.update().into()
    case let (.falling(state), .update):
      return state.update().into()

    // knockOut
    case let (.running(state), .knockOut):
      return state.knockOut().into()
    case let (.jumping(state), .knockOut):
      return state.knockOut().into()
    case let (.sliding(state), .knockOut):
      return state.knockOut().into()

    // land
    case let (.jumping(state), .land(position)):
      return state.landOn(position: position).into()
    case let (.running(state), .land(position)):
      return state.landOn(position: position).into()
    case let (.sliding(state), .land(position)):
      return state.landOn(position: position).into()

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

extension RedHatBoyState where S == Jumping {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.jumping(self)
  }
}

extension JumpingEndState {
  func into() -> RedHatBoyStateMachine {
    switch self {
    case let .landing(state):
      return .running(state)
    case let .jumping(state):
      return .jumping(state)
    }
  }
}

extension RedHatBoyState where S == Falling {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.falling(self)
  }
}

extension FallingEndState {
  func into() -> RedHatBoyStateMachine {
    switch self {
    case let .knockedOut(state):
      return state.into()
    case let .falling(state):
      return state.into()
    }
  }
}

extension RedHatBoyState where S == KnockedOut {
  func into() -> RedHatBoyStateMachine {
    RedHatBoyStateMachine.knockedOut(self)
  }
}
