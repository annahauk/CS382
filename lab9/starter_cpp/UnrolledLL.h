#include <unistd.h>
#include <cstdlib>

class uNode {
public:
	int* datagrp;
	u_int64_t blksize;
	uNode* next;

	uNode(uNode* prev, u_int64_t blksize);
	~uNode();
};

class UnrolledLL {
public:
	uNode* head;
	u_int64_t len;

	UnrolledLL(u_int64_t size, u_int64_t blksize);
	~UnrolledLL();
	void iterate_ullist();
};
