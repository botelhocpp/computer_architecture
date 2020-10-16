build:
	nasm -f elf src/emailAddressFSM_$(arg).asm -o obj/emailAddressFSM_$(arg).o
	gcc -m32 obj/emailAddressFSM_$(arg).o -o bin/emailAddressFSM_$(arg)

clean:
	rm obj/emailAddressFSM_$(arg).o bin/emailAddressFSM_$(arg)
