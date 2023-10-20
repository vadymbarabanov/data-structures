const std = @import("std");
const expect = std.testing.expect;

const QueueErrors = error {
    QueueIsEmpty,
};

/// Queue is a data structure which implements
/// the queue abstract data type interface
/// using a singly linked list data structure
pub fn Queue(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            data: T,
            next: ?*Node,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        size: usize,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .head = null,
                .tail = null,
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

        pub fn enqueue(self: *Self, value: T) !void {
            var node = try self.allocator.create(Node);
            node.data = value;
            node.next = null;

            if (self.tail) |tail| {
                tail.next = node;
                self.tail = node;
            } else {
                self.head = node;
                self.tail = node;
            }
            self.size += 1;
        }

        pub fn dequeue(self: *Self) !T {
            if (self.head) |head| {
                defer self.allocator.destroy(head);
                self.head = head.next;
                self.size -= 1;
                return head.data;
            } else {
                return QueueErrors.QueueIsEmpty;
            }
        }
    };
}

test "enqueue" {
    var queue = Queue(i32).init(std.testing.allocator);
    defer queue.deinit();

    try queue.enqueue(2);
    try expect(queue.size == 1);

    try queue.enqueue(3);
    try queue.enqueue(5);
    try expect(queue.size == 3);
}

test "dequeue" {
    var queue = Queue(i32).init(std.testing.allocator);
    defer queue.deinit();

    _ = queue.dequeue() catch |err| {
        try expect(err == QueueErrors.QueueIsEmpty);
    };

    try queue.enqueue(2);
    try queue.enqueue(4);
    try queue.enqueue(6);

    try expect(try queue.dequeue() == 2);
    try expect(queue.size == 2);
    try expect(try queue.dequeue() == 4);
    try expect(try queue.dequeue() == 6);
    try expect(queue.size == 0);
}

