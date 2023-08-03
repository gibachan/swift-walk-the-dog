import Foundation
import JavaScriptKit

// Example:
// sierpinski(
//   context: context,
//   points: (top: (300, 0), left: (0, 600), right: (600, 600)),
//   color: (0, 255, 0),
//   depth: 5
// )

typealias Point = (Float64, Float64)
typealias Points = (top: Point, left: Point, right: Point)
typealias Color = (UInt8, UInt8, UInt8)

func sierpinski(
  context: JSValue,
  points: Points,
  color: Color,
  depth: UInt8
) {
  drawTriangle(
    context: context,
    points: points,
    color: color
  )

  let depth = depth - 1
  if depth > 0 {
    let (top, left, right) = points
    let leftMiddle = midPoint(top, left)
    let rightMiddle = midPoint(top, right)
    let bottomMiddle = midPoint(left, right)

    let nextColor = Color(UInt8.random(in: 0...255), UInt8.random(in: 0...255), UInt8.random(in: 0...255))

    sierpinski(
      context: context,
      points: (top: top, left: leftMiddle, right: rightMiddle),
      color: nextColor,
      depth: depth
    )
    sierpinski(
      context: context,
      points: (top: leftMiddle, left: left, right: bottomMiddle),
      color: nextColor,
      depth: depth
    )
    sierpinski(
      context: context,
      points: (top: rightMiddle, left: bottomMiddle, right: right),
      color: nextColor,
      depth: depth
    )
  }
}

private func drawTriangle(
  context: JSValue,
  points: Points,
  color: Color
) {
  let (top, left, right) = points
  let colorStr = "rgb(\(color.0), \(color.1), \(color.2))"
  var context = context
  context.fillStyle = .string(colorStr)
  _ = context.moveTo(top.0, top.1)
  _ = context.beginPath()
  _ = context.lineTo(left.0, left.1)
  _ = context.lineTo(right.0, right.1)
  _ = context.lineTo(top.0, top.1)
  _ = context.closePath()
  _ = context.stroke()
  _ = context.fill()
}

private func midPoint(_ point1: Point, _ point2: Point) -> Point {
  ((point1.0 + point2.0) / 2, (point1.1 + point2.1) / 2)
}
