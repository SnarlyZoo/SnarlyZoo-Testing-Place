function CreateForces(rootPart: BasePart): (AlignOrientation, VectorForce)
    local alignOri = Instance.new("AlignOrientation")
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.AlignType = Enum.AlignType.Parallel
    alignOri.RigidityEnabled = true
    alignOri.Attachment0 = rootPart.RootAttachment
    alignOri.Parent = rootPart

    local vectorForce = Instance.new("VectorForce")
    vectorForce.Attachment0 = rootPart.RootAttachment
    vectorForce.Force = Vector3.new()
    vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    vectorForce.Parent = rootPart

    return alignOri, vectorForce
end

return CreateForces