const std = @import("std");
const shared = @import("shared");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const lines = try shared.getData(&allocator, "Day2/puzzle_input.txt", 1024 * 1024);
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
        allocator.free(lines);
    }

    std.debug.print("Hej du", .{});
}
