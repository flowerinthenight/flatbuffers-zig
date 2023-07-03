const flatbuffers = @import("flatbuffers");

pub const KeyValue = struct {
    key: [:0]const u8,
    value: [:0]const u8,

    const Self = @This();

    pub fn init(packed_: PackedKeyValue) !Self {
        return .{
            .key = try packed_.key(),
            .value = try packed_.value(),
        };
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .value = try builder.prependString(self.value),
            .key = try builder.prependString(self.key),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.key);
        try builder.appendTableFieldOffset(field_offsets.value);
        return builder.endTable();
    }
};

pub const PackedKeyValue = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) !Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    pub fn key(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    pub fn value(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 1);
    }
};
