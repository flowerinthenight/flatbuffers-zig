//!
//! generated by flatc-zig
//! binary:     ./examples/monster/monster.fbs
//! schema:     monster.fbs
//! file ident: //monster.fbs
//! typename    Weapon
//!

const flatbufferz = @import("flatbufferz");

pub const Weapon = struct {
    name: []const u8,
    damage: i16,

    const Self = @This();

    pub fn init(packed_struct: PackedWeapon) !Self {
        return .{
            .damage = packed_struct.damage(),
            .name = packed_struct.name(),
        };
    }

    pub fn pack(self: Self, builder: *flatbufferz.Builder) !u32 {
        const field_offsets = .{
            .name = try builder.createString(self.name),
        };

        try builder.startObject(2);
        try builder.prependSlotUOff(0, field_offsets.name, 0);
        try builder.prependSlot(i16, 1, self.damage, 0);
        return builder.endObject();
    }
};

pub const PackedWeapon = struct {
    table: flatbufferz.Table,

    const Self = @This();

    pub fn initRoot(bytes: []u8) Self {
        const offset = flatbufferz.encode.read(u32, bytes);
        return Self.initPos(bytes, offset);
    }

    pub fn initPos(bytes: []u8, pos: u32) Self {
        return .{ .table = .{ .bytes = bytes, .pos = pos } };
    }

    pub fn name(self: Self) []const u8 {
        const offset0 = self.table.offset(4);
        if (offset0 == 0) return "";
        return self.table.byteVector(offset0 + self.table.pos);
    }

    pub fn damage(self: Self) i16 {
        const offset0 = self.table.offset(6);
        if (offset0 == 0) return 0;
        return self.table.read(i16, self.table.pos + offset0);
    }
    pub fn setDamage(self: Self, val_: i16) void {
        self.table.mutateSlot(i16, 6, val_);
    }
};
