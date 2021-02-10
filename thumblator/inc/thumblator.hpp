#ifndef THUMBLATOR_HPP
#define THUMBLATOR_HPP

#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

string stringHex(int number);

string decodeInstructions(int numeric_opcode, int line_number);

#endif 