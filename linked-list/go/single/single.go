package single

import "errors"

var (
	ErrListIsEmpty = errors.New("list is empty")
)

// node is a struct which represents a
// single node in a singly linked list
type node struct {
	data int
	ref  *node
}

// Single is a data structure which implements
// the linked list abstract data type interface
type Single struct {
	head *node
	tail *node
}

// Append inserts an element at list's tail
// Complexity: O(1)
func (l *Single) Append(d int) {
	n := &node{
		data: d,
		ref:  nil,
	}

	if l.head == nil {
		l.head = n
		l.tail = n
	} else {
		l.tail.ref = n
		l.tail = n
	}
}

// Prepend inserts an element at list's head
// Complexity: O(1)
func (l *Single) Prepend(d int) {
	n := &node{
		data: d,
		ref:  l.head,
	}

	if l.head == nil {
		l.tail = n
	}

	l.head = n
}

// RemoveAtHead removes a node at list's head
// Complexity: O(1)
func (l *Single) RemoveAtHead() error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	l.head = l.head.ref
	return nil
}

// RemoveAtTail removes a node at list's tail
// Complexity: O(n)
func (l *Single) RemoveAtTail() error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	prev := l.head
	curr := l.head

	for {
		if curr.ref == nil {
			prev.ref = nil
			curr = nil
			l.tail = prev
			break
		}

		prev = curr
		curr = curr.ref
	}

	return nil
}

// RemoveNode removes the first node that matches data
// Complexity: O(n)
func (l *Single) RemoveNode(d int) error {
	if l.head == nil {
		return ErrListIsEmpty
	}

	prev := l.head
	curr := l.head

	for {
		if curr.data == d {
			if curr.ref == nil {
				l.tail = prev
			} else {
				prev.ref = curr.ref
			}

			curr = nil
			break
		}

		prev = curr
		curr = curr.ref
	}

	return nil
}

// ToSlice returns a slice of list's data
func (l *Single) ToSlice() []int {
	result := make([]int, 0)

	if l.head == nil {
		return result
	}

	curr := l.head

	for {
		result = append(result, curr.data)
		if curr.ref == nil {
			break
		}

		curr = curr.ref
	}

	return result
}
