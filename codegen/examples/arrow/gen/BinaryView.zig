//! generated by flatc-zig from Schema.fbs

const flatbuffers = @import("flatbuffers");

/// Logically the same as Binary, but the internal representation uses a view
/// struct that contains the string length and either the string's entire data
/// inline (for small strings) or an inlined prefix, an index of another buffer,
/// and an offset pointing to a slice in that buffer (for non-small strings).
///
/// Since it uses a variable number of data buffers, each Field with this type
/// must have a corresponding entry in `variadicBufferCounts`.
pub const BinaryView = struct {
    const Self = @This();

    pub fn pack(self: Self, builder: *flatbuffers.Builder) flatbuffers.Error!u32 {
        _ = self;
        try builder.startTable();
        return builder.endTable();
    }
};

/// Logically the same as Binary, but the internal representation uses a view
/// struct that contains the string length and either the string's entire data
/// inline (for small strings) or an inlined prefix, an index of another buffer,
/// and an offset pointing to a slice in that buffer (for non-small strings).
///
/// Since it uses a variable number of data buffers, each Field with this type
/// must have a corresponding entry in `variadicBufferCounts`.
pub const PackedBinaryView = struct {};
