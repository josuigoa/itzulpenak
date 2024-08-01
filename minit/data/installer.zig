const std = @import("std");
const utils = @import("utils");
const eu_txt = @embedFile("./minit_loc.csv");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "minit", "MINIT", "Minit", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const loc_path = utils.look_for_file(game_path, "minit_loc.csv") catch "";

    std.debug.print("[{s}] fitxategia kopiatzen...\n", .{loc_path});
    const file_txt = try std.fs.cwd().createFile(loc_path, .{});

    defer file_txt.close();

    _ = try file_txt.write(eu_txt);

    return null;
}
