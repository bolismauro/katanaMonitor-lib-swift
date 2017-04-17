# Katana Monitor

[Katana](https://github.com/BendingSpoons/katana-lib-swift/) middleware that can be used to communicate with redux-dev tools. It has been tested with  [http://remotedev.io/local/](http://remotedev.io/local/), but it should work with [other monitors]( https://github.com/zalmoxisus/remote-redux-devtools#monitoring) too.

The project is currently a work in progress and it has mainly created as a proof of concept.

#### Dependencies

Install the remotedev node server once:

```sh
npm install -g remotedev-server
```

Run the server (every time you want to use the monitor)

#### Project Integration
The monitor is shipped using Cocoapods.

Add the pod `KatanaMonitor`

```ruby
pod 'KatanaMonitor', :configurations => ['Debug']
```

The middleware should be used in debug configurations only.

In your application, conditionally add the middleware. Here, for instance, we use the `DEBUG` macro to conditionally add the middleware in debug configurations only:

```swift
var middleware: [StoreMiddleware] = [
	// other middleware
]

#if DEBUG
middleware.append(MonitorMiddleware.create(using: .defaultConfiguration))
#endif
```



#### Usage

* Open [http://remotedev.io/local/](http://remotedev.io/local/) in your browser. Click `settings` and make sure that `Use custom local server` is selected and the configuration is the proper ones (by default localhost and 8000). This is the UI where actions will appear
* Launch `remotedev` in your terminal
* Launch your katana application



#### Current limitations and TODO

* The current implementation only support actions and state diff logging. Time traveling, dispatch from the UI and other features are not implemented
* The project contains a modified version of the [iOS socket cluster client](https://github.com/abpopov/SocketCluster-ios-client). We should send a PR to the project or write a nice swift client
* Actions and state are currently encoded using `Mirror` API in swift. We should improve the encoding as well as add a new, less hackish, way to encode them
