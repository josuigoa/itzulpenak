const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_data = @embedFile("./eu_data.dat");

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Hidden Folks", "HiddenFolks", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return null;
}

pub fn install_translation(game_path: utils.string, _: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Hidden Folks_Data") catch "";

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

    if (std.mem.indexOf(u8, content_orig, "I2Languages")) |i2Lang_index| {
        const new_content = try std.heap.page_allocator.alloc(u8, file_size);

        var ind: usize = 0;
        for (content_orig[0..i2Lang_index]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        for (eu_data) |eu_byte| {
            new_content[ind] = eu_byte;
            ind += 1;
        }

        const orig_len = 0x151acb - i2Lang_index;

        while (ind < i2Lang_index + orig_len - 3) {
            new_content[ind] = 0;
            ind += 1;
        }

        for (content_orig[i2Lang_index + orig_len - 3 ..]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        try resources_assets_file.seekTo(0);
        _ = try resources_assets_file.write(new_content);

        try update_level_32_33(content_path);
    } else {
        return utils.InstallerResponse{
            .title = "Ez da euskaratu",
            .body = "[resources.assets] fitxategian ez da [I2Languages] katerik aurkitu.",
        };
    }

    return utils.InstallerResponse{
        .title = "Euskaratuta",
        .body = "Euskarazko itzulpena ongi instalatu da.",
    };
}

fn update_level_32_33(content_path: utils.string) !void {
    const level32_path = try utils.concat(&.{ content_path, "/level32" });
    const level33_path = try utils.concat(&.{ content_path, "/level33" });
    try update_level(level32_path, 0x27458);
    try update_level(level33_path, 0x3be10);
}

fn update_level(level_path: utils.string, start_ind: usize) !void {
    const level_file = try std.fs.cwd().openFile(level_path, .{ .mode = .read_write });
    defer level_file.close();

    const metadata = try level_file.metadata();
    const file_size = metadata.size();

    try level_file.seekTo(0);
    const content_orig = try level_file.readToEndAlloc(std.heap.page_allocator, file_size);
    try backup_file_content(level_path, content_orig);

    var ind: usize = 0;
    for ("Euskara ") |eu_byte| {
        content_orig[start_ind + ind] = eu_byte;
        ind += 1;
    }

    try level_file.seekTo(0);
    _ = try level_file.write(content_orig);
}

fn backup_file_content(file_path: utils.string, content_orig: []u8) !void {
    const backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ file_path, std.time.timestamp() }) catch "format failed";
    const backup_file = try std.fs.cwd().createFile(backup_path, .{});
    _ = try backup_file.write(content_orig);
    backup_file.close();
}
