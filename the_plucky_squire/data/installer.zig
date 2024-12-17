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

    try update_steam_emu_ini(game_path);

    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = "ADI!! Jokoko ezarpenetan ez da Euskara agertuko, euskarazko testuak agertzeko English aukeratu beharko duzu.",
    };
}

fn update_steam_emu_ini(game_path: utils.string) !void {
    const file_path = utils.look_for_file(game_path, "steam_emu.ini") catch "";
    const file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_write });
    defer file.close();

    const file_size = (try file.metadata()).size();

    const content_orig = try file.readToEndAlloc(std.heap.page_allocator, file_size);
    try backup_file_content(file_path, content_orig);

    if (std.mem.indexOf(u8, content_orig, "Language=")) |found_ind| {
        var new_content = try std.heap.page_allocator.alloc(u8, file_size + 10);
        const en_lang = "Language=english";
        var ind: usize = 0;
        var lang_ind = found_ind;

        for (content_orig[0..lang_ind]) |b| {
            new_content[ind] = b;
            ind += 1;
        }
        for (en_lang) |b| {
            new_content[ind] = b;
            ind += 1;
        }

        while (content_orig[lang_ind] != '\n') {
            lang_ind += 1;
        }

        for (content_orig[lang_ind..content_orig.len]) |b| {
            new_content[ind] = b;
            ind += 1;
        }

        try file.seekTo(0);
        _ = try file.write(new_content[0..ind]);
    }
}

fn backup_file_content(file_path: utils.string, content_orig: []u8) !void {
    const backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ file_path, std.time.timestamp() }) catch "format failed";
    const backup_file = try std.fs.cwd().createFile(backup_path, .{});
    _ = try backup_file.write(content_orig);
    backup_file.close();
}
