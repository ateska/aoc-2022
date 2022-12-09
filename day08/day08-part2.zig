const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var trees: [99][99]i16 = undefined;
	var score: [99][99]u64 = undefined;

	var buf: [1024]u8 = undefined;
	var line_counter: u64 = 0;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		for (line) |tree, i| {
			var x: u8 = tree - '0';
			trees[line_counter][i] = @as(i16, x);
			score[line_counter][i] = 0;
		}
		line_counter += 1;
	}

	var x: u64 = undefined;
	var y: u64 = undefined;
	var mh: i16 = undefined;
	
	y = 0;
	while (y < 99) : (y += 1)
	{
		
		x = 0;
		while (x < 99) : (x += 1)
		{

			// Go up
			var top: u64 = 0;
			mh = trees[y][x];
			while (y > top) {
				top += 1;
				if (mh > trees[y-top][x]) {
					continue;
				} else {
					break;
				}
			}

			// Go down
			var down: u64 = 0;
			mh = trees[y][x];
			while ((y+down) < 98) {
				down += 1;
				if (mh > trees[y+down][x]) {
					continue;
				} else {
					break;
				}
			}

			// Go left
			var left: u64 = 0;
			mh = trees[y][x];
			while (x > left) {
				left += 1;
				if (mh > trees[y][x-left]) {
					continue;
				} else {
					break;
				}
			}

			// Go right
			var right: u64 = 0;
			mh = trees[y][x];
			while ((x+right) < 98) {
				right += 1;
				if (mh > trees[y][x+right]) {
					continue;
				} else {
					break;
				}
			}

			score[y][x] = top * down * left * right;
		}
	}

	// Count
	var max: u64 = 0;

	y = 0;
	while (y < 99) : (y += 1) {
		x = 0;
		while (x < 99) : (x += 1) {
			if (max < score[y][x]) {
				max = score[y][x];
			}
		}
	}

	print("Result: {d}\n", .{max});

}
