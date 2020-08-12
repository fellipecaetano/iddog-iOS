import Streams

@available(iOS 10.0, *)
extension Effect {
    func timed(interval: TimeInterval, repeats: Bool) -> Self {
        return Effect.run { handler in
            var disposableForThisEffect: Disposable?

            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { _ in
                disposableForThisEffect = self.subscribe(handler)
            }

            return Disposable {
                disposableForThisEffect?.dispose()
                timer.invalidate()
            }
        }
    }
}
