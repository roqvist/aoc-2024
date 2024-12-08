const std = @import("std");
const shared = @import("shared");

pub fn main() !void {
    // Set up allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Get puzzle input
    const lines = try shared.getData(&allocator, "Day1/puzzle_input.txt", 1024 * 1024);
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
        allocator.free(lines);
    }

    // Prepare two columns for split up numbers
    var left_col = try allocator.alloc(u64, lines.len);
    var right_col = try allocator.alloc(u64, lines.len);
    defer allocator.free(left_col);
    defer allocator.free(right_col);

    // Split puzzle input into columns
    var i: usize = 0;
    for (lines) |line| {
        var nums = std.mem.split(u8, std.mem.trim(u8, line, " \n\r\t"), "   ");
        if (nums.next()) |left| {
            const left_num = try std.fmt.parseInt(u64, std.mem.trim(u8, left, " \n\r\t"), 10);
            left_col[i] = left_num;

            if (nums.next()) |right| {
                const right_num = try std.fmt.parseInt(u64, std.mem.trim(u8, right, " \n\r\t"), 10);
                right_col[i] = right_num;
            } else {
                return error.InvalidInput;
            }
        } else {
            return error.InvalidInput;
        }
        i += 1;
    }

    var sum: usize = 0;
    for (left_col) |left| {
        var hits: usize = 0;
        for (right_col) |right| {
            if (right == left) {
                hits += 1;
            }
        }

        sum += left * hits;
    }

    std.debug.print("Sum: {}", .{sum});
}
