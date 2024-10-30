const std = @import("std");

const offset = 57517294;
const size = 161506;

pub fn main() !void {
    const pak_1_file = try std.fs.cwd().openFile("/home/josu/git/itzulpenak/the_plucky_squire/loc/es_eu.pak", .{ .mode = .read_write });
    defer pak_1_file.close();
    const pak_2_file = try std.fs.cwd().openFile("/home/josu/git/itzulpenak/the_plucky_squire/loc/fr_eu.pak", .{ .mode = .read_write });
    defer pak_2_file.close();

    const metadata_1 = try pak_1_file.metadata();
    const filesize_1 = metadata_1.size();
    const metadata_2 = try pak_2_file.metadata();
    const filesize_2 = metadata_2.size();

    const content_1 = try pak_1_file.readToEndAlloc(std.heap.page_allocator, filesize_1);
    const content_2 = try pak_2_file.readToEndAlloc(std.heap.page_allocator, filesize_2);

    var i: usize = 0;
    var ob = content_1[i];
    var eb = content_2[i];

    while (ob == eb) {
        i += 1;
        ob = content_1[i];
        eb = content_2[i];
    }

    std.debug.print("{d}\n", .{i});
    // std.debug.print("orig: {d}\n", .{filesize_1});
    // std.debug.print("eu: {d}\n", .{filesize_2});
}
