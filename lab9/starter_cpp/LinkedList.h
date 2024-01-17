#include <ctime>
#include <cstdlib>

class Node {
public:
	int data;
	Node* next;

	Node(Node* prev);
};

class LinkedList {
public:
	Node* head;
	u_int64_t len;

	LinkedList(u_int64_t size);
	~LinkedList();
	void iterate_llist();
};
