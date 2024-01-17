#include "LinkedList.h"

/**
 * Constructor for Node
 * @param prev Pointer to the previous node
 */
Node::Node(Node* prev) {
	next = nullptr;
	data = rand() % 100;
	if (prev == nullptr)
		prev = this;
	else
		prev->next = this;
}

/**
 * Constructor for LinkedList
 * @param size Size of the linked list
 */
LinkedList::LinkedList(u_int64_t size) {
	head = nullptr;
	len = 0;
	Node* nnode;

	for (u_int64_t i = 0; i < size; i++) {
		if (i == 0)
			head = nnode = new Node(head);
		else
			nnode = new Node(nnode);
		len++;
	}
}

/**
 * Destructor for LinkedList.
 */
LinkedList::~LinkedList() {
	Node* current = head;
	Node* next;

	while (current != nullptr) {
		next = current->next;
		delete current;
		current = next;
	}

	head = nullptr;
}

/**
 * Iterate through the linked list
 */
void LinkedList::iterate_llist() {
	Node* iter = head;
	while (iter != nullptr) {
		int num = iter->data;
		iter = iter->next;
	}
}
