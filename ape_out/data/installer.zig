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

    try backup_file_content(resources_assets_path, content_orig);

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

        try update_level1(content_path);
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

fn update_level1(content_path: utils.string) !void {
    const level1_path = try utils.concat(&.{ content_path, "/level1" });
    const level1_file = try std.fs.cwd().openFile(level1_path, .{ .mode = .read_write });
    defer level1_file.close();

    const metadata = try level1_file.metadata();
    const file_size = metadata.size();

    try level1_file.seekTo(0);
    const content_orig = try level1_file.readToEndAlloc(std.heap.page_allocator, file_size);
    try backup_file_content(level1_path, content_orig);

    try update_text(content_orig, "SIDE  A", "" ++ .{ 0, 0 }, "A ALDEA", "" ++ .{ 0, 0 });
    try update_text(content_orig, "SIDE  B", "" ++ .{ 0, 0 }, "B ALDEA", "" ++ .{ 0, 0 });
    try update_text(content_orig, "FACE A", "" ++ .{ 0, 0, 0, 0, 0, 0 }, "A ALDEA", "" ++ .{ 0, 0 });
    try update_text(content_orig, "FACE B", "" ++ .{ 0, 0, 0, 0, 0, 0 }, "B ALDEA", "" ++ .{ 0, 0 });
    try update_text(content_orig, "SEITE  A", "" ++ .{ 0, 0, 0, 0, 0, 0 }, "A  ALDEA", "" ++ .{ 0, 0 });
    try update_text(content_orig, "SEITE  B", "" ++ .{ 0, 0, 0, 0, 0, 0 }, "B  ALDEA", "" ++ .{ 0, 0 });

    try level1_file.seekTo(0);
    _ = try level1_file.write(content_orig);
}

fn update_level2(content_path: utils.string) !void {
    const level2_path = try utils.concat(&.{ content_path, "/level2" });
    const level2_file = try std.fs.cwd().openFile(level2_path, .{ .mode = .read_write });
    defer level2_file.close();

    const metadata = try level2_file.metadata();
    const file_size = metadata.size();

    try level2_file.seekTo(0);
    const content_orig = try level2_file.readToEndAlloc(std.heap.page_allocator, file_size);
    try backup_file_content(level2_path, content_orig);

    try update_text(content_orig, "Points", "" ++ .{ 0, 0, 0, 0, 0, 0, 0 }, "Puntu", "" ++ .{ 0, 0 });
    try update_text(content_orig, "E  N  D   O F   S I DE   A", "" ++ .{ 0, 0 }, "A K A B O    A    A L DE A", "" ++ .{ 0, 0 });
    try update_text(content_orig, "S I D E    B", "" ++ .{ 0, 0 }, "B   A L DE A", "" ++ .{ 0, 0 });
    try update_text(content_orig, "FLOOR", "" ++ .{ 0, 0, 0, 0, 0, 0 }, "PISUA:", "");
    try update_text(content_orig, "E  N  D   O F   S I D E   A", "" ++ .{ 0, 0 }, "A K A B O    A    A L D E A", "" ++ .{ 0, 0 });

    try level2_file.seekTo(0);
    _ = try level2_file.write(content_orig);
}

fn backup_file_content(file_path: utils.string, content_orig: []u8) !void {
    const backup_path = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{d}", .{ file_path, std.time.timestamp() }) catch "format failed";
    const backup_file = try std.fs.cwd().createFile(backup_path, .{});
    _ = try backup_file.write(content_orig);
    backup_file.close();
}

fn update_text(content_orig: []u8, comptime body: utils.string, comptime tail: utils.string, comptime new_body: utils.string, comptime new_tail: utils.string) !void {
    const header = .{ body.len, 0, 0, 0 };

    const text_bytes = header ++ body ++ tail;
    const count = std.mem.count(u8, content_orig, text_bytes);
    std.debug.print("{s}.count {d}\n", .{ body, count });

    for (0..count) |_| {
        if (std.mem.indexOf(u8, content_orig, text_bytes)) |found_index| {
            std.debug.print("{s}.ind {d}\n", .{ body, found_index });
            var orig_pos = found_index;
            const new_header = .{ new_body.len, 0, 0, 0 };
            const new_bytes = new_header ++ new_body ++ new_tail;
            for (new_bytes) |nb| {
                content_orig[orig_pos] = nb;
                orig_pos += 1;
            }
        } else {
            std.debug.print("{s} indexOf not found\n", .{body});
        }
    }
}
