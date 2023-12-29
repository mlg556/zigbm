const std = @import("std");

const STACK_CAPACITY = 1024;

const Word = i64;

const Inst_Type = enum { PUSH, PLUS };
const Inst = struct { type: Inst_Type, operand: Word };

const Err = error{
    STACK_OVERFLOW,
    STACK_UNDERFLOW,
};

const Stack = struct {
    stack: [STACK_CAPACITY]Word = undefined,
    stack_size: usize = 0,

    pub fn push(self: *Stack, operand: Word) !void {
        if (self.stack_size >= STACK_CAPACITY)
            return Err.STACK_OVERFLOW;

        self.stack[self.stack_size] = operand;
        self.stack_size += 1;
    }

    pub fn pop(self: *Stack) !Word {
        if (self.stack_size == 0)
            return Err.STACK_UNDERFLOW;

        self.stack_size -= 1;
        return self.stack[self.stack_size];
    }

    pub fn show(self: Stack, out: anytype) !void {
        try out.print("Stack: [", .{});

        for (0..self.stack_size) |i| {
            try out.print("{d} ", .{self.stack[i]});
        }

        try out.print("]", .{});
    }
};

const Bm = struct {
    bm_stack: Stack = undefined,

    pub fn execute(bm: *Bm, inst: Inst) !void {
        switch (inst.type) {
            Inst_Type.PUSH => {
                try bm.bm_stack.push(inst.operand);
            },
            Inst_Type.PLUS => {
                var a = try bm.bm_stack.pop();
                var b = try bm.bm_stack.pop();

                // std.debug.print("a= {d}, b={d}\n", .{ a, b });

                try bm.bm_stack.push(a + b);
            },
        }
    }
};

var machine = Bm{};

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const writer = stdout.writer();

    try machine.execute(.{ .type = Inst_Type.PUSH, .operand = -4 });
    try machine.execute(.{ .type = Inst_Type.PUSH, .operand = 3 });

    try machine.execute(.{ .type = Inst_Type.PLUS, .operand = 0 });

    try machine.bm_stack.show(writer);
}
