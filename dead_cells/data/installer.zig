const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_main_mo = @embedFile("./main.eu.mo");

const languages = [_]utils.nt_string{ "Gaztelera", "Frantsesa", "" };

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Dead Cells", "", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return languages;
}

pub fn install_translation(game_path: utils.string, selected_lang_index: usize) !?utils.InstallerResponse {

    const res_pak_path = try utils.concat(&.{ game_path, "/res.pak" });
    const res_pak_file = try std.fs.cwd().openFile(res_pak_path, .{ .mode = .read_write });
    defer res_pak_file.close();
    try res_pak_file.seekTo(4);

    var header_size_buff: [4]u8 = undefined;
    _ = res_pak_file.read(&header_size_buff) catch unreachable;
    const header_data_size = try read_u32(&header_size_buff, 0);

    const header_content = try std.heap.page_allocator.alloc(u8, header_data_size);
    try res_pak_file.seekTo(0);
    _ = res_pak_file.read(header_content) catch unreachable;

    const orig_mo = if (selected_lang_index == 0)
        "main.es-es.mo"
    else
        "main.fr.mo";
    
    if (std.mem.indexOf(u8, header_content, orig_mo)) |orig_index| {
        const lang_data_index = orig_index + orig_mo.len;
        const orig_position = try read_u32(header_content, lang_data_index + 1);
        const orig_size = try read_u32(header_content, lang_data_index + 5);
        
        if (eu_main_mo.len > orig_size) {
            return utils.InstallerResponse{
                .title = "Bertsio okerra",
                .body = "Instalatzen ari zaren itzulpena ez dator jokoaren bertsioarekin bat.",
            };
        }

        if (!try utils.backup_file(game_path, "res.pak")) {
            return utils.InstallerResponse{
                .title = "Instalazioa eginda",
                .body = "Instalazioa lehendik ere eginda dago.",
            };
        }

        const new_content = try std.heap.page_allocator.alloc(u8, orig_size);

        var ind: usize = 0;
        for (eu_main_mo[0..eu_main_mo.len]) |eu_byte| {
            new_content[ind] = eu_byte;
            ind += 1;
        }

        while (ind < orig_size) {
            new_content[ind] = 0;
            ind += 1;
        }

        try res_pak_file.seekTo(header_data_size + orig_position);
        _ = try res_pak_file.write(new_content);

        const lang = if (selected_lang_index == 0)
            "Español"
        else
            "Français";

        try change_lang_name(game_path, "deadcells.exe", lang);
        try change_lang_name(game_path, "deadcells_gl.exe", lang);
    }

    return null;
}

fn change_lang_name(game_path: utils.string, exe_file_name: utils.string, lang: utils.nt_string) !void {

    std.debug.print("[{s}] hizkuntza izena aldatzen [{s}] fitxategian.\n", .{lang, exe_file_name});
    if (!try utils.backup_file(game_path, exe_file_name)) {
        std.debug.print("Lehendik badago [{s}] fitxategiaren backup bat. Ez da aldaketarik eginen.\n", .{exe_file_name});
        return;
    }

    const exe_dir =  try std.fs.cwd().openDir(game_path, .{});
    const exe_file = try exe_dir.openFile(exe_file_name, .{ .mode = .read_write });
    defer exe_file.close();

    const metadata = try exe_file.metadata();
    const file_size = metadata.size();

    try exe_file.seekTo(0);
    const content_orig = try exe_file.readToEndAlloc(std.heap.page_allocator, file_size);
    const eus_lang = "Euskara";
    const hutsune_byte = 32;
    if (std.mem.indexOf(u8, content_orig, lang)) |lang_index| {
        std.debug.print("index: {d}\n", .{lang_index});
        
        var ind: usize = lang_index;
        for (eus_lang[0..eus_lang.len]) |eu_byte| {
            content_orig[ind] = eu_byte;
            ind += 1;
        }
        const lang_end = lang_index + lang.len;
        while (ind < lang_end) {
            content_orig[ind] = hutsune_byte;
            ind += 1;
        }
        
        try exe_file.seekTo(0);
        _ = try exe_file.write(content_orig);
    }
}

fn read_u32(content: []u8, start_index: usize) !u32 {
    const buff = [_]u8{ content[start_index], content[start_index + 1], content[start_index + 2], content[start_index + 3] };
    return std.mem.readInt(u32, &buff, .little);
}