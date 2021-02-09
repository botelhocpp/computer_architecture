#ifndef THUMBLATOR_HPP
#define THUMBLATOR_HPP

#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

void patternBlue(int numeric_opcode, string *opcode);

void patternBlack(int numeric_opcode, string *opcode);

void patternRed(int numeric_opcode, string *opcode);

string stringHex(int number);

string decodeInstructions(int numeric_opcode, int line_number);

#endif 