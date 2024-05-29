const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_locale_originalGame = @embedFile("./eu_Locale_OriginalGame-resources.assets-670.csv");
const orig_locale_originalGame = @embedFile("./orig_Locale_OriginalGame-resources.assets-670.csv");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Figment", "", "", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Figment_Data") catch "";

    const resources_assets_path = try utils.concat(&.{ content_path, "/resources.assets" });
    const resources_assets_file = try std.fs.cwd().openFile(resources_assets_path, .{ .mode = .read_write });
    defer resources_assets_file.close();

    const metadata = try resources_assets_file.metadata();
    const file_size = metadata.size();

    try resources_assets_file.seekTo(0);
    const content_orig = try resources_assets_file.readToEndAlloc(std.heap.page_allocator, file_size);

    if (std.mem.containsAtLeast(u8, content_orig, 1, "Euskara")) {
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = "Dagoeneko euskarazko partxea instalatuta dago. Ez da aldaketarik aplikatu.",
        };
    }

    try backup_file_content(resources_assets_path, content_orig);

    if (std.mem.lastIndexOf(u8, content_orig, "Locale_OriginalGame")) |locale_originalgame_index| {
        const new_content = try std.heap.page_allocator.alloc(u8, file_size);

        const new_locale_originalgame_index = locale_originalgame_index + 24;

        var ind: usize = 0;
        for (content_orig[0..new_locale_originalgame_index]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        for (eu_locale_originalGame) |eu_byte| {
            new_content[ind] = eu_byte;
            ind += 1;
        }

        while (ind < new_locale_originalgame_index + orig_locale_originalGame.len) {
            new_content[ind] = 0;
            ind += 1;
        }

        for (content_orig[new_locale_originalgame_index + orig_locale_originalGame.len ..]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        try resources_assets_file.seekTo(0);
        _ = try resources_assets_file.write(new_content);
    } else {
        return utils.InstallerResponse{
            .title = "Ez da euskaratu",
            .body = "[resources.assets] fitxategian ez da [Locale_OriginalGame] katerik aurkitu.",
        };
    }

    return null;
}

fn backup_file_content(file_path: utils.string, content_orig: []u8) !void {
    const backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ file_path, std.time.timestamp() }) catch "format failed";
    const backup_file = try std.fs.cwd().createFile(backup_path, .{});
    _ = try backup_file.write(content_orig);
    backup_file.close();
}
