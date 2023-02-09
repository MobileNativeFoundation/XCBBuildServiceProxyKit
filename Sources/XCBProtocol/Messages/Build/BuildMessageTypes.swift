let buildMessageTypes: [Message.Type] = [
    BuildCancelRequest.self,
    BuildCreated.self,
    BuildDescriptionTargetInfoRequest.self,
    BuildStartRequest.self,
    CreateBuildRequest.self,
] + buildOperationMessageTypes
