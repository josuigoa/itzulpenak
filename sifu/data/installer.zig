const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const es_eu = @embedFile("./es_eu_itzulpena.pak");
const fr_eu = @embedFile("./fr_eu_itzulpena.pak");
const sig = @embedFile("./itzulpena.sig");

const languages = [_]utils.nt_string{ "Gaztelera", "Frantsesa", "" };

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Sifu", "SIFU", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return languages;
}

pub fn install_translation(game_path: utils.string, selected_lang_index: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Paks") catch "";
    const itzulpena = if (selected_lang_index == 0)
        es_eu
    else
        fr_eu;

    const mod_file_path = try utils.concat(&.{ content_path, "/pakchunk0-WindowsNoEditor_euskaraz_P.pak" });
    const mod_file = try std.fs.cwd().createFile(mod_file_path, .{});
    defer mod_file.close();
    _ = try mod_file.write(itzulpena);

    const sig_file_path = try utils.concat(&.{ content_path, "/pakchunk0-WindowsNoEditor_euskaraz_P.sig" });
    const sig_file = try std.fs.cwd().createFile(sig_file_path, .{});
    defer sig_file.close();
    _ = try sig_file.write(sig);

    const response_body = try utils.concat(&.{ "[", languages[selected_lang_index], "] ordezkatu da euskarazko itzulpena instalatzeko." });
    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = response_body[0.. :0],
    };
}
