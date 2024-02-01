//! generated by flatc-zig from Message.fbs

const flatbuffers = @import("flatbuffers");
const std = @import("std");
const types = @import("lib.zig");

/// A data header describing the shared memory layout of a "record" or "row"
/// batch. Some systems call this a "row batch" internally and others a "record
/// batch".
pub const RecordBatch = struct {
    /// number of records / rows. The arrays in the batch should all have this
    /// length
    length: i64 = 0,
    /// Nodes correspond to the pre-ordered flattened logical schema
    nodes: []types.FieldNode,
    /// Buffers correspond to the pre-ordered flattened buffer tree
    ///
    /// The number of buffers appended to this list depends on the schema. For
    /// example, most primitive arrays will have 2 buffers, 1 for the validity
    /// bitmap and 1 for the values. For struct arrays, there will only be a
    /// single buffer for the validity (nulls) bitmap
    buffers: []types.Buffer,
    /// Optional compression of the message body
    compression: ?types.BodyCompression = null,
    /// Some types such as Utf8View are represented using a variable number of buffers.
    /// For each such Field in the pre-ordered flattened logical schema, there will be
    /// an entry in variadicBufferCounts to indicate the number of number of variadic
    /// buffers which belong to that Field in the current RecordBatch.
    ///
    /// For example, the schema
    ///     col1: Struct<alpha: Int32, beta: BinaryView, gamma: Float64>
    ///     col2: Utf8View
    /// contains two Fields with variadic buffers so variadicBufferCounts will have
    /// two entries, the first counting the variadic buffers of `col1.beta` and the
    /// second counting `col2`'s.
    ///
    /// This field may be omitted if and only if the schema contains no Fields with
    /// a variable number of buffers, such as BinaryView and Utf8View.
    variadic_buffer_counts: []i64,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, packed_: PackedRecordBatch) flatbuffers.Error!Self {
        const nodes_ = try flatbuffers.unpackVector(allocator, types.FieldNode, packed_, "nodes");
        errdefer {
            allocator.free(nodes_);
        }
        const buffers_ = try flatbuffers.unpackVector(allocator, types.Buffer, packed_, "buffers");
        errdefer {
            allocator.free(buffers_);
        }
        const variadic_buffer_counts_ = try flatbuffers.unpackVector(allocator, i64, packed_, "variadicBufferCounts");
        errdefer {
            allocator.free(variadic_buffer_counts_);
        }
        return .{
            .length = try packed_.length(),
            .nodes = nodes_,
            .buffers = buffers_,
            .compression = try packed_.compression(),
            .variadic_buffer_counts = variadic_buffer_counts_,
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.nodes);
        allocator.free(self.buffers);
        allocator.free(self.variadic_buffer_counts);
    }

    pub fn pack(self: Self, builder: *flatbuffers.Builder) flatbuffers.Error!u32 {
        const field_offsets = .{
            .nodes = try builder.prependVector(types.FieldNode, self.nodes),
            .buffers = try builder.prependVector(types.Buffer, self.buffers),
            .compression = if (self.compression) |c| try c.pack(builder) else 0,
            .variadic_buffer_counts = try builder.prependVector(i64, self.variadic_buffer_counts),
        };

        try builder.startTable();
        try builder.appendTableFieldWithDefault(i64, self.length, 0);
        try builder.appendTableFieldOffset(field_offsets.nodes);
        try builder.appendTableFieldOffset(field_offsets.buffers);
        try builder.appendTableFieldOffset(field_offsets.compression);
        try builder.appendTableFieldOffset(field_offsets.variadic_buffer_counts);
        return builder.endTable();
    }
};

/// A data header describing the shared memory layout of a "record" or "row"
/// batch. Some systems call this a "row batch" internally and others a "record
/// batch".
pub const PackedRecordBatch = struct {
    table: flatbuffers.Table,

    const Self = @This();

    pub fn init(size_prefixed_bytes: []u8) flatbuffers.Error!Self {
        return .{ .table = try flatbuffers.Table.init(size_prefixed_bytes) };
    }

    /// number of records / rows. The arrays in the batch should all have this
    /// length
    pub fn length(self: Self) flatbuffers.Error!i64 {
        return self.table.readFieldWithDefault(i64, 0, 0);
    }

    /// Nodes correspond to the pre-ordered flattened logical schema
    pub fn nodes(self: Self) flatbuffers.Error![]align(1) types.FieldNode {
        return self.table.readField([]align(1) types.FieldNode, 1);
    }

    /// Buffers correspond to the pre-ordered flattened buffer tree
    ///
    /// The number of buffers appended to this list depends on the schema. For
    /// example, most primitive arrays will have 2 buffers, 1 for the validity
    /// bitmap and 1 for the values. For struct arrays, there will only be a
    /// single buffer for the validity (nulls) bitmap
    pub fn buffers(self: Self) flatbuffers.Error![]align(1) types.Buffer {
        return self.table.readField([]align(1) types.Buffer, 2);
    }

    /// Optional compression of the message body
    pub fn compression(self: Self) flatbuffers.Error!?types.PackedBodyCompression {
        return self.table.readField(?types.PackedBodyCompression, 3);
    }

    /// Some types such as Utf8View are represented using a variable number of buffers.
    /// For each such Field in the pre-ordered flattened logical schema, there will be
    /// an entry in variadicBufferCounts to indicate the number of number of variadic
    /// buffers which belong to that Field in the current RecordBatch.
    ///
    /// For example, the schema
    ///     col1: Struct<alpha: Int32, beta: BinaryView, gamma: Float64>
    ///     col2: Utf8View
    /// contains two Fields with variadic buffers so variadicBufferCounts will have
    /// two entries, the first counting the variadic buffers of `col1.beta` and the
    /// second counting `col2`'s.
    ///
    /// This field may be omitted if and only if the schema contains no Fields with
    /// a variable number of buffers, such as BinaryView and Utf8View.
    pub fn variadicBufferCounts(self: Self) flatbuffers.Error![]align(1) i64 {
        return self.table.readField([]align(1) i64, 4);
    }
};
