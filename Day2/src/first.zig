const std = @import("std");
const shared = @import("shared");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const lines = try shared.getData(allocator, "Day2/puzzle_input.txt", 1024 * 1024);
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
        allocator.free(lines);
    }

    var safe: usize = 0;

    for (lines) |line| {
        var levels = std.mem.split(u8, std.mem.trim(u8, line, " \n\r\t"), " ");
        const first = levels.next();
        var first_level: usize = 0;
        if (first) |value| {
            first_level = try std.fmt.parseInt(u8, value, 10);
        } else {
            return error.InvalidInput;
        }

        const second = levels.next();
        var second_level: usize = 0;
        if (second) |value| {
            second_level = try std.fmt.parseInt(u8, value, 10);
        } else {
            return error.InvalidInput;
        }

        if (second_level > first_level and (second_level != first_level and second_level - 3 <= first_level)) {
            // Increasing
            if (try isIncreasing(second_level, &levels)) {
                safe += 1;
            }
        } else if (second_level < first_level and (second_level != first_level and second_level + 3 >= first_level)) {
            // Decreasing
            if (try isDecreasing(second_level, &levels)) {
                safe += 1;
            }
        } else {
            continue;
        }
    }

    std.debug.print("Number of safe: {}", .{safe});
}

fn isIncreasing(current_level: usize, levels: *std.mem.SplitIterator(u8, std.mem.DelimiterType.sequence)) !bool {
    var now = current_level;
    while (levels.next()) |level| {
        const next_level = try std.fmt.parseInt(u8, level, 10);
        if (next_level > now and (next_level != now and next_level - 3 <= now)) {
            now = next_level;
            continue;
        } else {
            return false;
        }
    }

    return true;
}

fn isDecreasing(current_level: usize, levels: *std.mem.SplitIterator(u8, std.mem.DelimiterType.sequence)) !bool {
    var now = current_level;
    while (levels.next()) |level| {
        const next_level = try std.fmt.parseInt(u8, level, 10);
        if (next_level < now and (next_level != now and next_level + 3 >= now)) {
            now = next_level;
            continue;
        } else {
            return false;
        }
    }

    return true;
}
