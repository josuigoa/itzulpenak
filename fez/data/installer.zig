const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const es_statictext = @embedFile("./es_statictext.xnb");
const es_gametext = @embedFile("./es_gametext.xnb");
const fr_statictext = @embedFile("./fr_statictext.xnb");
const fr_gametext = @embedFile("./fr_gametext.xnb");

const languages = [_]utils.nt_string{ "Gaztelera", "Frantsesa", "" };

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "FEZ", "Fez", "fez", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return languages;
}

pub fn install_translation(game_path: utils.string, selected_lang_index: usize) !?utils.InstallerResponse {

    const content_path = utils.look_for_dir(game_path, "Content") catch "";

    const eu_statictext = if (selected_lang_index == 0)
        es_statictext
    else
        fr_statictext;
    try patch_pak(content_path, "Essentials.pak", "statictext", eu_statictext);

    const eu_gametext = if (selected_lang_index == 0)
        es_gametext
    else
        fr_gametext;
    try patch_pak(content_path, "Other.pak", "gametext", eu_gametext);
    try patch_pak(content_path, "Updates.pak", "gametext", eu_gametext);
    
    const response_body = try utils.concat(&.{ "[", languages[selected_lang_index], "] ordezkatu da euskarazko itzulpena instalatzeko." });
    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = response_body[0.. :0],
    };
}

fn patch_pak(content_path: utils.string, pak_name: utils.string, inner_filename: utils.string, eu_patch: [:0]const u8) !void {
    const pak_path = try utils.concat(&.{ content_path, "/", pak_name });
    const pak_file = try std.fs.cwd().openFile(pak_path, .{ .mode = .read_write });
    defer pak_file.close();

    const metadata = try pak_file.metadata();
    const file_size = metadata.size();

    try pak_file.seekTo(0);
    const pak_content_orig = try pak_file.readToEndAlloc(std.heap.page_allocator, file_size);

    _ = try utils.backup_file(content_path, pak_name);

    if (std.mem.indexOf(u8, pak_content_orig, inner_filename)) |statictext_index| {
        const length_index = statictext_index + inner_filename.len;
        const orig_length = try read_u32(pak_content_orig, length_index);
        std.debug.print("{s} aurkitu da {s} fitxategian.\n", .{inner_filename, pak_name});

        const new_content = try std.heap.page_allocator.alloc(u8, file_size - orig_length + eu_patch.len);

        var ind: usize = 0;
        for (pak_content_orig[0..length_index]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        const patch_length = write_usize(eu_patch.len);
        for (patch_length) |p_len| {
            new_content[ind] = p_len;
            ind += 1;
        }

        for (eu_patch) |eu_byte| {
            new_content[ind] = eu_byte;
            ind += 1;
        }

        const pak_tail = pak_content_orig[length_index + 4 + orig_length..pak_content_orig.len];
        for (pak_tail[0..pak_tail.len]) |tail_byte| {
            new_content[ind] = tail_byte;
            ind += 1;
        }

        try pak_file.seekTo(0);
        _ = try pak_file.write(new_content);
    }
}

fn read_u32(content: []u8, start_index: usize) !u32 {
    const buff = [_]u8{ content[start_index], content[start_index + 1], content[start_index + 2], content[start_index + 3] };
    return std.mem.readInt(u32, &buff, .little);
}

fn write_usize(size: usize) [4]u8 {
    return write_u32(@as(u32, @intCast(size)));
}

fn write_u32(int32: u32) [4]u8 {
    var buff = [_]u8{0, 0, 0, 0};
    std.mem.writeInt(u32, &buff, int32, .little);
    return buff;
}