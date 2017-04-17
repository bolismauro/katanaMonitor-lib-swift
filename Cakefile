project.name = "KatanaMonitor"

project.all_configurations.each do |configuration|
    configuration.settings["SWIFT_VERSION"] = "3.1"
end

monitor = target do |target|
    target.name = "KatanaMonitor"
    target.platform = :ios
    target.deployment_target = 9.0
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "KatanaMonitor/**/*.swift",
        "KatanaMonitor/**/*.m",
        "KatanaMonitor/**/*.h",
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "KatanaMonitor/SupportingFiles/iOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "KatanaMonitor"
    end

    target.headers_build_phase do |phase|
        phase.public << "KatanaMonitor/SupportingFiles/iOS/KatanaMonitor.h"
        phase.public << "KatanaMonitor/SocketCluster/SCChannel.h"
        phase.public << "KatanaMonitor/SocketCluster/SCMessage.h"
        phase.public << "KatanaMonitor/SocketCluster/SCSocket.h"
    end

    target.scheme(target.name)
end

project.targets.each do |target|
    target.shell_script_build_phase "Lint", <<-SCRIPT 
    if which swiftlint >/dev/null; then
        swiftlint
    else
        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
    SCRIPT
end