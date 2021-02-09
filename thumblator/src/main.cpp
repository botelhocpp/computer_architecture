#include "thumblator.hpp"

int main(int argc, char* argv[]){ 
    
    //CHECK PARAMETER QUANTITY
    if(argc > 3){
        cout << "\033[1;37mThumblator:\033[0m \033[1;31mFatal error\033[0m: too much parameters.\nAborting.\n";
        return 0;
    }
    else if(argc < 2){
        cout << "\033[1;37mThumblator:\033[0m \033[1;31mFatal error\033[0m: no input file.\nAborting.\n";
        return 0;
    }

    //OPEN FILE
    ifstream input_file(argv[1]);
    if(input_file.is_open()){

        //EXTENSION VERIFYING
        string input_file_name;
        input_file_name = argv[1];
        if(input_file_name.find(".in") == input_file_name.npos){
            cout << "\033[1;37mThumblator:\033[0m \033[1;31mFatal error\033[0m: invalid extension.\nAborting.\n";
            return 0;
        }

        //FILE TO STRING
        stringstream auxiliary_buffer;
        auxiliary_buffer << input_file.rdbuf();
        string source_code;
        source_code = auxiliary_buffer.str();

        //TRANSLATION PROCESS
        long unsigned int step = 0;
        short line_number = 0;
        long int numeric_opcode = 0;
        string opcode;
        while(step < source_code.size()){
            while(source_code[step] != '\n'){
                opcode += source_code[step++];
                if(step == source_code.size()){
                    break;
                }
            }
            numeric_opcode = strtol(opcode.c_str(), NULL, 16);
            opcode = decodeInstructions(numeric_opcode, ++line_number);
            if(opcode.empty()) return 0;
            source_code.replace(step, 1, ":  ");
            step += 2;
            source_code.replace(step, 1, opcode);
            step += opcode.size();
            opcode.clear();
        }

        //OUTPUT FILE PROPER CREATION
        source_code.replace(source_code.size() - 1, 2, "\0");
        ofstream output_file;
        if(argc == 2)
            output_file.open(input_file_name.replace(input_file_name.find(".in"), 3, ".out"));
        else
            output_file.open(argv[2]);
        output_file << source_code;

        //END OF TRANSLATION PROCESS
        output_file.close();
        input_file.close();
    }
    else{
        cout << "\033[1;37mThumblator:\033[0m \033[1;31mFatal error\033[0m: file doesn't exist.\nAborting.\n";
    }
    return 0;
} 