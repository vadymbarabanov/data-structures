class Node<T> {
    next: Node<T> | null;
    data: T;
};

export class Stack<T> {
    private head: Node<T> | null = null;
    private _size: number = 0;

    public push(data: T) {
        const node = new Node();
        node.data = data;
        node.next = this.head;
        this.head = node;
        this._size += 1;
    }
    
    public pop(): T | null {
        if (this.head === null) {
            return null;
        }

        const data = this.head.data;
        this.head = this.head.next;
        this._size -= 1;
        return data;
    }

    public size() {
        return this._size;
    }
}

