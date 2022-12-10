const std = @import("std");
const print = @import("std").debug.print;

const Pos = struct {
	x: i64,
	y: i64,
};

fn printRope(minX: i64, minY: i64, maxX: i64, maxY: i64, rope: [10]Pos) !void {

	var x:i64 = undefined;

	print("+", .{});
	x = minX;
	while (x < maxX) {
		print("-", .{});
		x += 1;
	}
	print("+\n", .{});

	var y = minY;
	while (y < maxY) {

		print("|", .{});
		x = minX;
		while (x < maxX) {
			var ch: usize = 99;

			for (rope[0..rope.len]) |knot, i| {
				if ((knot.x == x) and (knot.y == y)) {
					if (ch > (i + 1)) {
						ch = (i + 1);
					}
				}
			}

			if (ch == 10) {
				print("T", .{});
			} else if (ch == 1) {
				print("H", .{});
			} else if (ch != 99) {
				print("{d}", .{ch});
			} else {
				print(" ", .{});
			}

			x += 1;
		}

		print("|\n", .{});
		y += 1;
	}

	print("+", .{});
	x = minX;
	while (x < maxX) {
		print("-", .{});
		x += 1;
	}
	print("+\n\n", .{});

}

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;


	var rope: [10]Pos = .{
		Pos {.x=0,.y=0}, // Head
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0},
		Pos {.x=0,.y=0}, // Tail
	};
	var visited = std.AutoHashMap(Pos, u64).init(std.heap.page_allocator);

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const dir: u8 = line[0];
		var steps = try std.fmt.parseUnsigned(u64, line[2..line.len], 10);
		print(">>> {c} {d}\n", .{dir, steps});

		while (steps > 0) : (steps -= 1) {
			try visited.put(rope[rope.len - 1], 0);

			// Move the head
			switch (dir) {
				'U' => {rope[0].y += -1;},
				'D' => {rope[0].y += 1;},
				'L' => {rope[0].x += -1;},
				'R' => {rope[0].x += 1;},
				else => {
					print("Unknown direction '{c}'\n", .{dir});
					return error.InvalidChar;
				}
			}

			// Move knots
			forloop: for (rope[1..rope.len]) |_, i| {

				const dist_sq = (rope[i].x - rope[i+1].x)*(rope[i].x - rope[i+1].x) + (rope[i].y - rope[i+1].y)*(rope[i].y - rope[i+1].y);
				if (dist_sq <= 2) {
					// The tail is in the contact with the head
					break :forloop;
				}

				// print("DIST: {d} {d}x{d} {d}x{d}\n", .{dist_sq, rope[i].x, rope[i].y, rope[i+1].x, rope[i+1].y});

				if ((dist_sq == 5) or (dist_sq == 4) or (dist_sq == 8)) {
					var mx = rope[i].x - rope[i+1].x;
					if (mx > 1) { mx = 1; }
					if (mx < -1) { mx = -1; }

					var my = rope[i].y - rope[i+1].y;
					if (my > 1) { my = 1; }
					if (my < -1) { my = -1; }

					rope[i+1].x += mx;
					rope[i+1].y += my;

					continue :forloop;
				}

				print("???> {d} {d}.-{d}. {d}x{d} {d}x{d}\n", .{dist_sq, i+1, i+2, rope[i].x, rope[i].y, rope[i+1].x, rope[i+1].y});
				return error.InvalidChar;
			}

			try printRope(-80,-30,80,30, rope);

		}

	}

	print("Result: {d}\n", .{visited.count()});
}
