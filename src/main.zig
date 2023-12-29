const std = @import("std");
const assert = std.debug.assert;

const STACK_CAPACITY = 1024;

const Word = i64;

const Inst_Type = enum { INST_PUSH, INST_PLUS };
const Inst = struct { type: Inst_Type, operand: Word };

const Bm = struct {
    stack: [STACK_CAPACITY]Word,
    stack_size: usize,

    pub fn execute(self: *Bm, inst: Inst) void {
        switch (inst.type) {
            Inst_Type.INST_PUSH => {
                assert(self.stack_size < STACK_CAPACITY);
                self.stack[self.stack_size] = inst.operand;
                self.stack_size += 1;
            },
        }
    }
};

var bm = Bm{};

pub fn main() !void {}
