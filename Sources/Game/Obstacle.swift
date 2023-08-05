import Engine

protocol Obstacle {
  var right: Int16 { get }
  func checkIntersection(boy: RedHatBoy)
  func draw(renderer: Renderer)
  func moveHorizontally(x: Int16)
}
