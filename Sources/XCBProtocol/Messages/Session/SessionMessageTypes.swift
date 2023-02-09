let sessionMessageTypes: [Message.Type] = [
    CreateSessionRequest.self,
    CreateSessionResponse.self,
    // TODO: ListSessionsRequest.self,
    // TODO: DeleteSessionsRequest.self,
    SetSessionSystemInfoRequest.self,
    SetSessionUserInfoRequest.self,
    SetSessionUserPreferencesRequest.self,
    SetSessionWorkspaceContainerPathRequest.self,
] + sessionPIFMessageTypes
