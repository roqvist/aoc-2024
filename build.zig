const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // ---- Shared ------
    const shared = b.addModule("shared", .{
        .root_source_file = b.path("shared/shared.zig"),
    });

    // ---- Day 1 -------
    const day1 = b.addExecutable(.{
        .name = "day1",
        .root_source_file = b.path("Day1/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    day1.root_module.addImport("shared", shared);
    b.installArtifact(day1);

    const run_day1 = b.addRunArtifact(day1);

    // ---- Day 2 -------
    const day2 = b.addExecutable(.{
        .name = "day2",
        .root_source_file = b.path("Day2/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    day2.root_module.addImport("shared", shared);
    b.installArtifact(day2);

    const run_day2 = b.addRunArtifact(day2);

    // ---- Run steps
    const run_step = b.step("run", "Run a specific executable based on input");
    run_step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_day1.addArgs(args);
        run_day2.addArgs(args);

        const day = args[0];
        if (std.mem.eql(u8, day, "day1")) {
            run_step.dependOn(&run_day1.step);
        } else if (std.mem.eql(u8, day, "day2")) {
            run_step.dependOn(&run_day2.step);
        }
    }
}
