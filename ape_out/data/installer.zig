const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const i2Lang_eu = @embedFile("./I2Languages_eu_es.dat");
const i2Lang_orig = @embedFile("./I2Languages_orig.dat");

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Ape Out", "", "", "", "" };
}

pub fn install_translation(game_path: utils.string) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "ApeOut_Data") catch "";

    // user profile location}\AppData\LocalLow\Gabe Cuzzillo\ApeOut\Save.json

    const resources_assets_path = try utils.concat(&.{ content_path, "/resources.assets" });
    // const resources_assets_path = "/home/josu/git/itzulpenak/ape_out/steam/ApeOut_Data/resources.assets";
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

        // std.debug.print("ind {d}\n", .{ind});
        // std.debug.print("start_ind {d}\n", .{i2Lang_index + i2Lang_orig.len});
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
    } else {
        return utils.InstallerResponse{
            .title = "Ez da euskaratu",
            .body = "[resources.assets] fitxategian ez da [I2Languages] katerik aurkitu.",
        };
    }
    return null;
}
