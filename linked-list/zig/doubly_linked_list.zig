const std = @import("std");
const expect = std.testing.expect;

const DoublyLinkedListErrors = error{
    ListIsEmpty,
    OutOfBounds,
};

/// DoublyLinkedList is a data structure which implements
/// the doubly linked list abstract data type interface
pub fn DoublyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            data: T,
            prev: ?*Node,
            next: ?*Node,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        size: usize,

        fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .head = null,
                .tail = null,
                .size = 0,
            };
        }

        fn deinit(self: *Self) void {
            var head = self.head;
            while (head) |current| {
                head = current.next;
                self.allocator.destroy(current);
            }
        }

        fn append(self: *Self, data: T) !void {
            var node = try self.allocator.create(Node);
            node.data = data;
            node.prev = null;
            node.next = null;

            if (self.tail) |tail| {
                tail.next = node;
                node.prev = tail;
            } else {
                self.head = node;
            }

            self.tail = node;
            self.size += 1;
        }

        fn prepend(self: *Self, data: T) !void {
            var node = try self.allocator.create(Node);
            node.data = data;
            node.prev = null;
            node.next = null;

            if (self.head) |head| {
                node.next = head;
                head.prev = node;
            } else {
                self.tail = node;
            }

            self.head = node;
            self.size += 1;
        }

        fn at(self: *Self, index: usize) !T {
            var head = self.head;
            var idx: usize = 0;
            while (head) |current| {
                if (idx == index) return current.data;
                head = current.next;
                idx += 1;
            } else {
                return DoublyLinkedListErrors.OutOfBounds;
            }
        }

        fn removeAtHead(self: *Self) !void {
            if (self.head) |head| {
                if (head.next) |next| {
                    next.prev = null;
                    self.head = next;
                } else {
                    self.head = null;
                    self.tail = null;
                }
                self.allocator.destroy(head);
                self.size -= 1;
            } else {
                return DoublyLinkedListErrors.ListIsEmpty;
            }
        }

        fn removeAtTail(self: *Self) !void {
            if (self.tail) |tail| {
                if (tail.prev) |prev| {
                    prev.next = null;
                    self.tail = prev;
                } else {
                    self.head = null;
                    self.tail = null;
                }
                self.allocator.destroy(tail);
                self.size -= 1;
            } else {
                return DoublyLinkedListErrors.ListIsEmpty;
            }
        }

        fn removeAt(self: *Self, index: usize) !void {
            var head = self.head;
            var idx: usize = 0;
            while (head) |current| {
                if (idx == index) {
                    if (current.prev) |prev| {
                        prev.next = current.next;
                    } else {
                        self.head = current.next;
                    }

                    if (current.next) |next| {
                        next.prev = current.prev;
                    } else {
                        self.tail = current.prev;
                    }

                    self.allocator.destroy(current);
                    self.size -= 1;
                    return;
                }
                idx += 1;
                head = current.next;
            } else {
                return DoublyLinkedListErrors.OutOfBounds;
            }
        }
    };
}

test "append" {
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try list.append(2);

    try expect(list.size == 1);

    try list.append(4);
    try list.append(5);

    try expect(list.size == 3);
}

test "prepend" {
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try list.prepend(2);

    try expect(list.size == 1);

    try list.prepend(4);
    try list.prepend(5);

    try expect(list.size == 3);
}

test "get element by index" {
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    _ = list.at(2) catch |err| {
        try expect(err == DoublyLinkedListErrors.OutOfBounds);
    };

    try list.append(4);
    try list.append(5);

    try expect(try list.at(0) == 4);
    try expect(try list.at(1) == 5);
}

test "remove at head" {
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAtHead() catch |err| {
        try expect(err == DoublyLinkedListErrors.ListIsEmpty);
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
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAtTail() catch |err| {
        try expect(err == DoublyLinkedListErrors.ListIsEmpty);
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
    var list = DoublyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    list.removeAt(1) catch |err| {
        try expect(err == DoublyLinkedListErrors.OutOfBounds);
    };

    try list.append(2);
    try list.append(3);
    try list.append(5);

    try list.removeAt(1);

    try expect(list.size == 2);
    try expect(try list.at(0) == 2);
    try expect(try list.at(1) == 5);
}
