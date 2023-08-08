import XCTest
@testable import Engine

final class RectTests: XCTestCase {
    func testIntersects() throws {
      let rect1 = Rect(
        position: .init(x: 10, y: 10),
        width: 100,
        height: 100
      )
      let rect2 = Rect(
        position: .init(x: 0, y: 10),
        width: 100,
        height: 100
      )

      XCTAssertTrue(rect2.intersects(rect: rect1))
    }
}
