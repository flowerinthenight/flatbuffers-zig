//!
//! generated by flatc-zig
//! schema:     reflection.fbs
//! typename    Schema
//!

const flatbuffers = @import("flatbuffers");
const std = @import("std");
const Types = @import("./lib.zig");

pub const Schema = struct {
    objects: []Types.Object,
    enums: []Types.Enum,
    file_ident: [:0]const u8,
    file_ext: [:0]const u8,
    root_table: ?Types.Object = null,
    services: []Types.Service,
    advanced_features: Types.AdvancedFeatures = @intToEnum(Types.AdvancedFeatures, 0),
    fbs_files: []Types.SchemaFile,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, packed_: PackedSchema) !Self {
        return .{
            .objects = try flatbuffers.unpackVector(allocator, Types.Object, packed_, "objects", true),
            .enums = try flatbuffers.unpackVector(allocator, Types.Enum, packed_, "enums", true),
            .file_ident = try packed_.fileIdent(),
            .file_ext = try packed_.fileExt(),
            .root_table = if (try packed_.rootTable()) |r| try Types.Object.init(allocator, r) else null,
            .services = try flatbuffers.unpackVector(allocator, Types.Service, packed_, "services", true),
            .advanced_features = try packed_.advancedFeatures(),
            .fbs_files = try flatbuffers.unpackVector(allocator, Types.SchemaFile, packed_, "fbsFiles", false),
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) !void {
        allocator.free(self.enums);
        allocator.free(self.fbs_files);
        allocator.free(self.objects);
        allocator.free(self.services);
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) !u32 {
        const field_offsets = .{
            .enums = try builder.prependVectorOffsets(Types.Enum, self.enums),
            .services = try builder.prependVectorOffsets(Types.Service, self.services),
            .file_ident = try builder.prependString(self.file_ident),
            .objects = try builder.prependVectorOffsets(Types.Object, self.objects),
            .file_ext = try builder.prependString(self.file_ext),
            .fbs_files = try builder.prependVectorOffsets(Types.SchemaFile, self.fbs_files),
        };

        try builder.startTable();
        try builder.appendTableFieldOffset(field_offsets.objects);
        try builder.appendTableFieldOffset(field_offsets.enums);
        try builder.appendTableFieldOffset(field_offsets.file_ident);
        try builder.appendTableFieldOffset(field_offsets.file_ext);
        try builder.appendTableField(?Types.Object, self.root_table);
        try builder.appendTableFieldOffset(field_offsets.services);
        try builder.appendTableField(Types.AdvancedFeatures, self.advanced_features);
        try builder.appendTableFieldOffset(field_offsets.fbs_files);
        return builder.endTable();
    }
};

pub const PackedSchema = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []const u8) !Self {
        return .{ .table = try flatbuffers.Table.init(@constCast(size_prefixed_bytes)) };
    }

    pub fn objectsLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(0);
    }
    pub fn objects(self: Self, index: usize) !Types.PackedObject {
        return self.table.readFieldVectorItem(Types.PackedObject, 0, index);
    }

    pub fn enumsLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(1);
    }
    pub fn enums(self: Self, index: usize) !Types.PackedEnum {
        return self.table.readFieldVectorItem(Types.PackedEnum, 1, index);
    }

    pub fn fileIdent(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 2);
    }

    pub fn fileExt(self: Self) ![:0]const u8 {
        return self.table.readField([:0]const u8, 3);
    }

    pub fn rootTable(self: Self) !?Types.PackedObject {
        return self.table.readField(?Types.PackedObject, 4);
    }

    pub fn servicesLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(5);
    }
    pub fn services(self: Self, index: usize) !Types.PackedService {
        return self.table.readFieldVectorItem(Types.PackedService, 5, index);
    }

    pub fn advancedFeatures(self: Self) !Types.AdvancedFeatures {
        return self.table.readFieldWithDefault(Types.AdvancedFeatures, 6, @intToEnum(Types.AdvancedFeatures, 0));
    }

    pub fn fbsFilesLen(self: Self) !u32 {
        return self.table.readFieldVectorLen(7);
    }
    pub fn fbsFiles(self: Self, index: usize) !Types.PackedSchemaFile {
        return self.table.readFieldVectorItem(Types.PackedSchemaFile, 7, index);
    }
};
