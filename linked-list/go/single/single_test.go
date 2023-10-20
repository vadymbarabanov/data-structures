package single_test

import (
	"errors"
	"linked-list/single"
	"testing"
)

func TestSingle_ToSlice(t *testing.T) {
	list := &single.Single{}

	result1 := list.ToSlice()

	if len(result1) != 0 {
		t.Fatalf("expected a new list to be empty")
	}

	input := []int{1, 3, 5, 4}

	for _, value := range input {
		list.Append(value)
	}

	result2 := list.ToSlice()

	for i, value := range input {
		if value != result2[i] {
			t.Fatalf("want (%v) got (%v)", value, result2[i])
		}
	}
}

func TestSingle_Append(t *testing.T) {
	list := &single.Single{}

	input := []int{1, 2}

	for _, value := range input {
		list.Append(value)
	}

	result := list.ToSlice()

	if len(result) != len(input) {
		t.Fatalf("expected list to be lenght of %d", len(input))
	}

	for i, value := range input {
		if value != result[i] {
			t.Fatalf("want (%v) got (%v)", value, result[i])
		}
	}
}

func TestSingle_Prepend(t *testing.T) {
	list := &single.Single{}

	input := []int{1, 2, 3, 4}

	for _, value := range input {
		list.Prepend(value)
	}

	result := list.ToSlice()

	for i, value := range input {
		resultValue := result[len(input)-i-1]
		if resultValue != value {
			t.Fatalf("want (%v) got (%v)", value, resultValue)
		}
	}
}

func TestSingle_RemoveAtHead(t *testing.T) {
	list := &single.Single{}

	err := list.RemoveAtHead()

	if !errors.Is(err, single.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", single.ErrListIsEmpty, err)
	}

	input := []int{1, 2, 3, 4}

	for _, value := range input {
		list.Append(value)
	}

	list.RemoveAtHead()
	list.RemoveAtHead()

	expectedResult := input[2:]
	result := list.ToSlice()

	if len(result) != len(expectedResult) {
		t.Fatalf("expected list to be length of %d", len(expectedResult))
	}

	for i, value := range expectedResult {
		if value != result[i] {
			t.Fatalf("want (%v) got (%v)", value, result[i])
		}
	}
}

func TestSingle_RemoveAtTail(t *testing.T) {
	list := &single.Single{}

	err := list.RemoveAtTail()

	if !errors.Is(err, single.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", single.ErrListIsEmpty, err)
	}

	input := []int{1, 2, 3, 4}

	for _, value := range input {
		list.Append(value)
	}

	list.RemoveAtTail()
	list.RemoveAtTail()

	expectedResult := input[:2]
	result := list.ToSlice()

	if len(result) != len(expectedResult) {
		t.Fatalf("expected list to be length of %d", len(expectedResult))
	}

	for i, value := range expectedResult {
		if value != result[i] {
			t.Fatalf("want (%v) got (%v)", value, result[i])
		}
	}
}

func TestSingle_RemoveNode(t *testing.T) {
	list := &single.Single{}

	err := list.RemoveNode(1)

	if !errors.Is(err, single.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", single.ErrListIsEmpty, err)
	}

	input := []int{1, 2, 3, 3, 4}

	for _, value := range input {
		list.Append(value)
	}

	list.RemoveNode(2)
	list.RemoveNode(3)

	expectedResult := []int{1, 3, 4}
	result := list.ToSlice()

	if len(result) != len(expectedResult) {
		t.Fatalf("expected list to be length of %d", len(expectedResult))
	}

	for i, value := range expectedResult {
		if value != result[i] {
			t.Fatalf("want (%v) got (%v)", value, result[i])
		}
	}
}
