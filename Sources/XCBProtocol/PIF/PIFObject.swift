public enum PIFObject {
    case workspace(Workspace)
    case project(Project)
    case target(Target)
}

public struct PIFObjectList {
    public var objects: [PIFObject]

    public init(objects: [PIFObject]) {
        self.objects = objects
    }
}
