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


  // when use async function

  @AsyncStubProxy(upload) var uploadStub
  func upload(image: UIImage) async throws -> URL {
    await uploadStub.invoke(image, default: URL(string: "https://")!)
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

func testAsyncMethodCall() async {
  // given
  let userService = StubUserService()
  await userService.uploadStub.register { image in URL(string: "https://hello.com")! } // stub
  let image = UIImage("profile")

  // when
  await userService.upload(image: image) // call

  // then
  let executions = await userService.followStub.executions()
  XCTAssertEqual(executions.count, 1)
  XCTAssertEqual(executions[0].arguments, image)
  XCTAssertEqual(executions[0].result, URL(string: "https://hello.com")!)
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

When use async function
```swift
@AsyncStubProxy(fetchOverview) var fetchOverviewStub
func fetchOverview(id: String) async -> Overview {
  await fetchOverviewStub.invoke(id, default: Overview.fixture)
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

When use async function
```swift
@AsyncStubProxy(fetchOverview) var fetchOverviewStub
func fetchOverview(id: String) async -> Overview {
  await fetchOverviewStub.invokeWithoutDefault(id)
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

When use async function
```swift
let convertStubStore = StubStore()
func convert<Source, Target>(_ source: Source) async -> Target {
  let stub = convertStubStore.asyncStub(arguments: Source.self, result: Target.self)
  return await stub.invokeWithoutDefault(value)
}
```

### Clear all stubs and executions

```swift
Stub.clearAll()
```

[ClearAllTests.swift](Tests/StubTests/ClearAllTests.swift)

## License

Stub is under MIT license. See the [LICENSE](LICENSE) for more info.
