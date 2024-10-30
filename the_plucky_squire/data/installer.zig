const std = @import("std");
const utils = @import("utils");
const builtin = @import("builtin");
const eu_itzulpena = @embedFile("./eu_itzulpena.dat");
const es_footer = @embedFile("./es_footer.dat");
const fr_footer = @embedFile("./fr_footer.dat");
const en_footer = @embedFile("./en_footer.dat");

const languages = [_]utils.nt_string{ "Ingelesa", "Gaztelera", "Frantsesa" };

pub fn comptime_checks() void {}

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "The Plucky Squire", "", "", "", "" };
}

pub fn get_languages() ?[3]utils.nt_string {
    return languages;
}

pub fn install_translation(game_path: utils.string, selected_lang_index: usize) !?utils.InstallerResponse {
    const content_path = utils.look_for_dir(game_path, "Paks") catch "";

    const mod_file_path = try utils.concat(&.{ content_path, "/Storybook-WindowsNoEditor_p.pak" });
    if (std.fs.accessAbsolute(mod_file_path, std.fs.File.OpenFlags{})) {
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = "Dagoeneko euskarazko partxea instalatuta dago. Ez da aldaketarik aplikatu.",
        };
    } else |_| {
        const footer = if (selected_lang_index == 0)
            en_footer
        else if (selected_lang_index == 1)
            es_footer
        else
            fr_footer;
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

        const response_body = try utils.concat(&.{ "[", languages[selected_lang_index], "] ordezkatu da euskarazko itzulpena instalatzeko." });
        return utils.InstallerResponse{
            .title = "Euskaratuta",
            .body = response_body[0.. :0],
        };
    }
}
