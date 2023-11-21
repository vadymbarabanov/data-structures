const std = @import("std");
const expect = std.testing.expect;

const ErrStack = error{
    StackIsEmpty,
};

/// Stack is a data structure which implements
/// the stack abstract data type interface
/// using a singly linked list data structure
pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            data: T,
            next: ?*Node,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        size: usize,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .head = null,
                .size = 0,
            };
        }

        pub fn deinit(self: *Self) void {
            var current = self.head;
            while (current) |curr| {
                current = curr.next;
                self.allocator.destroy(curr);
            }
        }

        pub fn push(self: *Self, value: T) !void {
            var node = try self.allocator.create(Node);
            node.data = value;
            node.next = self.head;

            self.head = node;
            self.size += 1;
        }

        pub fn pop(self: *Self) !T {
            if (self.head) |head| {
                defer self.allocator.destroy(head);
                self.head = head.next;
                self.size -= 1;
                return head.data;
            } else {
                return ErrStack.StackIsEmpty;
            }
        }
    };
}

test "push" {
    var stack = Stack(i32).init(std.testing.allocator);
    defer stack.deinit();

    try stack.push(2);
    try stack.push(3);

    try expect(stack.size == 2);
}

test "pop" {
    var stack = Stack(i32).init(std.testing.allocator);
    defer stack.deinit();

    _ = stack.pop() catch |err| {
        try expect(err == ErrStack.StackIsEmpty);
    };

    try stack.push(2);
    try stack.push(3);

    try expect(stack.size == 2);
    try expect(try stack.pop() == 3);
    try expect(stack.size == 1);
    try expect(try stack.pop() == 2);
    try expect(stack.size == 0);
}

test "tower of hanoi" {
    var stack_a = Stack(u8).init(std.testing.allocator);
    defer stack_a.deinit();

    var stack_b = Stack(u8).init(std.testing.allocator);
    defer stack_b.deinit();

    var stack_c = Stack(u8).init(std.testing.allocator);
    defer stack_c.deinit();

    // 4 is the biggest plate, 1 is the smallest
    try stack_a.push(4);
    try stack_a.push(3);
    try stack_a.push(2);
    try stack_a.push(1);
    try expect(stack_a.size == 4);

    // |1|  | |  | |
    // |2|  | |  | |
    // |3|  | |  | |
    // |4|  | |  | |
    try stack_b.push(try stack_a.pop());
    // | |  | |  | |
    // |2|  | |  | |
    // |3|  | |  | |
    // |4|  |1|  | |
    try stack_c.push(try stack_a.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |3|  | |  | |
    // |4|  |1|  |2|
    try stack_c.push(try stack_b.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |3|  | |  |1|
    // |4|  | |  |2|
    try stack_b.push(try stack_a.pop());
    // | |  | |  | |
    // | |  | |  | |
    // | |  | |  |1|
    // |4|  |3|  |2|
    try stack_a.push(try stack_c.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |1|  | |  | |
    // |4|  |3|  |2|
    try stack_b.push(try stack_c.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |1|  |2|  | |
    // |4|  |3|  | |
    try stack_b.push(try stack_a.pop());
    // | |  | |  | |
    // | |  |1|  | |
    // | |  |2|  | |
    // |4|  |3|  | |
    try stack_c.push(try stack_a.pop());
    // | |  | |  | |
    // | |  |1|  | |
    // | |  |2|  | |
    // | |  |3|  |4|
    try stack_c.push(try stack_b.pop());
    // | |  | |  | |
    // | |  | |  | |
    // | |  |2|  |1|
    // | |  |3|  |4|
    try stack_a.push(try stack_b.pop());
    // | |  | |  | |
    // | |  | |  | |
    // | |  | |  |1|
    // |2|  |3|  |4|
    try stack_a.push(try stack_c.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |1|  | |  | |
    // |2|  |3|  |4|
    try stack_c.push(try stack_b.pop());
    // | |  | |  | |
    // | |  | |  | |
    // |1|  | |  |3|
    // |2|  | |  |4|
    try stack_b.push(try stack_a.pop());
    // | |  | |  | |
    // | |  | |  | |
    // | |  | |  |3|
    // |2|  |1|  |4|
    try stack_c.push(try stack_a.pop());
    // | |  | |  | |
    // | |  | |  |2|
    // | |  | |  |3|
    // | |  |1|  |4|
    try stack_c.push(try stack_b.pop());
    // | |  | |  |1|
    // | |  | |  |2|
    // | |  | |  |3|
    // | |  | |  |4|

    try expect(stack_c.size == 4);
    try expect(try stack_c.pop() == 1);
    try expect(try stack_c.pop() == 2);
    try expect(try stack_c.pop() == 3);
    try expect(try stack_c.pop() == 4);

    _ = stack_c.pop() catch |err| {
        try expect(err == ErrStack.StackIsEmpty);
    };
}
