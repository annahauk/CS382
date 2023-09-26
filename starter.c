#include <stdio.h>

/*
   Anna Hauk -- I pledge my honor that I have abided by the Stevens Honor System.
   State the sorting algorithm you chose in task 3: Selection 
   State if you want to be considered for bonus points in task 3: Yes
*/

void copy_str(char* src, char* dst) {
    char* src_ptr = src; //ptr so that they can independently move through their string
    char* dst_ptr = dst; //also prevents dst and src from being manipulated

copy: if(*src_ptr != 0){ //looks for null terminator
        *dst_ptr = *src_ptr;
        src_ptr++;
        dst_ptr++;
        goto copy;
}
    *dst_ptr = 0;
}

int dot_prod(char* vec_a, char* vec_b, int length, int size_elem) {
    int sum = 0;
    int index = 0;

dot:
    if (index < length) {
        int* int_a = (int*)(vec_a + (index * size_elem));
        int* int_b = (int*)(vec_b + (index * size_elem));
        sum += (*int_a) * (*int_b);
        index++;
        goto dot;
    }

    return sum;
}

void sort_nib(int* arr, int length) {
    /* using selection sort */
    
    int n = length*8; // n = number of nibbles (each int will have 8 nibbles)
    int i = 0; // outer loop index for selection sort
    int j = 0; // inner min value finding loop index
    int min_index = 0; // index of smallest element in the unsorted part of the array
    unsigned char i_nibble; // temporary storage for nibble at index i
    unsigned char j_nibble; // temporary storage for nibble at index j
    unsigned char min_index_nibble; // temporary storage for nibble at min_index in case need to swap
    unsigned char* byte_ptr = (unsigned char *)arr;   // a convenience pointer so we can refer to specific bytes within the array of integers

    // if length is non-sensical, i.e. less than 1, then just return and leave
    // the input array (if any), unsorted, i.e. don't do anything
    if (length < 1)
    {
        return;
    }

    i=0;
    outer_loop:
    if (i==n-1){
    goto repack_ints_in_little_endian;
    }

    min_index = i;
    j = i + 1;
    loop_for_finding_min: 
    if (j==n){
        goto exit_finding_min;
    }
        // in general, when an index is even, we are referring
        // to the upper nibble in the byte, so we mask the upper
        // nibble and right shift by 4 bits to get the nibble in the
        // lower 4 signifigant bits of the byte, whereas when the index
        // is odd, we are referring to the lower nibble of the byte
        // and just mask the lower 4 bits of the byte

    // read in the nibble at index j
    if (j % 2 == 0)
    {                      
        j_nibble = (byte_ptr[j/2] & 0xf0) >> 4;
    }
    else{
        j_nibble = byte_ptr[j/2] & 0x0f;
    }

    // read in the nibble at index min_index
    if (min_index % 2 == 0){
        min_index_nibble = (byte_ptr[min_index/2] & 0xf0) >> 4;
    }
    else{
        min_index_nibble = byte_ptr[min_index/2] & 0x0f;
    }
    if (j_nibble < min_index_nibble){
        min_index = j;
    }
    ++j;
    goto loop_for_finding_min;

    exit_finding_min:
    if (min_index != i){
    // means a smaller nibble was found so swap them
    // read nibble at i
        if (i % 2 == 0){
        i_nibble = (byte_ptr[i/2] & 0xf0) >> 4; 
        }
        else{
            i_nibble = byte_ptr[i/2] & 0x0f;
        }
        // read nibble at min_index
        if (min_index % 2 == 0){
        min_index_nibble = (byte_ptr[min_index/2] & 0xf0) >> 4;
        }
        else{
            min_index_nibble = byte_ptr[min_index/2] & 0x0f;
        }
        // set nibble at i to min_index_nibble
        if (i % 2 == 0){
            byte_ptr[i/2] = (byte_ptr[i/2] & 0x0f) | ((min_index_nibble << 4) & 0xf0);
        }
        else{
            byte_ptr[i/2] = (byte_ptr[i/2] & 0xf0) | (min_index_nibble & 0x0f);
        }
        // set nibble at min_index to i_nibble
        if (min_index % 2 == 0){
            byte_ptr[min_index/2] = (byte_ptr[min_index/2] & 0x0f) | ((i_nibble << 4) & 0xf0);
        }
        else{
            byte_ptr[min_index/2] = (byte_ptr[min_index/2] & 0xf0) | (i_nibble & 0x0f);
        }
    }
    i++;
    goto outer_loop;


        // the selection sort literally puts the nibbles in memory order
        // but the test code expects integers to display in in
        // little endian byte order
        // this routine loops through all of the integers and puts
        // them in little endian order by swapping the first and last bytes
        // and the second and third bytes
        unsigned char byte;
    repack_ints_in_little_endian: i=0;// index of first integer
    
    repack_loop:
        if (i==length){
            goto done;
        }
        // swap the first and last byte    
        byte=byte_ptr[4*i];
        byte_ptr[4*i]=byte_ptr[4*i+3];
        byte_ptr[4*i+3]=byte;
        // swap the second and third byte
        byte=byte_ptr[4*i+1];
        byte_ptr[4*i+1]=byte_ptr[4*i+2];
        byte_ptr[4*i+2]=byte;
        i++;
        goto repack_loop;
    done:  
}


int main(int argc, char** argv) {
    /**
     * Task 1
     */
    //TEST 1
    char a[1] = "";
    char b[100] = {0};

    copy_str(a, b);
    puts(a); // Should print an empty line
    puts(b); // Should print an empty line

    //TEST 2
    char c[] = "Dogs are fluffy!";
    char d[100] = {0};

    copy_str(c, d);
    puts(c); // Should print "Dogs are fluffy!"
    puts(d); // Should print "Dogs are fluffy!"

    //TEST 3
    char e[] = "Anna";
    char f[100] = {0};

    copy_str(e, f);
    puts(e); // Should print "Anna"
    puts(f); // Should print "Anna"

    //TEST 4
    char g[] = "long sentence with more than 100 characters. It is not going to the park and neither is the dog. should be truncated.";
    char h[200] = {0};

    copy_str(g, h);
    puts(g); // Should print the entire source string
    puts(h); // Should print the entire source string

    //TEST 5
    char i[] = "Short";
    char j[3] = {0}; // Destination string can hold only 2 characters

    copy_str(i, j);
    puts(i); // Should print "Short"
    puts(j); // Should print "Sh" (truncated to fit the destination)

    //TEST GIVEN 
    char str1[] = "382 is the best!";
    char str2[100] = {0};

    copy_str(str1,str2);
    puts(str1);
    puts(str2);

    printf("\n");

    /**
     * Task 2
     */
    //TEST GIVEN
    int vec_a[3] = {-2, 34, 10};
    int vec_b[3] = {10, 20, 30};
    int dot = dot_prod((char*)vec_a, (char*)vec_b, 3, sizeof(int));
    
    printf("%d\n",dot);

    //TEST 1
    int vec_a1[3] = {2, 3, 4};
    int vec_b1[3] = {1, 2, 3};
    int dot1 = dot_prod((char*)vec_a1, (char*)vec_b1, 3, sizeof(int));
    printf("%d\n", dot1); // Expected output: 20

    //TEST 2
    int vec_a2[3] = {1, 2, 3};
    int vec_b2[3] = {4, 5, 6};
    int dot2 = dot_prod((char*)vec_a2, (char*)vec_b2, 3, sizeof(int));
    printf("%d\n", dot2); // Expected output: 32

    //TEST 3
    int vec_a3[4] = {-1, -2, -3, -4};
    int vec_b3[4] = {-5, -6, -7, -8};
    int dot3 = dot_prod((char*)vec_a3, (char*)vec_b3, 4, sizeof(int));
    printf("%d\n", dot3); // Expected output: 70

    //TEST 4
    int vec_a4[4] = {1, -2, 3, -4};
    int vec_b4[4] = {-5, 6, -7, 8};
    int dot4 = dot_prod((char*)vec_a4, (char*)vec_b4, 4, sizeof(int));
    printf("%d\n", dot4); // Expected output: -70

    //TEST 5
    int vec_a5[3] = {0, 0, 0};
    int vec_b5[3] = {1, 2, 3};
    int dot5 = dot_prod((char*)vec_a5, (char*)vec_b5, 3, sizeof(int));
    printf("%d\n", dot5); // Expected output: 0
    
    //TEST 6
    int vec_a6[5] = {1, -1, 1, -1, 1};
    int vec_b6[5] = {1, 1, 1, 1, 1};
    int dot6 = dot_prod((char*)vec_a6, (char*)vec_b6, 5, sizeof(int));
    printf("%d\n", dot6); // Expected output: 1
    
    //TEST 7
    int vec_a7[1] = {42};
    int vec_b7[1] = {0};
    int dot7 = dot_prod((char*)vec_a7, (char*)vec_b7, 1, sizeof(int));
    printf("%d\n", dot7); //Expected output: 0

    //TEST 8
    int vec_a8[0] = {};
    int vec_b8[0] = {};
    int dot8 = dot_prod((char*)vec_a8, (char*)vec_b8, 0, sizeof(int));
    printf("%d\n", dot8); // Expected output: 0

    //TEST 9
    int vec_a9[1] = {1000};
    int vec_b9[1] = {1000};
    int dot9 = dot_prod((char*)vec_a9, (char*)vec_b9, 1, sizeof(int));
    printf("%d\n", dot9); // Expected output: 1,000,000

    //TEST10
    int vec_a10[3] = {1, 0, -1};
    int vec_b10[3] = {1, 0, -1};
    int dot10 = dot_prod((char*)vec_a10, (char*)vec_b10, 3, sizeof(int));
    printf("%d\n", dot10); // Expected output: 2

    printf("\n");
    /**
     * Task 3
     */

    //TEST GIVEN
    int arr[3] = {0x12BFDA09, 0x9089CDBA, 0x56788910};
    unsigned char *char_ptr = (unsigned char *)arr;
    printf("before:\n");
    for(int i = 0; i<3*4; i++)
    {
        printf("%02x", char_ptr[i]);
    }
    printf("\n");
    sort_nib(arr, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++)
    {
        printf("%02x", char_ptr[i]);
    }
    printf("\n");

    // TESTS
    // TEST 1
    int arr1[3] = {0xABCDEF01, 0x90807060, 0x12345678};
    unsigned char *char_ptr1 = (unsigned char *)arr1;
    printf("before:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr1[i]);
    }
    printf("\n");
    sort_nib(arr1, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr1[i]);
    }
    printf("\n");

    // TEST 2
    int arr2[0] = {};
    unsigned char *char_ptr2 = (unsigned char *)arr2;
    printf("before:\n");
    for(int i = 0; i<0; i++) {
        printf("%02x", char_ptr2[i]);
    }
    printf("\n");
    sort_nib(arr2, 0);
    printf("after:\n");
    for(int i = 0; i<0; i++) {
        printf("%02x", char_ptr2[i]);
    }
    printf("\n");

    // TEST 3
    int arr3[1] = {0x12345678};
    unsigned char *char_ptr3 = (unsigned char *)arr3;
    printf("before:\n");
    for(int i = 0; i<1*4; i++) {
        printf("%02x", char_ptr3[i]);
    }
    printf("\n");
    sort_nib(arr3, 1);
    printf("after:\n");
    for(int i = 0; i<1*4; i++) {
        printf("%02x", char_ptr3[i]);
    }
    printf("\n");

    //TEST 4
    int arr4[3] = {0x01234567, 0x89ABCDEF, 0xFEDCBA98};
    unsigned char *char_ptr4 = (unsigned char *)arr4;
    printf("before:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr4[i]);
    }
    printf("\n");
    sort_nib(arr4, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr4[i]);
    }
    printf("\n");

    //TEST 5
    int arr5[2] = {0x87654321, 0xFEDCBA98};
    unsigned char *char_ptr5 = (unsigned char *)arr5;
    printf("before:\n");
    for(int i = 0; i<2*4; i++) {
        printf("%02x", char_ptr5[i]);
    }
    printf("\n");
    sort_nib(arr5, 2);
    printf("after:\n");
    for(int i = 0; i<2*4; i++) {
        printf("%02x", char_ptr5[i]);
    }
    printf("\n");

    // TEST 6
    int arr6[3] = {0x11223344, 0x55667788, 0x99AABBCC};
    unsigned char *char_ptr6 = (unsigned char *)arr6;
    printf("before:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr6[i]);
    }
    printf("\n");
    sort_nib(arr6, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr6[i]);
    }
    printf("\n");

    //TEST 7
    int arr7[3] = {0x00000000, 0x00000000, 0x00000000};
    unsigned char *char_ptr7 = (unsigned char *)arr7;
    printf("before:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr7[i]);
    }
    printf("\n");
    sort_nib(arr7, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr7[i]);
    }
    printf("\n");

    // TEST 8
    int arr8[4] = {0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF};
    unsigned char *char_ptr8 = (unsigned char *)arr8;
    printf("before:\n");
    for(int i = 0; i<4*4; i++) {
        printf("%02x", char_ptr8[i]);
    }
    printf("\n");
    sort_nib(arr8, 4);
    printf("after:\n");
    for(int i = 0; i<4*4; i++) {
        printf("%02x", char_ptr8[i]);
    }
    printf("\n");

    //TEST 9
    int arr9[2] = {0xABCD1234, 0x5678EFA1};
    unsigned char *char_ptr9 = (unsigned char *)arr9;
    printf("before:\n");
    for(int i = 0; i<2*4; i++) {
        printf("%02x", char_ptr9[i]);
    }
    printf("\n");
    sort_nib(arr9, 2);
    printf("after:\n");
    for(int i = 0; i<2*4; i++) {
        printf("%02x", char_ptr9[i]);
    }
    printf("\n");

    //TEST 10
    int arr10[3] = {0xABCDEF01, 0x23456789, 0xFEDCBA98};
    unsigned char *char_ptr10 = (unsigned char *)arr10;
    printf("before:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr10[i]);
    }
    printf("\n");
    sort_nib(arr10, 3);
    printf("after:\n");
    for(int i = 0; i<3*4; i++) {
        printf("%02x", char_ptr10[i]);
    }
    printf("\n");

    return 0;
}