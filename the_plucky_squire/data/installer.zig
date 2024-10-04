const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_itzulpena = @embedFile("./eu_itzulpena.dat");

const es_orig_offset = 71599426;
const es_orig_size = 162216;
const fr_orig_offset = 71761827;
const fr_orig_size = 161508;

const languages = [_]utils.nt_string{ "Gaztelera", "Frantsesa", "" };

pub fn comptime_checks() void {
    if (eu_itzulpena.len > es_orig_size) {
        @compileError("Itzulpenaren fitxategia ezin da ES originala baino luzeagoa izan.");
    }
    if (eu_itzulpena.len > fr_orig_size) {
        @compileError("Itzulpenaren fitxategia ezin da FR originala baino luzeagoa izan.");
    }
}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "The Plucky Squire", "", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return languages;
}

pub fn install_translation(game_path: utils.string, selected_lang_index: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Paks") catch "";

    const pak_file_path = try utils.concat(&.{ content_path, "/Storybook-WindowsNoEditor.pak" });
    const pak_file = try std.fs.cwd().openFile(pak_file_path, .{ .mode = .read_write });
    defer pak_file.close();

    const metadata = try pak_file.metadata();
    const file_size = metadata.size();

    try pak_file.seekTo(0);
    const content_orig = try pak_file.readToEndAlloc(std.heap.page_allocator, file_size);

    if (std.mem.containsAtLeast(u8, content_orig, 1, "AZEN BEHIN")) {
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = "Dagoeneko euskarazko partxea instalatuta dago. Ez da aldaketarik aplikatu.",
        };
    }

    try backup_file_content(pak_file_path, content_orig);

    const new_content = try std.heap.page_allocator.alloc(u8, file_size);

    const orig_offset: usize = if (selected_lang_index == 0) es_orig_offset else fr_orig_offset;
    const orig_size: usize = if (selected_lang_index == 0) es_orig_size else fr_orig_size;

    var ind: usize = 0;
    for (content_orig[0..orig_offset]) |orig_byte| {
        new_content[ind] = orig_byte;
        ind += 1;
    }

    for (eu_itzulpena) |eu_byte| {
        new_content[ind] = eu_byte;
        ind += 1;
    }

    const next_item_index = orig_offset + orig_size;
    while (ind < next_item_index) {
        new_content[ind] = 0;
        ind += 1;
    }

    for (content_orig[next_item_index..]) |orig_byte| {
        new_content[ind] = orig_byte;
        ind += 1;
        if (ind == content_orig.len) {
            break;
        }
    }

    try pak_file.seekTo(0);
    _ = try pak_file.write(new_content);

    const response_body = try utils.concat(&.{ "[", languages[selected_lang_index], "] ordezkatu da euskarazko itzulpena instalatzeko." });
    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = response_body[0.. :0],
    };
}

fn backup_file_content(file_path: utils.string, content_orig: []u8) !void {
    const backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ file_path, std.time.timestamp() }) catch "format failed";
    const backup_file = try std.fs.cwd().createFile(backup_path, .{});
    _ = try backup_file.write(content_orig);
    backup_file.close();
}
