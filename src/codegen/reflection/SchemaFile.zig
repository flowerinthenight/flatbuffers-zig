const flatbuffers = @import("flatbuffers");

pub const SchemaFile = struct {
    filename: [:0]const u8,

    const Self = @This();

    pub fn init(packed_: PackedSchemaFile) !Self {
        return .{
            .filename = try packed_.filename(),
        };
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .included_filenames = try builder.prependVector([:0]const u8, self.included_filenames),
            .filename = try builder.prependString(self.filename),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.filename);
        try builder.appendTableFieldOffset(field_offsets.included_filenames);
        return builder.endTable();
    }
};

pub const PackedSchemaFile = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) !Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    pub fn filename(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    pub fn includedFilenames(self: Self) ![]align(1) [:0]const u8 {
        return self.table.readField([]align(1) [:0]const u8, 1);
    }
};
