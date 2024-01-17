#include "UnrolledLL.h"

/*
	Author:  Anna Hauk
	Pledge: I pledge my honor that I have abided by the Stevens Honor system.
*/

/**
 * Constructor for a node in the unrolled linked list.
 * This should create a node with the given block siz.
 * @param size Size of the list
 * @param blksize Size of each block
 */
uNode::uNode(uNode* prev, u_int64_t blksize) : blksize(blksize) {
	this->next = nullptr;
	//array of ints that go into the nodes
	this->datagrp = new int[blksize];
	if (prev == nullptr){
		prev = this;
	}else{
		prev->next = this;
	}
	for(auto i = 0; i < blksize; i++){ //assign random values into each element
		this->datagrp[i] = rand() % 100;
	}
}

/**
 * Destructor for a node in the unrolled linked list.
 * This should deallocate all memory associated with the uNode.
 */
uNode::~uNode() {
	delete[] datagrp;
}

/**
 * Constructor for the unrolled linked list.
 * This should create a linked list of uNodes.
 * @param size Size of the list
 * @param blksize Size of each block
 */
UnrolledLL::UnrolledLL(u_int64_t size, u_int64_t blksize) {
	//nodes = size/blksize
	head = new uNode(nullptr, blksize);
	uNode* prev = head;
	//int length = size;
	for(auto i = 1; i < (size/blksize); i++){
		uNode* node = new uNode(prev, blksize);
        prev = node;  // Update the prev pointer
	}

}

/**
 * Destructor for the unrolled linked list.
 * This should deallocate all memory associated with the unrolled linked list.
 */
UnrolledLL::~UnrolledLL() {
	uNode* current = head;
	uNode* next;

	while (current != nullptr) {
		next = current->next;
		delete current;
		current = next;
	}

	head = nullptr;
}

/**
 * Iterate through the unrolled linked list.
 * Simply iterate through the unrolled linked list and access each element.
 */
void UnrolledLL::iterate_ullist() {
	uNode* iter = head;
	while (iter != nullptr) {
		int* dg = iter->datagrp;
		int discard;
		for (auto i = 0; i < iter->blksize; i++) { //looking at one node and element at a time
			discard = dg[i];
		}
		iter = iter->next;
	}
}
