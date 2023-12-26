#include <bits/stdc++.h>
using namespace std;

vector<string> tokenize(string s, string del = " ")
{
    vector<string> v;
    int start, end = -1 * del.size();
    do
    {
        start = end + del.size();
        end = s.find(del, start);
        v.push_back(s.substr(start, end - start));
    } while (end != -1);
    return v;
}
string which_register(string s)
{
    if (s == "R0")
    {
        return "000";
    }
    else if (s == "R1")
    {
        return "001";
    }
    else if (s == "R2")
    {
        return "010";
    }
    else if (s == "R3")
    {
        return "011";
    }
    else if (s == "R4")
    {
        return "100";
    }
    else if (s == "R5")
    {
        return "101";
    }
    else if (s == "R6")
    {
        return "110";
    }
    else
    {
        return "111";
    }
}
string decToBin(int number)
{
    int n = (int)(log2(number));
    string bin = bitset<64>(number).to_string().substr(64 - n - 1);
    string zeros = "";
    for (int i = 0; i < 16 - bin.length(); i++)
    {
        zeros.append("0");
    }
    return zeros + bin;
}
int main()
{
    ifstream infile("program.txt");
    ofstream outFile("data.txt");
    string inst, str, additional;
    vector<string> regs;
    int instLen = 0, strLen = 0;
    while (getline(infile, str))
    {
        strLen = str.length();
        instLen = str.find_first_of(' ');
        inst = str.substr(0, instLen);
        if (strLen == 3)
        {
            if (inst == "NOP")
                outFile << "0000000000000000" << endl;
            else if (inst == "RET")
                outFile << "0001000000000000" << endl;
            else
                outFile << "0001001000000000" << endl;
        }
        else
        {
            additional = str.substr(instLen + 1);
            regs = tokenize(additional, ",");
            if (regs.size() == 1)
            {
                if (inst == "NOT")
                {
                    outFile << "0010000" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "INC")
                {
                    outFile << "0010001" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "DEC")
                {
                    outFile << "0010010" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "NEG")
                {
                    outFile << "0010011" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "OUT")
                {
                    outFile << "0010100" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "IN")
                {
                    outFile << "0010101" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "POP")
                {
                    outFile << "0010110" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "PUSH")
                {
                    outFile << "0010111" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "PROTECT")
                {
                    outFile << "0011011" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "FREE")
                {
                    outFile << "0011010" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "JZ")
                {
                    outFile << "0011100" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "CALL")
                {
                    outFile << "0011110" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "JMP")
                {
                    outFile << "0011101" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                }
            }
            else if (regs.size() == 3)
            {
                if (inst == "ADD")
                {
                    outFile << "0110001" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[2]) << endl;
                }
                else if (inst == "SUB")
                {
                    outFile << "0110010" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[2]) << endl;
                }
                else if (inst == "AND")
                {
                    outFile << "0110011" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[2]) << endl;
                }
                else if (inst == "OR")
                {
                    outFile << "0110100" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[2]) << endl;
                }
                else if (inst == "XOR")
                {
                    outFile << "0110101" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[2]) << endl;
                }
                else
                {
                    outFile << "1100000" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[2])) << endl;
                }
            }
            else
            {
                if (inst == "SWAP")
                {
                    outFile << "0101111" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "CMP")
                {
                    outFile << "0101110" << which_register(regs[0]) << which_register(regs[1]);
                    outFile << which_register(regs[0]) << endl;
                }
                else if (inst == "BITSET")
                {
                    outFile << "1010000" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
                else if (inst == "LDM")
                {
                    outFile << "1011111" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
                else if (inst == "RCL")
                {
                    outFile << "1011101" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
                else if (inst == "RCR")
                {
                    outFile << "1011100" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
                else if (inst == "LDD")
                {
                    outFile << "1011110" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
                else if (inst == "STD")
                {
                    outFile << "1010001" << which_register(regs[0]) << which_register(regs[0]);
                    outFile << which_register(regs[0]) << endl;
                    outFile << decToBin(stoi(regs[1])) << endl;
                }
            }
        }
    }
    return 0;
}
