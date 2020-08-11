public final class Disposable {
    public let dispose: () -> Void

    public init(dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

    public static var none: Disposable {
        return Disposable {}
    }
}
