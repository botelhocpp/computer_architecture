#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "palindromeC.h"

int main(void) {
	char buffer[1024];
	scanf("%s", buffer);
	char *input = malloc(strlen(buffer));
	strcpy(input, buffer);
	printf("%d\n", isPalindrome(input));
	free(input);
	return 0;
}