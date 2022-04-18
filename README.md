# Stub

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

A minimal method stub for Swift.

## At a Glance

```swift
import Stub

final class StubUserService: UserServiceProtocol {
  @StubProxy(follow) var followStub
  func follow(userID: Int) -> String {
    followStub.invoke(userID, default: "")
  }

  @StubProxy(edit) var editStub
  func edit(userID: Int, name: String) -> Bool {
    editStub.invoke((userID, name), default: false)
  }
}

func testMethodCall() {
  // given
  let userService = StubUserService()
  userService.followStub.register { userID in "stub-\(userID)" } // stub

  // when
  userService.follow(userID: 123) // call

  // then
  let executions = userService.followStub.executions()
  XCTAssertEqual(executions.count, 1)
  XCTAssertEqual(executions[0].arguments, 123)
  XCTAssertEqual(executions[0].result, "stub-123")
}
```

## Usage

### Invoke with default value

```swift
@StubProxy(fetchOverview) var fetchOverviewStub
func fetchOverview(id: String) -> Overview {
  fetchOverviewStub.invoke(id, default: Overview.fixture)
}
```

### Invoke without default value

> ⚠️ You need to register a stub before calling `invokeWithoutDefault()`

```swift
@StubProxy(fetchOverview) var fetchOverviewStub
func fetchOverview(id: String) -> Overview {
  fetchOverviewStub.invokeWithoutDefault(id)
}
```

### Generic

```swift
let convertStubStore = StubStore()
func convert<Source, Target>(_ source: Source) -> Target {
  let stub = convertStubStore.stub(arguments: Source.self, result: Target.self)
  return stub.invokeWithoutDefault(value)
}
```

### Clear all stubs and executions

```swift
Stub.clearAll()
```

[ClearAllTests.swift](Tests/StubTests/ClearAllTests.swift)

## License

Stub is under MIT license. See the [LICENSE](LICENSE) for more info.
