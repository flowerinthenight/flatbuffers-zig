// Handwritten. Codegen should match exactly.
const std = @import("std");
const flatbuffers = @import("flatbuffers");
const Builder = flatbuffers.Builder;
const Table = flatbuffers.Table;

pub const Color = enum(i8) {
    red = 0,
    green = 1,
    blue = 2,
};

pub const Vec4 = extern struct {
    v: [4]f32,
};

pub const Vec3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const Weapon = struct {
    name: [:0]const u8,
    damage: i16,

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
        try builder.appendTableFieldOffset(field_offsets.name); // field 0
        try builder.appendTableField(i16, self.damage); // field 1
        return try builder.endTable();
    }
};

pub const PackedWeapon = struct {
    table: Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) Self {
        return .{ .table = Table.init(size_prefixed_bytes) };
    }

    pub fn name(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    pub fn damage(self: Self) !i16 {
        return self.table.readField(i16, 1);
    }
};

pub const Equipment = union(enum) {
    none,
    weapon: Weapon,

    const Self = @This();

    pub fn init(packed_: PackedEquipment) !Self {
        switch (packed_) {
            inline else => |v, t| {
                var result = @unionInit(Self, @tagName(t), undefined);
                const field = &@field(result, @tagName(t));
                const Field = @TypeOf(field.*);
                field.* = if (comptime Table.isPacked(Field)) v else try Field.init(v);
                return result;
            },
        }
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        switch (self) {
            inline else => |v| {
                if (comptime flatbuffers.Table.isPacked(@TypeOf(v))) {
                    try builder.prepend(v);
                    return builder.offset();
                }
                return try v.pack(builder);
            },
        }
    }
};

pub const PackedEquipment = union(enum) {
    none: void,
    weapon: PackedWeapon,

    pub const Tag = std.meta.Tag(@This());
};

pub const Monster = struct {
    pos: ?Vec3 = null,
    mana: i16 = 150,
    hp: i16 = 100,
    name: [:0]const u8,
    inventory: []u8,
    color: Color = .blue,
    weapons: []Weapon,
    equipped: Equipment,
    path: []Vec3,
    rotation: ?Vec4 = null,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, packed_: PackedMonster) !Self {
        return .{
            .pos = try packed_.pos(),
            .mana = try packed_.mana(),
            .hp = try packed_.hp(),
            .name = try packed_.name(),
            .inventory = try packed_.inventory(),
            .color = try packed_.color(),
            .weapons = brk: {
                var res = try allocator.alloc(Weapon, try packed_.weaponsLen());
                errdefer allocator.free(res);
                for (res, 0..) |*r, i| r.* = try Weapon.init(try packed_.weapons(@intCast(u32, i)));
                break :brk res;
            },
            .equipped = try Equipment.init(try packed_.equipped()),
            .path = brk: {
                // Fix alignment
                const path = try packed_.path();
                var res = try allocator.alloc(Vec3, path.len);
                for (0..path.len) |i| res[i] = path[i];
                break :brk res;
            },
            .rotation = try packed_.rotation(),
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.path);
        allocator.free(self.weapons);
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .weapons = try builder.prependVectorOffsets(Weapon, self.weapons),
            .inventory = try builder.prependVector(u8, self.inventory),
            .equipped = try self.equipped.pack(builder),
            .name = try builder.prependString(self.name),
            .path = try builder.prependVector(Vec3, self.path),
        };

        try builder.startTable();
        try builder.appendTableField(?Vec3, self.pos); // field 0
        try builder.appendTableField(i16, self.mana); // field 1
        try builder.appendTableField(i16, self.hp); // field 2
        try builder.appendTableFieldOffset(field_offsets.name); // field 3
        try builder.appendTableFieldOffset(0); // field 4 (friendly, deprecated)
        try builder.appendTableFieldOffset(field_offsets.inventory); // field 5
        try builder.appendTableField(Color, self.color); // field 6
        try builder.appendTableFieldOffset(field_offsets.weapons); // field 7
        try builder.appendTableField(Equipment, self.equipped); // field 8
        try builder.appendTableFieldOffset(field_offsets.equipped); // field 9
        try builder.appendTableFieldOffset(field_offsets.path); // field 10
        try builder.appendTableField(?Vec4, self.rotation); // field 11
        return try builder.endTable();
    }
};

pub const PackedMonster = struct {
    table: Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) !Self {
        return .{ .table = try Table.init(size_prefixed_bytes) };
    }

    pub fn pos(self: Self) !?Vec3 {
        return self.table.readField(?Vec3, 0);
    }

    pub fn mana(self: Self) !i16 {
        return self.table.readFieldWithDefault(i16, 1, 150);
    }

    pub fn hp(self: Self) !i16 {
        return self.table.readFieldWithDefault(i16, 2, 100);
    }

    pub fn name(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 3);
    }

    pub fn inventory(self: Self) ![]u8 {
        return self.table.readField([]u8, 5);
    }

    pub fn color(self: Self) !Color {
        return self.table.readFieldWithDefault(Color, 6, .blue);
    }

    pub fn weaponsLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(7);
    }
    pub fn weapons(self: Self, index: u32) !PackedWeapon {
        return self.table.readFieldVectorItem(PackedWeapon, 7, index);
    }

    pub fn equippedType(self: Self) !PackedEquipment.Tag {
        return self.table.readFieldWithDefault(PackedEquipment.Tag, 8, .none);
    }
    pub fn equipped(self: Self) !PackedEquipment {
        return switch (try self.equippedType()) {
            inline else => |t| {
                var result = @unionInit(PackedEquipment, @tagName(t), undefined);
                const field = &@field(result, @tagName(t));
                field.* = try self.table.readField(@TypeOf(field.*), 9);
                return result;
            },
        };
    }

    pub fn path(self: Self) ![]align(1) Vec3 {
        return self.table.readField([]align(1) Vec3, 10);
    }

    pub fn rotation(self: Self) !?Vec4 {
        return self.table.readField(?Vec4, 11);
    }
};
