const std = @import("std");

const offset = 57379434;
const size = 136205;

pub fn main() !void {
    const pak = try std.fs.cwd().openFile("/home/josu/git/itzulpenak/the_plucky_squire/berria.pak", .{});
    defer pak.close();
    try pak.seekTo(0);
    const metadata = try pak.metadata();
    const file_size = metadata.size();
    const content_orig = try pak.readToEndAlloc(std.heap.page_allocator, file_size);

    const backup_file = try std.fs.cwd().createFile("/home/josu/git/itzulpenak/the_plucky_squire/eu_itzulpena.dat", .{});
    _ = try backup_file.write(content_orig[offset .. offset + size]);
    backup_file.close();
}
