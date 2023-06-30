pub const Weapon = struct {
    name: [:0]const u8,
    damage: i16 = 0,

    const Self = @This();

    pub fn init(packed_: PackedWeapon) !Self {
        return .{
            .name = try packed_.name(),
            .damage = try packed_.damage(),
        };
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .name = try builder.prependString(self.name),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.name);
        try builder.appendTableField(i16, self.damage);
        return builder.endTable();
    }
};

pub const PackedWeapon = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) !Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    pub fn name(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    pub fn damage(self: Self) !i16 {
        return self.table.readFieldWithDefault(i16, 1, 0);
    }
};
