const std = @import("std");
const utils = @import("utils");

pub var embedded_files = std.StringHashMap([]const u8).init(std.heap.page_allocator);

pub fn get_game_names() [5]utils.string {
    return [_]utils.string{ "Cave Story", "Cave Story+", "cavestory", "", "" };
}

pub fn install_translation(game_path: utils.string) !void {
    inline for (comptime_file_paths) |path| {
        const basque_path = "basque/" ++ path;
        const content = @embedFile(basque_path);
        try embedded_files.put(basque_path, content);
    }

    const lang_path = utils.look_for_dir(game_path, "lang") catch "";

    const lang_dir = try std.fs.openDirAbsolute(lang_path, std.fs.Dir.OpenDirOptions{});
    try lang_dir.makePath("basque/Stage");

    var w_file_path: utils.string = undefined;
    var w_file: std.fs.File = undefined;
    var iterator = embedded_files.iterator();

    while (iterator.next()) |entry| {
        w_file_path = try utils.concat(&.{ lang_path, "/", entry.key_ptr.* });
        w_file = try std.fs.cwd().createFile(w_file_path, .{});
        _ = try w_file.write(entry.value_ptr.*);
        w_file.close();
    }
}

pub const comptime_file_paths = [_][]const u8{
    "Stage/0.tsc",
    "Stage/Almond.tsc",
    "Stage/Ballo1.tsc",
    "Stage/Ballo2.tsc",
    "Stage/Barr.tsc",
    "Stage/Blcny1.tsc",
    "Stage/Blcny2.tsc",
    "Stage/Cave.tsc",
    "Stage/Cemet.tsc",
    "Stage/Cent.tsc",
    "Stage/CentW.tsc",
    "Stage/Chako.tsc",
    "Stage/Clock.tsc",
    "Stage/Comu.tsc",
    "Stage/Cthu2.tsc",
    "Stage/Cthu.tsc",
    "Stage/CurlyS.tsc",
    "Stage/Curly.tsc",
    "Stage/Dark.tsc",
    "Stage/Drain.tsc",
    "Stage/e_Blcn.tsc",
    "Stage/e_Ceme.tsc",
    "Stage/EgEnd1.tsc",
    "Stage/EgEnd2.tsc",
    "Stage/Egg1.tsc",
    "Stage/Egg6.tsc",
    "Stage/EggR2.tsc",
    "Stage/EggR.tsc",
    "Stage/Eggs2.tsc",
    "Stage/Eggs.tsc",
    "Stage/EggX2.tsc",
    "Stage/EggX.tsc",
    "Stage/e_Jenk.tsc",
    "Stage/e_Labo.tsc",
    "Stage/e_Malc.tsc",
    "Stage/e_Maze.tsc",
    "Stage/e_Sky.tsc",
    "Stage/Fall.tsc",
    "Stage/Frog.tsc",
    "Stage/Gard.tsc",
    "Stage/Hell1.tsc",
    "Stage/Hell2.tsc",
    "Stage/Hell3.tsc",
    "Stage/Hell42.tsc",
    "Stage/Hell4.tsc",
    "Stage/Island.tsc",
    "Stage/Itoh.tsc",
    "Stage/Jail1.tsc",
    "Stage/Jail2.tsc",
    "Stage/Jenka1.tsc",
    "Stage/Jenka2.tsc",
    "Stage/Kings.tsc",
    "Stage/Little.tsc",
    "Stage/Lounge.tsc",
    "Stage/Malco.tsc",
    "Stage/Mapi.tsc",
    "Stage/MazeA.tsc",
    "Stage/MazeB.tsc",
    "Stage/MazeD.tsc",
    "Stage/MazeH.tsc",
    "Stage/MazeI.tsc",
    "Stage/MazeM.tsc",
    "Stage/MazeO.tsc",
    "Stage/MazeS.tsc",
    "Stage/MazeW.tsc",
    "Stage/MiBox.tsc",
    "Stage/Mimi.tsc",
    "Stage/Momo.tsc",
    "Stage/Oside.tsc",
    "Stage/Ostep.tsc",
    "Stage/Pens1.tsc",
    "Stage/Pens2.tsc",
    "Stage/Pixel.tsc",
    "Stage/Plant.tsc",
    "Stage/Pole.tsc",
    "Stage/Pool.tsc",
    "Stage/Prefa1.tsc",
    "Stage/Prefa2.tsc",
    "Stage/Priso1.tsc",
    "Stage/Priso2.tsc",
    "Stage/Ring1.tsc",
    "Stage/Ring2.tsc",
    "Stage/Ring3.tsc",
    "Stage/River.tsc",
    "Stage/SandE.tsc",
    "Stage/Sand.tsc",
    "Stage/Santa.tsc",
    "Stage/Shelt.tsc",
    "Stage/Start.tsc",
    "Stage/Statue.tsc",
    "Stage/Stream.tsc",
    "Stage/WeedB.tsc",
    "Stage/WeedD.tsc",
    "Stage/WeedS.tsc",
    "Stage/Weed.tsc",
    "ArmsItem.tsc",
    "Caret.pbm",
    "Head.tsc",
    "Loading.pbm",
    "metadata",
    "README.md",
    "StageSelect.tsc",
    "system.json",
    "TextBox.pbm",
    "Title.pbm",
};
