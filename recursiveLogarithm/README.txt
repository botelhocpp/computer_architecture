Hello, I am Pedro Botelho.
This code is under the GNU Generic Public Lincense, feel free to use.
Here is my email: pedrobotelho15@alu.ufc.br

This is a simple program that will calculate the logarithm at base 2 of a number x. Let's first look at the mathematical formula for the logarithm: 

log2(x) = y, and we can also write this as 2^y = x.

The procedure of this program that calculates the logarithm is recursive. A tip for building recursive programs is: first do the iterative one, right? But making recursive assembly code is not easy, so let's first look at iterative C ++ code:

int iterativeLogarithm(int x){
    int i{0}; 
    while(x > 1){
        x /= 2;
        i++;
    }
    return i;    
}

Very simple, the simplest I got. First remember that:

log2 (2) = 1 that log2 (1) = 0.

We can find the logarithm in some ways, such as by deduction with exponentiation. We will abuse the CPU and its ability to do various operations in a very short time. For example, log2 (8) = 3, ok?

Check that if we divide 8 by the base (2) and count each division, until it gets smaller than the base itself, we will have an exact value.

8/2 = 4, count = 1
4/2 = 2, count = 2
2/2 = 1, count = 3

In the case of the program we have a counter i that increases each time this division is made (until it reaches 1, because 2^0 is one, so 2^(1 + 1 + 0) = 2^3).

Why (x > 1)? Because log2 (2) = 1, so it is still valid in the previous logic.

Then, making it recursive we have this:

int recursiveLogarithm(int x){
    if(x < 2) return 0;
    return 1 + recursiveLogarithm(x/2);
}

We have (x < 2) as our base case, which returns 0 for recursion, and when that happens, 1 is added to each recursion, which always returns x/2, returning this sum. 

Why (x < 2)? Because log2 (1) = 0, so return 0 as the result.

As for the assembly code...

        PUSH EBP
	MOV  EBP, ESP   
 	MOV  EAX, [EBP+8]
 	
	CMP  EAX, 2
	JA   RECURSIVE_CALL
	CMP  EAX, 1
	MOV  EAX, 0
	JMP  RECURSIVE_RETURN
	
RECURSIVE_CALL:
	DIV  DWORD[constant_two]
	PUSH EAX
	CALL CALC_LOG
	
RECURSIVE_RETURN:
	MOV  EBX, [EBP+8]
        JBE  QUIT
	ADD  EAX, 1 
	
QUIT:       
	MOV  ESP, EBP
	POP  EBP
	RET  4
	
This gets better as we continue...
We have a stack frame maneuver at the start and at the end... Then we get the parameter and move it to EAX.... we check the base case (x < 2), then verify if EAX is one of bellow, so the Log2 must me zero. Otherwise it divides the parameter by two, and recursive-call the procedure... At the end, we absuse of the "recursive cleaner" as I call it. The RET instruction will return every recursive call, so, every one is a count increase, as our logarithm. You can have a better view in the .asm code.

Then a question... Why, by a instance, log2(7) return "Seg. fault", and log2(3) return 0... Well, it is only for even AND multiples of 2(preferably) and it must return a integer, because is a count.

You can execute it by ./bin/recursiveLogarithm, as you might know...   
