const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // ---- Shared ------
    const shared = b.addModule("shared", .{
        .root_source_file = b.path("shared/shared.zig"),
    });

    // ---- Day 1a -------
    const day1a = b.addExecutable(.{
        .name = "day1a",
        .root_source_file = b.path("Day1/src/first.zig"),
        .target = target,
        .optimize = optimize,
    });

    day1a.root_module.addImport("shared", shared);
    b.installArtifact(day1a);

    const run_day1a = b.addRunArtifact(day1a);

    // ---- Day 1b -------
    const day1b = b.addExecutable(.{
        .name = "day1b",
        .root_source_file = b.path("Day1/src/second.zig"),
        .target = target,
        .optimize = optimize,
    });

    day1b.root_module.addImport("shared", shared);
    b.installArtifact(day1b);

    const run_day1b = b.addRunArtifact(day1b);

    // ---- Day 2a -------
    const day2a = b.addExecutable(.{
        .name = "day2a",
        .root_source_file = b.path("Day2/src/first.zig"),
        .target = target,
        .optimize = optimize,
    });

    day2a.root_module.addImport("shared", shared);
    b.installArtifact(day2a);

    const run_day2a = b.addRunArtifact(day2a);

    // ---- Run steps
    const run_step = b.step("run", "Run a specific executable based on input");
    run_step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_day1a.addArgs(args);
        run_day1b.addArgs(args);

        const day = args[0];
        if (std.mem.eql(u8, day, "day1a")) {
            run_step.dependOn(&run_day1a.step);
        } else if (std.mem.eql(u8, day, "day1b")) {
            run_step.dependOn(&run_day1b.step);
        } else if (std.mem.eql(u8, day, "day2a")) {
            run_step.dependOn(&run_day2a.step);
        }
    }
}
