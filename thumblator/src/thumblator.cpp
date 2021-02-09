#include "thumblator.hpp"

string stringHex(int number){
	string hex_string = "0000";
	int step = 3;
	while(number != 0){
		hex_string[step--] = (number % 0x10 <= 0x09) ? (number % 0x10) + 0x30 : (number % 0x10) + 0x57;
		number /= 0x10;
	}
	return hex_string;
}

void patternBlue(int numeric_opcode, string *opcode){
    *opcode += " r";
    *opcode += to_string(numeric_opcode & 0x7);
    *opcode += ", r";
    *opcode += to_string((numeric_opcode >> 3) & 0x7);
    *opcode += ", #";
    *opcode += to_string((numeric_opcode >> 6) & 0x1F);
}

void patternBlack(int numeric_opcode, string *opcode){
    *opcode += " r";
    *opcode += to_string(numeric_opcode & 0x7);
    *opcode += ", r";
    *opcode += to_string((numeric_opcode >> 3) & 0x7);
    *opcode += ", r";
    *opcode += to_string((numeric_opcode >> 6) & 0x7);
}

void patternRed(int numeric_opcode, string *opcode){
    *opcode += " r";
    *opcode += to_string((numeric_opcode >> 8) & 0x7);
    *opcode += ", #";
    *opcode += to_string(numeric_opcode & 0xFF);
}

string decodeInstructions(int numeric_opcode, int line_number){
    string opcode;
    switch((numeric_opcode >> 12) & 0xF){
    case 0x0:
        opcode = ((numeric_opcode >> 11) & 0x1) ? "LSR" : "LSL";
        patternBlue(numeric_opcode, &opcode);
        break;

    case 0x01:
        if ((numeric_opcode >> 11) & 0x1){
            opcode = ((numeric_opcode >> 9) & 0x1) ? "SUB" : "ADD";
            if ((numeric_opcode >> 10) & 0x1){
                opcode += " r";
                opcode += to_string(numeric_opcode & 0x7);
                opcode += ", r";
                opcode += to_string((numeric_opcode >> 3) & 0x7);
                opcode += ", #";
                opcode += to_string((numeric_opcode >> 6) & 0x7);
            }
            else{
                patternBlack(numeric_opcode, &opcode);
            }
        }
        else{
            opcode += "ASR";
            patternBlue(numeric_opcode, &opcode);
        }
        break;

    case 0x2:
        opcode = ((numeric_opcode >> 11) & 0x1) ? "CMP" : "MOV";
        patternRed(numeric_opcode, &opcode);
        break;

    case 0x3:
        opcode = ((numeric_opcode >> 11) & 0x1) ? "SUB" : "ADD";
        patternRed(numeric_opcode, &opcode);
        break;

    default:
        cout << "\033[1;37mThumblator:\033[0m \033[1;31mFatal error\033[0m: invalid instruction " << stringHex(numeric_opcode) << " at line " << line_number << ".\nAborting.\n";
        opcode.clear();
        return opcode;
    }
    opcode += '\n';
    return opcode;
}