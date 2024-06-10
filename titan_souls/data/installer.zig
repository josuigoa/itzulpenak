const std = @import("std");
const utils = @import("utils");
const credits_txt = @embedFile("./credits.txt");
const gametext_xml = @embedFile("./gametext.xml");
const gamepad_png = @embedFile("./gamepad.png");

const gametext_xml_name = "gametext.xml";
const credits_txt_name = "credits.txt";
const gamepad_png_name = "gamepad.png";

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Titan Souls", "titan souls", "Titan souls", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    try replace_file(game_path, gametext_xml_name);
    try replace_file(game_path, credits_txt_name);
    try replace_file(game_path, gamepad_png_name);

    return null;
}

fn replace_file(game_path: utils.string, file_name: utils.string) !void {
    const file_path = utils.look_for_file(game_path, file_name) catch "";

    if (std.mem.eql(u8, file_path, "")) {
        return error.FileNotFound;
    }

    const backup_file_path = try utils.concat(&.{ file_path, "_backup" });
    if (std.fs.accessAbsolute(backup_file_path, std.fs.File.OpenFlags{})) {
        std.debug.print("Lehendik badago [{s}]-ren backup bat.\n", .{file_name});
    } else |_| {
        std.debug.print("[{s}] fitxategiaren backup bat sortzen.\n", .{file_name});
        const data_dir_path = std.fs.path.dirname(file_path) orelse "./";
        const dir = try std.fs.openDirAbsolute(data_dir_path, std.fs.Dir.OpenDirOptions{});

        try dir.copyFile(file_name, dir, backup_file_path, std.fs.Dir.CopyFileOptions{});
    }

    const updated_res_file = try std.fs.cwd().createFile(file_path, .{});
    defer updated_res_file.close();

    const file_content = if (std.mem.eql(u8, file_name, gametext_xml_name)) gametext_xml else if (std.mem.eql(u8, file_name, credits_txt_name)) credits_txt else gamepad_png;
    _ = try updated_res_file.write(file_content);
}
