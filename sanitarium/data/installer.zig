const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const res000 = @embedFile("./RES.000");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Sanitarium", "sanitarium", "", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const res_path = utils.look_for_file(game_path, "RES.000") catch "";

    if (std.mem.eql(u8, res_path, "")) {
        return error.FileNotFound;
    }

    const backup_res_path = try utils.concat(&.{ res_path, "_backup" });
    if (std.fs.accessAbsolute(backup_res_path, std.fs.File.OpenFlags{})) {
        std.debug.print("Lehendik badago RES.000-ren backup bat.\n", .{});
    } else |_| {
        std.debug.print("RES.000 fitxategiaren backup bat sortzen.\n", .{});
        const data_dir_path = std.fs.path.dirname(res_path) orelse "./";
        const dir = try std.fs.openDirAbsolute(data_dir_path, std.fs.Dir.OpenDirOptions{});

        try dir.copyFile("RES.000", dir, backup_res_path, std.fs.Dir.CopyFileOptions{});
    }

    const updated_res_file = try std.fs.cwd().createFile(res_path, .{});
    defer updated_res_file.close();
    _ = try updated_res_file.write(res000);

    return null;
}
