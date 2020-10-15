# computer_architecture
Assembly language codes (*.asm), as well as documents of my own on the subject of "Computer Architecture and
Organization".

My name is Pedro Botelho, and I study Computer Engineering at the Federal University of Ceará, campus in Quixadá, here in Brazil. All of my codes can be found in English, being a virtually universal language (Esperanto is not a thing). All the content here was made based on the knowledge earned in the "Computer Architecture and Organization" course.

All content here complies with the "GNU General (or Generic, I dunno) Public Lincense" license, or at least in parts. Anyway, all content here can be reproduced, I just ask you to give me the minimum credit for the descriptions and explanations in text, and to learn from them. 

the organization of this repository is very simple (and dare I say, very organized too). Basically we have this README.md and another LICENSE file in the root folder of the directory, as well as the code folders (* .asm), those in "camelCase" to be cute. In the future, I want to explain about topics related to computer architecture. 

Each assembly project folder has 5 folders (to maintain organization and a standard) and two files.  

First, the "bin /" folder stores the binary files, that is, the executables (for Linux, of course). 

Then we have "doc /", where are the reports. Now that's odd ... This folder may have something, and maybe not ... Turns out most of these questions were asked for a test, so these have a detailed report, but the others don't ... Those that don't have a report will have a short but sufficient description in README.txt.

The "io_files /" folder has input and output files. Another case aside, this folder is useful in projects with a focus on system calls for reading and writing, or programs that do this in its scope at least, but to maintain the standard all folders have.

Then we have the "obj /" folder to store the object files (* .o). Here you ask me "why keep them?" and I answer "I don’t know, leave it like that, it’s cooler (and organized)".

Then we have "src /" to store the source code "* .asm". Simple as that, but the most important folder.

The "Makefile" is our friend for all hours. With a simple "make ..." you stop writing a lot. Each folder has its specific. It may be that some projects have more than one "file.asm" there, so in README.txt you will be specifying the correct way to compile. In general, just do a "make build". If you have any specifics, then "make build arg = condition".

The "README.txt" is more of an informative. It tells you the purpose of the program, how to use it, how to compile it, and will often upset the Windows crowd, warning that I don't have pre-compiled executables ... Forgive me, I use both, but Linux for certain things is better. For projects without a report it will be more "stuffed". For those who have a report it is more bland.
