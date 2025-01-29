const std = @import("std");
const utils = @import("utils");
const eu_txt = @embedFile("./euskara.txt");
const eu_png = @embedFile("./euskara.png");

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Celeste", "celeste", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return null;
}

pub fn install_translation(game_path: utils.string, _: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Content") catch "";

    const dialog_path = try utils.concat(&.{ content_path, "/Dialog" });
    const txt_path = try utils.concat(&.{ dialog_path, "/euskara.txt" });
    const icon_path = try utils.concat(&.{ dialog_path, "/Icons/euskara.png" });

    std.debug.print("[{s}] fitxategia kopiatzen...\n", .{txt_path});
    const file_txt = try std.fs.cwd().createFile(txt_path, .{});
    std.debug.print("[{s}] fitxategia kopiatzen...\n", .{icon_path});
    const file_png = try std.fs.cwd().createFile(icon_path, .{});

    defer file_txt.close();
    defer file_png.close();

    _ = try file_txt.write(eu_txt);
    _ = try file_png.write(eu_png);

    return null;
}
