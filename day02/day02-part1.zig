const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var total_score:u64 = 0;

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		
		total_score += switch (line[0]) {
			'A' => switch (line[2]) { // Opponent plays Rock
				'X' => 3 + 1, // We play Rock - draw
				'Y' => 6 + 2, // We play Paper - win
				'Z' => 0 + 3, // We play Scisor - loss
				else => {
					print("Unknown line A '{s}'\n", .{line});
					return error.InvalidChar;
				}
			},
			'B' => switch (line[2]) { // Opponent plays Paper
				'X' => 0 + 1, // We play Rock - loss
				'Y' => 3 + 2, // We play Paper - draw
				'Z' => 6 + 3, // We play Scisor - win
				else => {
					print("Unknown line B '{s}'\n", .{line});
					return error.InvalidChar;
				}
			},
			'C' => switch (line[2]) { // Opponent plays Scissors
				'X' => 6 + 1, // We play Rock - win
				'Y' => 0 + 2, // We play Paper - loss
				'Z' => 3 + 3, // We play Scisor - draw
				else => {
					print("Unknown line C '{s}'\n", .{line});
					return error.InvalidChar;
				}
			},
			else => {
				print("Unknown line '{s}'\n", .{line});
				return error.InvalidChar;
			}
		};

	}

	print("Score: {d}\n", .{total_score});

}
