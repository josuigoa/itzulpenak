const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const en_eu_itzulpena = @embedFile("./en_eu_itzulpena.pak");

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "The Plucky Squire", "Storybook", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return null;
}

pub fn install_translation(game_path: utils.string, _: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Paks") catch "";

    const mod_file_path = try utils.concat(&.{ content_path, "/Storybook-WindowsNoEditor_p.pak" });
    const mod_file = try std.fs.cwd().createFile(mod_file_path, .{});
    defer mod_file.close();
    _ = try mod_file.write(en_eu_itzulpena);

    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = "ADI!! Jokoko ezarpenetan ez da Euskara agertuko, euskarazko testuak agertzeko English aukeratu beharko duzu.",
    };
}
