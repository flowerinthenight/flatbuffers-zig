const flatbuffers = @import("flatbuffers");
const std = @import("std");

/// File specific information.
/// Symbols declared within a file may be recovered by iterating over all
/// symbols and examining the `declaration_file` field.
pub const SchemaFile = struct {
    /// Filename, relative to project root.
    filename: [:0]const u8,
    /// Names of included files, relative to project root.
    included_filenames: [][:0]const u8,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, packed_: PackedSchemaFile) !Self {
        return .{
            .filename = try packed_.filename(),
            .included_filenames = try flatbuffers.unpackVector(allocator, [:0]const u8, packed_, "includedFilenames"),
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.included_filenames);
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .included_filenames = try builder.prependVectorOffsets([:0]const u8, self.included_filenames),
            .filename = try builder.prependString(self.filename),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.filename);
        try builder.appendTableFieldOffset(field_offsets.included_filenames);
        return builder.endTable();
    }
};

/// File specific information.
/// Symbols declared within a file may be recovered by iterating over all
/// symbols and examining the `declaration_file` field.
pub const PackedSchemaFile = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) !Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    /// Filename, relative to project root.
    pub fn filename(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    /// Names of included files, relative to project root.
    pub fn includedFilenamesLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(1);
    }
    pub fn includedFilenames(self: Self, index: usize) ![:0]const u8 {
        return self.table.readFieldVectorItem([:0]const u8, 1, index);
    }
};
