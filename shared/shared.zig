const std = @import("std");

pub fn getData(allocator: *std.mem.Allocator, file_path: []const u8, max_file_size: usize) ![][]const u8 {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    // Read entire file to buffer
    const file_content = try file.readToEndAlloc(allocator.*, max_file_size);
    defer allocator.free(file_content);

    var lines = std.ArrayList([]const u8).init(allocator.*);
    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    var cursor: usize = 0;

    while (cursor < file_content.len) {
        const newline_index = std.mem.indexOf(u8, file_content[cursor..], "\n") orelse file_content.len - cursor;

        const line = file_content[cursor .. cursor + newline_index];
        const line_copy = try allocator.alloc(u8, line.len);
        @memcpy(line_copy, line);
        try lines.append(line_copy);

        cursor += newline_index + 1;
    }

    return lines.toOwnedSlice();
}
