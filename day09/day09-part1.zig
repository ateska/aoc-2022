const std = @import("std");
const print = @import("std").debug.print;

const Pos = struct {
	x: i64,
	y: i64,
};

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var hx: i64 = 0;
	var hy: i64 = 0;
	var tx: i64 = 0;
	var ty: i64 = 0;
	var visited = std.AutoHashMap(Pos, u64).init(std.heap.page_allocator);

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const dir: u8 = line[0];
		var steps = try std.fmt.parseUnsigned(u64, line[2..line.len], 10);

		while (steps > 0) : (steps -= 1) {
			try visited.put(Pos {.x=tx, .y=ty}, 0);

			var dx: i64 = 0;
			var dy: i64 = 0;
			switch (dir) {
				'U' => {dy = -1;},
				'D' => {dy = 1;},
				'L' => {dx = -1;},
				'R' => {dx = 1;},
				else => {
					print("Unknown direction '{c}'\n", .{dir});
					return error.InvalidChar;
				}
			}

			hx += dx;
			hy += dy;

			const dist_sq = ((hx - tx)*(hx - tx)) + ((hy - ty)*(hy - ty));
			if (dist_sq <= 2) {
				// The tail is in the contact with the head
				continue;
			}
			if ((dist_sq == 5) or (dist_sq == 4)) {
				var mx = hx - tx;
				if (mx > 1) { mx = 1; }
				if (mx < -1) { mx = -1; }

				var my = hy - ty;
				if (my > 1) { my = 1; }
				if (my < -1) { my = -1; }

				tx += mx;
				ty += my;

				continue;
			}

			print("???> {d} {d}x{d} {d}x{d}\n", .{dist_sq, hx, hy, tx, ty});
			return error.InvalidChar;
		}
	}

	print("Result: {d}\n", .{visited.count()});
}
