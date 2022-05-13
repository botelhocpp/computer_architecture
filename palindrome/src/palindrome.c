#include <string.h>

#include "palindromeC.h"

int isPalindrome(char *str) {
	int size = strlen(str);

	int j = 0;
	int i = size - 1;
	while(i >= size/2) {
		if(*(str + i) != *(str + j)) {
			return 0;
		}
		j++;
		i--;
	}

	return 1;
}