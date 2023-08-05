func rightMost(obstacleList: [any Obstacle]) -> Int16 {
  obstacleList.map { $0.right }
    .max() ?? 0
}
