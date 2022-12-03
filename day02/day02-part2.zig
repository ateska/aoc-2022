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
				'X' => 0 + 3, // We need to lose -> scissors
				'Y' => 3 + 1, // We need to draw -> rock
				'Z' => 6 + 2, // We need to win -> paper
				else => {
					print("Unknown line A '{s}'\n", .{line});
					return error.InvalidChar;
				}
			},
			'B' => switch (line[2]) { // Opponent plays Paper
				'X' => 0 + 1, // We need to lose -> rock
				'Y' => 3 + 2, // We need to draw -> paper
				'Z' => 6 + 3, // We need to win -> scissors
				else => {
					print("Unknown line B '{s}'\n", .{line});
					return error.InvalidChar;
				}
			},
			'C' => switch (line[2]) { // Opponent plays Scissors
				'X' => 0 + 2, // We need to lose -> paper
				'Y' => 3 + 3, // We need to draw -> scissors
				'Z' => 6 + 1, // We need to win -> rock
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
