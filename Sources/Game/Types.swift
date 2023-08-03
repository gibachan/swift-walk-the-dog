struct Size: Decodable {
  let w: UInt16
  let h: UInt16
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

struct SheetRect: Decodable {
  let x: UInt16
  let y: UInt16
  let w: UInt16
  let h: UInt16
}
