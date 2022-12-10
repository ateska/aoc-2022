const std = @import("std");
const print = @import("std").debug.print;


const CPU = struct {
	pc: u64, // Cycle counter
	rx: i64, // Register X

	screen: [240]u8,

	pub fn init() CPU {
		var cpu = CPU {
			.pc = 0,
			.rx = 1,
			.screen = undefined,
		};
		var i: u64 = 0;
		while (i < cpu.screen.len) {
			cpu.screen[i] = ' ';
			i += 1;
		}
		return cpu;
	}

	pub fn tick(self: *CPU) void {
		const hpos = (self.pc % 40);
		
		// Draw
		if (((self.rx - 1) == hpos) or ((self.rx) == hpos) or ((self.rx + 1) == hpos)) {
			self.screen[self.pc] = '#';
		}

		self.pc += 1;
	}

	pub fn addx(self: *CPU, dx: i64) void {
		self.rx += dx;
	}

};

pub fn readInt(line: []u8) !i64  {
	var n: i64 = 0;
	var i: u64 = 0;
	if (line[0] == '-') {
		i += 1;
	}
	while (i < line.len) {
		const c: u8 = line[i];
		n = n * 10 + (c-'0');
		i += 1;
	}
	if (line[0] == '-') {
		n *= -1;
	}
	return n;
}

pub fn main() !void {

	var file = try std.fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [1024]u8 = undefined;

	var cpu: CPU = CPU.init(); 

	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (std.mem.eql(u8, line, "noop")) {
			cpu.tick(); // one cycle to complete
		}
		else if ((line.len > 5) and (std.mem.eql(u8, line[0..5], "addx "))) {
			cpu.tick();
			cpu.tick(); // two cycles to complete
			cpu.addx(try readInt(line[5..line.len]));
		}
		else {
			print("Invalid input: '{s}'\n", .{line});
			return;
		}
	}

	// Print the screen
	var i: u64 = 0;
	while (i < cpu.screen.len) {
		print("{c}", .{cpu.screen[i]});
		i += 1;
		if ((i % 40) == 0) {
			print("\n", .{});
		}
	}
}
