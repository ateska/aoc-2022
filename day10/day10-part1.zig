const std = @import("std");
const print = @import("std").debug.print;


const CPU = struct {
	pc: i64, // Cycle counter
	rx: i64, // Register X

	sig20: i64,
	sig60: i64,
	sig100: i64,
	sig140: i64,
	sig180: i64,
	sig220: i64,

	pub fn init() CPU {
		return CPU {
			.pc = 0,
			.rx = 1,
			.sig20 = -1,
			.sig60 = -1,
			.sig100 = -1,
			.sig140 = -1,
			.sig180 = -1,
			.sig220 = -1,
		};
	}

	pub fn tick(self: *CPU) void {
		self.pc += 1;
		switch (self.pc) {
			20 => { self.sig20 = self.rx * self.pc; },
			60 => { self.sig60 = self.rx * self.pc; },
			100 => { self.sig100 = self.rx * self.pc; },
			140 => { self.sig140 = self.rx * self.pc; },
			180 => { self.sig180 = self.rx * self.pc; },
			220 => { self.sig220 = self.rx * self.pc; },
			else => {},
		}
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

	print("Result: {d}\n", .{cpu.sig20 + cpu.sig60 + cpu.sig100 + cpu.sig140 + cpu.sig180 + cpu.sig220});
}
