const std = @import("std");
const utils = @import("utils");
const eu_txt = @embedFile("./LANG_Euskara.yarn_lines.csv");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "A short hike", "a short hike", "A Short Hike", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "AShortHike_Data") catch "";

    const txt_path = try utils.concat(&.{ content_path, "/LANG_Euskara.yarn_lines.csv" });

    std.debug.print("[{s}] fitxategia kopiatzen...\n", .{txt_path});
    const file_txt = try std.fs.cwd().createFile(txt_path, .{});

    defer file_txt.close();

    _ = try file_txt.write(eu_txt);

    return null;
}
