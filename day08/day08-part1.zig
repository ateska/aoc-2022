const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var trees: [99][99]i16 = undefined;
	var visible: [99][99]bool = undefined;

	var buf: [1024]u8 = undefined;
	var line_counter: u64 = 0;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		for (line) |tree, i| {
			var x: u8 = tree - '0';
			trees[line_counter][i] = @as(i16, x);
			visible[line_counter][i] = false;
		}
		line_counter += 1;
	}

	var x: u64 = undefined;
	var y: u64 = undefined;
	
	// From left
	y = 0;
	while (y < 99) : (y += 1) {
		var mh: i16 = -1;
		x = 0;
		while (x < 99) : (x += 1) {
			if (mh < trees[y][x]) {
				visible[y][x] = true;
				mh = trees[y][x];
			}
		}
	}

	// From right
	y = 0;
	while (y < 99) : (y += 1) {
		var mh: i16 = -1;
		x = 0;
		while (x < 99) : (x += 1) {
			print("> {d}\n", .{98-x});
			if (mh < trees[y][98-x]) {
				visible[y][98-x] = true;
				mh = trees[y][98-x];
			}
		}
	}

	// From top
	x = 0;
	while (x < 99) : (x += 1) {
		var mh: i16 = -1;
		y = 0;
		while (y < 99) : (y += 1) {
			if (mh < trees[y][x]) {
				visible[y][x] = true;
				mh = trees[y][x];
			}
		}
	}

	// From bottom
	x = 0;
	while (x < 99) : (x += 1) {
		var mh: i16 = -1;
		y = 0;
		while (y < 99) : (y += 1) {
			if (mh < trees[98-y][x]) {
				visible[98-y][x] = true;
				mh = trees[98-y][x];
			}
		}
	}



	// Count
	var viscnt: u64 = 0;
	var cnt: u64 = 0;
	y = 0;
	while (y < 99) : (y += 1) {
		x = 0;
		while (x < 99) : (x += 1) {
			if (visible[y][x]) {
				viscnt += 1;
				print("X", .{});
			} else {
				print(" ", .{});
			}
			cnt += 1;
		}
		print("\n", .{});
	}

	print("Result: {d} {d}\n", .{cnt, viscnt});
}
