#if SWIFT_PACKAGE
import Clang_C
#endif
private let library = toolchainLoader.load("libclang.dylib")
internal let clang_getCString: @convention(c) (CXString) -> (UnsafePointer<Int8>) = library.loadSymbol("clang_getCString")
internal let clang_disposeString: @convention(c) (CXString) -> () = library.loadSymbol("clang_disposeString")
