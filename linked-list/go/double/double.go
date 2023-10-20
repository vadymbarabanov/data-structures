package double

import "errors"

var (
	ErrListIsEmpty = errors.New("list is empty")
)

// node is a struct which represents a
// single node in a doubly linked list
type node struct {
	data int
	prev *node
	next *node
}

// Double is a struct which implements
// doubly linked list data type interface
type Double struct {
	head *node
	tail *node
}

// Append inserts an element at list's tail
// Complexity: O(1)
func (l *Double) Append(d int) {
	n := &node{
		data: d,
	}

	if l.head == nil {
		l.head = n
		l.tail = n
	} else {
		n.prev = l.tail
		l.tail.next = n
		l.tail = n
	}
}

// Prepend inserts an element at list's head
// Complexity: O(1)
func (l *Double) Prepend(d int) {
	n := &node{
		data: d,
	}

	if l.head == nil {
		l.head = n
		l.tail = n
	} else {
		n.next = l.head
		l.head.prev = n
		l.head = n
	}
}

// RemoveAtHead removes a node at list's head
// Complexity: O(1)
func (l *Double) RemoveAtHead() error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	if l.head.next != nil {
		l.head.next.prev = nil
	}

	l.head = l.head.next
	return nil
}

// RemoveAtTail removes a node at list's tail
// Complexity: O(1)
func (l *Double) RemoveAtTail() error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	if l.tail.prev != nil {
		l.tail.prev.next = nil
	}

	l.tail = l.tail.prev
	return nil
}

// RemoveNode removes the first node that matches data
// Complexity: O(n)
func (l *Double) RemoveNode(d int) error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	prev := l.head
	curr := l.head

	for {
		if curr.data == d {
			switch {
			case curr.next == nil:
				l.RemoveAtTail()
			case curr.prev == nil:
				l.RemoveAtHead()
			default:
				next := curr.next
				prev.next = next
				next.prev = prev
				curr = nil
			}
			break
		}

		prev = curr
		curr = curr.next
	}

	return nil
}

// ToSlice returns a slice of list's data
func (l *Double) ToSlice() []int {
	result := make([]int, 0)

	if l.head == nil {
		return result
	}

	curr := l.head

	for {
		result = append(result, curr.data)
		if curr.next == nil {
			break
		}

		curr = curr.next
	}

	return result
}
