const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const musika_content = @embedFile("./musika.txt");
const i2Lang_eu = @embedFile("./I2Languages_eu_es.dat");
const i2Lang_orig = @embedFile("./I2Languages_orig.dat");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Ape Out", "", "", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "ApeOut_Data") catch "";

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

    const resources_backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ resources_assets_path, std.time.timestamp() }) catch "format failed";
    const resources_backup_file = try std.fs.cwd().createFile(resources_backup_path, .{});
    _ = try resources_backup_file.write(content_orig);
    resources_backup_file.close();

    if (std.mem.indexOf(u8, content_orig, "I2Languages")) |i2Lang_index| {
        const new_content = try std.heap.page_allocator.alloc(u8, file_size);

        var ind: usize = 0;
        for (content_orig[0..i2Lang_index]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        for (i2Lang_eu) |eu_byte| {
            new_content[ind] = eu_byte;
            ind += 1;
        }

        while (ind < i2Lang_index + i2Lang_orig.len - 3) {
            new_content[ind] = 0;
            ind += 1;
        }

        for (content_orig[i2Lang_index + i2Lang_orig.len - 3 ..]) |orig_byte| {
            new_content[ind] = orig_byte;
            ind += 1;
        }

        try resources_assets_file.seekTo(0);
        _ = try resources_assets_file.write(new_content);

        try update_level2(content_path);

        const musika_path = try utils.concat(&.{ game_path, "/musika.txt" });
        const musika_file = try std.fs.cwd().createFile(musika_path, .{});
        _ = try musika_file.write(musika_content);
        musika_file.close();
    } else {
        return utils.InstallerResponse{
            .title = "Ez da euskaratu",
            .body = "[resources.assets] fitxategian ez da [I2Languages] katerik aurkitu.",
        };
    }

    return null;
}

fn update_level2(content_path: utils.string) !void {
    const level2_path = try utils.concat(&.{ content_path, "/level2" });
    const level2_file = try std.fs.cwd().openFile(level2_path, .{ .mode = .read_write });
    defer level2_file.close();

    const metadata = try level2_file.metadata();
    const file_size = metadata.size();

    try level2_file.seekTo(0);
    const content_orig = try level2_file.readToEndAlloc(std.heap.page_allocator, file_size);
    const level2_backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ level2_path, std.time.timestamp() }) catch "format failed";
    const level2_backup_file = try std.fs.cwd().createFile(level2_backup_path, .{});
    _ = try level2_backup_file.write(content_orig);
    level2_backup_file.close();

    var start_ind: usize = 1317484;
    content_orig[start_ind] = 5;
    start_ind += 4;
    content_orig[start_ind] = 'P';
    content_orig[start_ind + 1] = 'u';
    content_orig[start_ind + 2] = 'n';
    content_orig[start_ind + 3] = 't';
    content_orig[start_ind + 4] = 'u';
    content_orig[start_ind + 5] = 0;
    content_orig[start_ind + 6] = 0;

    try level2_file.seekTo(0);
    _ = try level2_file.write(content_orig);
}
