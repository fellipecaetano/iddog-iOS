public final class Disposable {
    public let dispose: () -> Void
    
    init (dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
}
