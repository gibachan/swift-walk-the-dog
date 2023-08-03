import Foundation

struct Size: Decodable {
  let w: UInt16
  let h: UInt16
}

struct SheetRect: Decodable {
  let x: Float32
  let y: Float32
  let w: Float32
  let h: Float32
}

struct Cell: Decodable {
  let frame: SheetRect
  let rotated: Bool
  let trimmed: Bool
  let spriteSourceSize: SheetRect
  let sourceSize: Size

}

struct Sheet: Decodable {
  let frames: [String: Cell]
}

extension UInt16 {
  func toDouble() -> Double {
    Double(self)
  }
}
