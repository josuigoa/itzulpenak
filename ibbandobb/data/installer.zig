const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const euLocalization = @embedFile("./euLocalization.txt");

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "ibbandobb", "", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return null;
}

pub fn install_translation(game_path: utils.string, _: usize) !?utils.InstallerResponse {
    const loc_path = utils.look_for_dir(game_path, "localization") catch "";

    if (std.mem.eql(u8, loc_path, "")) {
        return error.FileNotFound;
    }

    const bertzeak_loc_path = try utils.concat(&.{ loc_path, "/bertzeak" });

    if (std.fs.openDirAbsolute(bertzeak_loc_path, std.fs.Dir.OpenDirOptions{})) |_| {
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = "Dagoeneko euskarazko partxea instalatuta dago. Ez da aldaketarik aplikatu.",
        };
    } else |_| {}

    const loc_dir = try (std.fs.openDirAbsolute(loc_path, std.fs.Dir.OpenDirOptions{ .iterate = true }));
    try loc_dir.makePath("bertzeak");
    const bertzeak_loc_dir = try (std.fs.openDirAbsolute(bertzeak_loc_path, std.fs.Dir.OpenDirOptions{}));

    var iter = loc_dir.iterate();
    while (true) {
        const entry = try iter.next();
        if (entry == null) {
            break;
        }

        switch (entry.?.kind) {
            .file => {
                if (std.mem.endsWith(u8, entry.?.name, ".txt")) {
                    try loc_dir.copyFile(entry.?.name, bertzeak_loc_dir, entry.?.name, std.fs.Dir.CopyFileOptions{});
                    try loc_dir.deleteFile(entry.?.name);
                } else {}
            },
            else => {},
        }
        std.debug.print("[{s}] fitxategia kopiatzen.\n", .{entry.?.name});
    }

    const new_en_loc_path = try utils.concat(&.{ loc_path, "/enLocalization.txt" });
    const new_en_loc = try std.fs.cwd().createFile(new_en_loc_path, .{});
    defer new_en_loc.close();
    _ = try new_en_loc.write(euLocalization);

    return null;
}
