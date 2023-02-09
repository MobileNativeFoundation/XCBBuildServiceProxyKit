public protocol Message {
    static var name: String { get }
}

let messageTypes: [Message.Type] = (
    buildMessageTypes +
    indexingMessageTypes +
    planningOperationMessageTypes +
    previewInfoMessageTypes +
    primitiveMessageTypes +
    sessionMessageTypes +
    workspaceMessageTypes
)


// TODO: SetConfigItemRequest
// TODO: ClearAllCachesRequest
// TODO: GetPlatformsRequest
// TODO: GetSDKsRequest
// TODO: GetSpecsRequest
// TODO: GetStatisticsRequest
// TODO: GetToolchainsRequest
// TODO: GetBuildSettingsDescriptionsRequest
// TODO: ExecuteCommandLineToolRequest

// TODO: CreateXCFrameworkRequest

// TODO: AvailableAppExtensionPointIdentifiersRequest

// TODO: MacCatalystUnavailableFrameworkNamesRequest
// TODO: AppleSystemFrameworkNamesRequest
// TODO: ProductTypeSupportsMacCatalystRequest
// TODO: DeveloperPathRequest
// TODO: SandboxRequest
