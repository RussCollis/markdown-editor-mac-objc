// swift-tools-version:5.7
// Local Swift package wrapping the GCDWebServer 3.5.4 sources
// (https://github.com/swisspol/GCDWebServer), which has no official SwiftPM support.
import PackageDescription

let package = Package(
    name: "GCDWebServer",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "GCDWebServer", targets: ["GCDWebServer"])
    ],
    targets: [
        .target(
            name: "GCDWebServer",
            path: "Sources/GCDWebServer",
            publicHeadersPath: "include",
            cSettings: [
                // The library's own sources import its public headers by bare name.
                .headerSearchPath("include/GCDWebServer")
            ],
            linkerSettings: [
                .linkedFramework("CFNetwork"),
                .linkedFramework("CoreServices"),
                .linkedLibrary("z")
            ]
        )
    ]
)
