package double_test

import (
	"errors"
	"linked-list/double"
	"testing"
)

func TestDouble_ToSlice(t *testing.T) {
	list := &double.Double{}

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

func TestDouble_Append(t *testing.T) {
	list := &double.Double{}

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

func TestDouble_Prepend(t *testing.T) {
	list := &double.Double{}

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

func TestDouble_RemoveAtHead(t *testing.T) {
	list := &double.Double{}

	err := list.RemoveAtHead()

	if !errors.Is(err, double.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", double.ErrListIsEmpty, err)
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

func TestDouble_RemoveAtTail(t *testing.T) {
	list := &double.Double{}

	err := list.RemoveAtTail()

	if !errors.Is(err, double.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", double.ErrListIsEmpty, err)
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

func TestDouble_RemoveNode(t *testing.T) {
	list := &double.Double{}

	err := list.RemoveNode(1)

	if !errors.Is(err, double.ErrListIsEmpty) {
		t.Fatalf("want (%v) got (%v)", double.ErrListIsEmpty, err)
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
