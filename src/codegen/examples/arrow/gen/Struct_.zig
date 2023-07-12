//! generated by flatc-zig from Schema.fbs

const flatbuffers = @import("flatbuffers");

/// A Struct_ in the flatbuffer metadata is the same as an Arrow Struct
/// (according to the physical memory layout). We used Struct_ here as
/// Struct is a reserved word in Flatbuffers
pub const Struct = struct {
    const Self = @This();

    pub fn pack(self: Self, builder: *flatbuffers.Builder) flatbuffers.Error!u32 {
        _ = self;
        try builder.startTable();
        return builder.endTable();
    }
};

/// A Struct_ in the flatbuffer metadata is the same as an Arrow Struct
/// (according to the physical memory layout). We used Struct_ here as
/// Struct is a reserved word in Flatbuffers
pub const PackedStruct = struct {};
