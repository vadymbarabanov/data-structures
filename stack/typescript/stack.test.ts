import { expect, test } from "bun:test";
import { Stack } from "./stack";

test("stack: push, pop and size", () => {
    const s = new Stack();

    expect(s.pop()).toBe(null);
    expect(s.size()).toBe(0);

    s.push(2);
    s.push(4);
    s.push(6);

    expect(s.size()).toBe(3);

    expect(s.pop()).toBe(6);
    expect(s.pop()).toBe(4);
    expect(s.pop()).toBe(2);

    expect(s.size()).toBe(0);
});

