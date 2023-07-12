//! generated by flatc-zig from Schema.fbs

const flatbuffers = @import("flatbuffers");
const std = @import("std");
const types = @import("lib.zig");

/// ----------------------------------------------------------------------
/// A field represents a named column in a record / row batch or child of a
/// nested type.
pub const Field = struct {
    /// Name is not required, in i.e. a List
    name: [:0]const u8,
    /// Whether or not this field can contain nulls. Should be true in general.
    nullable: bool = false,
    /// This is the type of the decoded value if the field is dictionary encoded.
    type: types.Type,
    /// Present only if the field is dictionary encoded.
    dictionary: ?types.DictionaryEncoding = null,
    /// children apply only to nested data types like Struct, List and Union. For
    /// primitive types children will have length 0.
    children: []types.Field,
    /// User-defined metadata
    custom_metadata: []types.KeyValue,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, packed_: PackedField) flatbuffers.Error!Self {
        const name_ = try allocator.dupeZ(u8, try packed_.name());
        errdefer {
            allocator.free(name_);
        }
        const @"type" = try types.Type.init(allocator, try packed_.type());
        errdefer {
            @"type".deinit(allocator);
        }
        const dictionary_ = if (try packed_.dictionary()) |d| try types.DictionaryEncoding.init(d) else null;
        errdefer {}
        const children_ = try flatbuffers.unpackVector(allocator, types.Field, packed_, "children");
        errdefer {
            for (children_) |c| c.deinit(allocator);
            allocator.free(children_);
        }
        const custom_metadata_ = try flatbuffers.unpackVector(allocator, types.KeyValue, packed_, "customMetadata");
        errdefer {
            for (custom_metadata_) |c| c.deinit(allocator);
            allocator.free(custom_metadata_);
        }
        return .{
            .name = name_,
            .nullable = try packed_.nullable(),
            .type = @"type",
            .dictionary = dictionary_,
            .children = children_,
            .custom_metadata = custom_metadata_,
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.name);
        self.type.deinit(allocator);
        for (self.children) |c| c.deinit(allocator);
        allocator.free(self.children);
        for (self.custom_metadata) |c| c.deinit(allocator);
        allocator.free(self.custom_metadata);
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) flatbuffers.Error!u32 {
        const field_offsets = .{
            .name = try builder.prependString(self.name),
            .type = try self.type.pack(builder),
            .dictionary = if (self.dictionary) |d| try d.pack(builder) else 0,
            .children = try builder.prependVectorOffsets(types.Field, self.children),
            .custom_metadata = try builder.prependVectorOffsets(types.KeyValue, self.custom_metadata),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.name);
        try builder.appendTableField(bool, self.nullable);
        try builder.appendTableField(types.PackedType.Tag, self.type);
        try builder.appendTableFieldOffset(field_offsets.type);
        try builder.appendTableFieldOffset(field_offsets.dictionary);
        try builder.appendTableFieldOffset(field_offsets.children);
        try builder.appendTableFieldOffset(field_offsets.custom_metadata);
        return builder.endTable();
    }
};

/// ----------------------------------------------------------------------
/// A field represents a named column in a record / row batch or child of a
/// nested type.
pub const PackedField = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) flatbuffers.Error!Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    /// Name is not required, in i.e. a List
    pub fn name(self: Self) flatbuffers.Error![:0]const u8 {
        return self.table.readField([:0]const u8, 0);
    }

    /// Whether or not this field can contain nulls. Should be true in general.
    pub fn nullable(self: Self) flatbuffers.Error!bool {
        return self.table.readFieldWithDefault(bool, 1, false);
    }

    pub fn typeType(self: Self) flatbuffers.Error!types.PackedType.Tag {
        return self.table.readFieldWithDefault(types.PackedType.Tag, 2, .none);
    }

    /// This is the type of the decoded value if the field is dictionary encoded.
    pub fn @"type"(self: Self) flatbuffers.Error!types.PackedType {
        return switch (try self.typeType()) {
            inline else => |tag| {
                var result = @unionInit(types.PackedType, @tagName(tag), undefined);
                const field = &@field(result, @tagName(tag));
                field.* = try self.table.readField(@TypeOf(field.*), 3);
                return result;
            },
        };
    }

    /// Present only if the field is dictionary encoded.
    pub fn dictionary(self: Self) flatbuffers.Error!?types.PackedDictionaryEncoding {
        return self.table.readField(?types.PackedDictionaryEncoding, 4);
    }

    /// children apply only to nested data types like Struct, List and Union. For
    /// primitive types children will have length 0.
    pub fn childrenLen(self: Self) flatbuffers.Error!u32 {
        return self.table.readFieldVectorLen(5);
    }
    pub fn children(self: Self, index: usize) flatbuffers.Error!types.PackedField {
        return self.table.readFieldVectorItem(types.PackedField, 5, index);
    }

    /// User-defined metadata
    pub fn customMetadataLen(self: Self) flatbuffers.Error!u32 {
        return self.table.readFieldVectorLen(6);
    }
    pub fn customMetadata(self: Self, index: usize) flatbuffers.Error!types.PackedKeyValue {
        return self.table.readFieldVectorItem(types.PackedKeyValue, 6, index);
    }
};
