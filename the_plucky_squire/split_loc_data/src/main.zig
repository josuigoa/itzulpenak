const std = @import("std");

const footer_ind = 133725;

pub fn main() !void {
    try split_loc("en");
    try split_loc("fr");
    try split_loc("es");

    const en_pak = try std.fs.cwd().openFile("/home/josu/git/itzulpenak/the_plucky_squire/loc/en_eu.pak", .{});
    defer en_pak.close();
    try en_pak.seekTo(0);
    const metadata = try en_pak.metadata();
    const file_size = metadata.size();
    const content_orig = try en_pak.readToEndAlloc(std.heap.page_allocator, file_size);

    const eu_itzulpena = try std.fs.cwd().createFile("/home/josu/git/itzulpenak/the_plucky_squire/data/eu_itzulpena.dat", .{});
    _ = try eu_itzulpena.write(content_orig[0..footer_ind]);
    eu_itzulpena.close();
}

fn split_loc(lang: string) !void {
    const orig_path = try concat(&.{ "/home/josu/git/itzulpenak/the_plucky_squire/loc/", lang, "_eu.pak" });
    const extract_path = try concat(&.{ "/home/josu/git/itzulpenak/the_plucky_squire/data/", lang, "_footer.dat" });
    const pak = try std.fs.cwd().openFile(orig_path, .{});
    defer pak.close();
    try pak.seekTo(0);
    const metadata = try pak.metadata();
    const file_size = metadata.size();
    const content_orig = try pak.readToEndAlloc(std.heap.page_allocator, file_size);

    const footer = try std.fs.cwd().createFile(extract_path, .{});
    _ = try footer.write(content_orig[footer_ind..content_orig.len]);
    footer.close();
}

pub const string = []const u8;
pub fn concat(slices: []const string) !string {
    return try std.mem.concat(
        std.heap.page_allocator,
        u8,
        slices,
    );
}
