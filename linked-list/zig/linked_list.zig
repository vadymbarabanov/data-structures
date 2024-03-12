const std = @import("std");
const expect = std.testing.expect;

const LinkedListErrors = error{
    ListIsEmpty,
    OutOfBounds,
};

/// LinkedList is a data structure which implements
/// the linked list abstract data type interface
pub fn LinkedList(comptime T: type) type {
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
            var head = self.head;
            while (head) |current| {
                head = current.next;
                self.allocator.destroy(current);
            }
        }

        pub fn append(self: *Self, data: T) !void {
            var node = try self.allocator.create(Node);
            node.data = data;
            node.next = null;

            if (self.tail) |tail| {
                tail.next = node;
            } else {
                self.head = node;
            }

            self.tail = node;
            self.size += 1;
        }

        pub fn prepend(self: *Self, data: T) !void {
            var node = try self.allocator.create(Node);
            node.data = data;
            node.next = null;

            if (self.head) |head| {
                node.next = head;
            } else {
                self.tail = node;
            }

            self.head = node;
            self.size += 1;
        }

        pub fn at(self: *Self, index: usize) !T {
            var current = self.head;
            var idx: usize = 0;
            while (current) |curr| {
                if (idx == index) return curr.data;
                current = curr.next;
                idx += 1;
            } else {
                return LinkedListErrors.OutOfBounds;
            }
        }

        pub fn removeAtHead(self: *Self) !void {
            if (self.head) |head| {
                if (head.next) |next| {
                    self.head = next;
                } else {
                    self.head = null;
                    self.tail = null;
                }

                self.allocator.destroy(head);
                self.size -= 1;
            } else {
                return LinkedListErrors.ListIsEmpty;
            }
        }

        pub fn removeAtTail(self: *Self) !void {
            if (self.head) |head| {
                var prev: ?*Node = null;
                var curr = head;

                while (curr.next) |next| {
                    prev = curr;
                    curr = next;
                } else {
                    if (prev) |p| p.next = null;
                    self.tail = prev;
                    self.allocator.destroy(curr);
                    self.size -= 1;
                    if (self.size == 0) self.head = null;
                }
            } else {
                return LinkedListErrors.ListIsEmpty;
            }
        }

        pub fn removeAt(self: *Self, index: usize) !void {
            if (index == 0) {
                return self.removeAtHead();
            }

            if (index + 1 == self.size) {
                return self.removeAtTail();
            }

            if (self.head) |head| {
                var prev = head;
                var current = head.next;
                var idx: usize = 1;
                while (current) |curr| {
                    if (idx == index) {
                        prev.next = curr.next;
                        self.allocator.destroy(curr);
                        self.size -= 1;
                        return;
                    }
                    prev = curr;
                    current = curr.next;
                }
            }

            return LinkedListErrors.OutOfBounds;
        }
    };
}

test "append" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try list.append(2);

    try expect(list.size == 1);

    try list.append(4);
    try list.append(5);

    try expect(list.size == 3);
}

test "prepend" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try list.prepend(2);

    try expect(list.size == 1);

    try list.prepend(4);
    try list.prepend(5);

    try expect(list.size == 3);
}

test "get element by index" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    _ = list.at(2) catch |err| {
        try expect(err == LinkedListErrors.OutOfBounds);
    };

    try list.append(4);
    try list.append(5);

    try expect(try list.at(0) == 4);
    try expect(try list.at(1) == 5);
}

test "remove at head" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAtHead() catch |err| {
        try expect(err == LinkedListErrors.ListIsEmpty);
    };

    try list.append(2);
    try list.append(3);
    try list.append(5);

    try list.removeAtHead();

    try expect(list.size == 2);
    try expect(try list.at(0) == 3);
    try expect(try list.at(1) == 5);

    try list.removeAtHead();
    try list.removeAtHead();

    try expect(list.size == 0);
}

test "remove at tail" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAtTail() catch |err| {
        try expect(err == LinkedListErrors.ListIsEmpty);
    };

    try list.append(2);
    try list.append(3);
    try list.append(5);

    try list.removeAtTail();

    try expect(list.size == 2);
    try expect(try list.at(0) == 2);
    try expect(try list.at(1) == 3);

    try list.removeAtTail();
    try list.removeAtTail();

    try expect(list.size == 0);
}

test "remove element by index" {
    var list = LinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAt(1) catch |err| {
        try expect(err == LinkedListErrors.OutOfBounds);
    };

    try list.append(2);
    try list.append(3);
    try list.append(5);

    try list.removeAt(1);

    try expect(list.size == 2);
    try expect(try list.at(0) == 2);
    try expect(try list.at(1) == 5);
}
