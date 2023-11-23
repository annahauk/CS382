#include <stdio.h>

/*
   Your name and honor code
   State the sorting algorithm you chose in task 3
   State if you want to be considered for bonus points in task 3
*/

void copy_str(char* src, char* dst) {
    /* Your code here */
    int index=0;
    checkIfDone: if (src[index]==0)
                     goto done;
                 dst[index]=src[index];
                 index++;
                 goto checkIfDone;
    done:        dst[index]=src[index];
}

int dot_prod(char* vec_a, char* vec_b, int length, int size_elem) {
    /* Your code here
       Do not cast the vectors directly, such as
       int* va = (int*)vec_a;
    */

    // check first if length or size_elem
    //  
    if (length <= 0)
    {
        return 0;
    }
    if (size_elem<=0)
    {
        return 0;
    }

    int elementCounter = 0;
    int valueA;
    int valueB;
    int byteCounter;
    int dotProduct = 0;
    unsigned char byte;

    outer_loop:     valueA = 0;
                    byteCounter = 0;

   // to convert each byte back an integer, just treat
   // each char as an unsigned 
   fetch_value_a:   byte = (unsigned char)(vec_a[byteCounter+elementCounter*size_elem]);
                    valueA |= byte << (8 * byteCounter);
                    byteCounter++;
                    if (byteCounter!=size_elem)
                        goto fetch_value_a;

                    valueB = 0;
                    byteCounter = 0;
   fetch_value_b:   byte = (unsigned char)(vec_b[byteCounter+elementCounter*size_elem]);
                    valueB |= byte << (8 * byteCounter);
                    byteCounter++;
                    if (byteCounter!=size_elem)
                        goto fetch_value_b;

                    dotProduct += valueA * valueB;
                    elementCounter++;
                    if (elementCounter!=length)
                        goto outer_loop;
    done:
                    return dotProduct;
}

void sort_nib(int* arr, int length) {
    /* Your code here */
    /* using selection sort */
    
    int n = length*8;                                   // n = number of nibbles (each integer will have 8 nibbles)
    int i = 0;                                          // outer loop index for selection sort
    int j = 0;                                          // inner min value finding loop index
    int min_index = 0;                                  // index of smallest element in the unsorted part of the array
    unsigned char i_nibble;                             // temporary storage for nibble at index i
    unsigned char j_nibble;                             // temporary storage for nibble at index j
    unsigned char min_index_nibble;                     // temporary storage for nibble at min_index in case need to swap
    unsigned char* byte_ptr = (unsigned char *)arr;     // a convenience pointer so we can refer to specific bytes within the array
                                                        // of integers

    // if length is non-sensical, i.e. less than 1, then just return and leave
    // the input array (if any), unsorted, i.e. don't do anything
    if (length < 1)
    {
        return;
    }
    // this code is an adaptation of the selection sort algorithm
    // at https://www.geeksforgeeks.org/selection-sort/
    // with the nuance that the indexes are referring to nibble positions
    // in the integers with index i and j and min_index.

                          i=0;
    outer_loop:           if (i==n-1)
                              goto repack_ints_in_little_endian;

                          min_index = i;
                          j = i + 1;
    loop_for_finding_min: if (j==n)
                              goto exit_finding_min;
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
                          else
                          {
                              j_nibble = byte_ptr[j/2] & 0x0f;
                          }

                          // read in the nibble at index min_index
                          if (min_index % 2 == 0)
                          {
                              min_index_nibble = (byte_ptr[min_index/2] & 0xf0) >> 4;
                          }
                          else
                          {
                              min_index_nibble = byte_ptr[min_index/2] & 0x0f;
                          }
                          if (j_nibble < min_index_nibble)
                          {
                              min_index = j;
                          }
                          ++j;
                          goto loop_for_finding_min;

    exit_finding_min:     if (min_index != i)
                          {
                             // means a smaller nibble was found so swap them
                             // read nibble at i
                             if (i % 2 == 0)
                             {
                                 i_nibble = (byte_ptr[i/2] & 0xf0) >> 4; 
                             }
                             else
                             {
                                i_nibble = byte_ptr[i/2] & 0x0f;
                             }
                             // read nibble at min_index
                             if (min_index % 2 == 0)
                             {
                                min_index_nibble = (byte_ptr[min_index/2] & 0xf0) >> 4;
                             }
                             else
                             {
                                 min_index_nibble = byte_ptr[min_index/2] & 0x0f;
                             }
                             // set nibble at i to min_index_nibble
                             if (i % 2 == 0)
                             {
                                 byte_ptr[i/2] = (byte_ptr[i/2] & 0x0f) | ((min_index_nibble << 4) & 0xf0);
                             }
                             else
                             {
                                 byte_ptr[i/2] = (byte_ptr[i/2] & 0xf0) | (min_index_nibble & 0x0f);
                             }
                             // set nibble at min_index to i_nibble
                             if (min_index % 2 == 0)
                             {
                                 byte_ptr[min_index/2] = (byte_ptr[min_index/2] & 0x0f) | ((i_nibble << 4) & 0xf0);
                             }
                             else
                             {
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
    repack_ints_in_little_endian: i=0;                               // index of first integer
    repack_loop:                  if (i==length)
                                      goto done;
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

    char str1[] = "382 is the best!";
    char str2[100] = {0};

    copy_str(str1,str2);
    puts(str1);
    puts(str2);

    /**
     * Task 2
     */

    int vec_a[3] = {-2, 34, 10};
    int vec_b[3] = {10, 20, 30};
    int dot = dot_prod((char*)vec_a, (char*)vec_b, 3, sizeof(int));
    
    printf("%d\n",dot);

    /**
     * Task 3
     */

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
    return 0;
}
