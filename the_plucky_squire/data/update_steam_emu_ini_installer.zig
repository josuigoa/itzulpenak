const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_itzulpena = @embedFile("./eu_itzulpena.dat");
const footer = @embedFile("./en_footer.dat");

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "The Plucky Squire", "", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return null;
}

pub fn install_translation(game_path: utils.string, _: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Paks") catch "";

    const mod_file_path = try utils.concat(&.{ content_path, "/Storybook-WindowsNoEditor_p.pak" });
    if (std.fs.accessAbsolute(mod_file_path, std.fs.File.OpenFlags{})) {
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = "Dagoeneko euskarazko partxea instalatuta dago. Ez da aldaketarik aplikatu.",
        };
    } else |_| {
        const mod_content = try std.heap.page_allocator.alloc(u8, eu_itzulpena.len + footer.len);

        var ind: usize = 0;
        for (eu_itzulpena) |eu_byte| {
            mod_content[ind] = eu_byte;
            ind += 1;
        }
        for (footer) |footer_byte| {
            mod_content[ind] = footer_byte;
            ind += 1;
        }

        const mod_file = try std.fs.cwd().createFile(mod_file_path, .{});
        defer mod_file.close();
        _ = try mod_file.write(mod_content);

        update_steam_emu_ini(game_path);

        return null;
    }
}

fn update_steam_emu_ini(game_path: utils.string) !void {
    const content_path = utils.look_for_dir(game_path, "Steamv157") catch "";
    const file_path = try utils.concat(&.{ content_path, "/steam_emu.ini" });
    const file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_write });
    defer file.close();
}
