# Piplined_Processor 
## <img align= center width=30px height=30px src="https://github.com/AhmedSamy02/Adders-Mania/assets/88517271/dba75e61-02dd-465b-bc31-90907f36c93a"> Table of Contents

- [Overview](#overview)
- [Design](#des)
- [ISA](#isa)
- [Control Signals](#cs)
- [Contributors](#contributors)
- [License](#license)


## <img src="https://github.com/AhmedSamy02/Adders-Mania/assets/88517271/9ed3ee67-0407-4c82-9e29-4faa76d1ac44" width="30" height="30" /> Overview <a name = "overview"></a>
The processor in this project has a RISC-like instruction set architecture. There are eight 4-byte general purpose registers; R0, to R7. Another two specific registers, One works as a program counter (PC). The other works as a stack pointer (SP); and hence; points to the top of the stack. The initial value of SP is  (2^12-1). The memory address space is 4 KB of 16-bit width and is word addressable. ( N.B.  word = 2 bytes). The data bus between memory and the processor is 16-bit widths for instruction memory and 32-bit widths for data memory.

When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that have already entered the pipeline), then the address of the next instruction (in PC) is saved on top of the stack, and the PC is loaded from address [2-3] of the memory (the address takes two words). To return from an interrupt, an RTI instruction loads the PC from the top of the stack, and the flow of the program resumes from the instruction after the interrupted instruction.

## <img src="https://github.com/YaraHisham61/OS_Scheduler/assets/88517271/41cd74fb-7e37-492e-b15d-5f54bccfd43e" width="30" height="30" /> Design <a name = "des"></a>
![image](https://github.com/YaraHisham61/Architecture_Project/assets/88517271/e8f7adfd-3df4-4438-931e-103b67efc4b6)
## <img src="https://github.com/YaraHisham61/Architecture_Project/assets/88517271/d375f35d-9e7d-474f-96ce-a51c610a9f31" width="30" height="30" /> ISA <a name = "isa"></a>

* Zero operand instructions
  
   Instruction | Opcode     | 
   ----------- | ---------- |
    NOP        |	000-0000  |
    RET	       |  000-1000  |
    RLT –flag restore	| 000-1001
  
* One register instructions
  
  Instruction | Opcode     | 
   ---------- | ---------- |
    NOT       | 001-0000   |
    INC       | 001-0001   |
    DEC       | 001-0010   |
    NEG       | 001-0011   |
    OUT       | 001-0100   |
    IN        | 001-0101   |
    POP       | 001-0110   |
    PUSH      | 001-0111   |
    PROTECT   | 001-1011   |
    FREE      | 001-1010   |
    JZ        | 001-1100   |
    CALL      | 001-1110   |
    JMP       | 001-1101   |

* Two registers instructions
  
   Instruction | Opcode     | 
   ----------- | ---------- |
    SWAP       |  010-1111  |
    CMP        |  010-1110  |
  
* Three registers instructions
   Instruction | Opcode     | 
   ---------- | ---------- |
    ADD       | 011-0001   |
    SUB       | 011-0010   |
    AND       | 011-0011   |
    OR        | 011-0100   |
    XOR       | 011-0101   |

* Two registers and immediate instruction
     Instruction | Opcode     | 
   ---------- | ---------- |
    ADDI       | 110-0000   |

* One registers and immediate instruction
    
    Instruction | Opcode     | 
     ---------- | ---------- |
    BITSET    | 101-0000   |
    LDM       | 101-1111   |
    RCL       | 101-1101   |
    RCR       | 101-1100   |
    LDD       | 101-1110   |
    STD       | 101-0001   |

## <img src="https://github.com/YaraHisham61/Architecture_Project/assets/88517271/b53860f2-b404-41d5-ae7e-0833f1e49159" width="30" height="30" /> Control Signals <a name = "cs"></a>

| Instruction         | mem_read | immediate_value | branch | mem_write | reg_write1 | reg_write2 | reg_read1 | reg_read2 | reg_read3 | stack_read | stack_write | protectAfree | protectOfree | inOout | inAout | alu_op |
|----------------------|----------|------------------|--------|-----------|------------|------------|-----------|-----------|-----------|-------------|-------------|--------------|--------------|--------|--------|--------|
| NOP                  | 0        | 0                | 0      | 0         | 0          | 0          | 0         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 0      | 0000   |
| NOT  Rdst            | 0        | 0                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 0      | 0001   |
| NEG Rdst             | 0        | 0                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 0      | 0010   |
| INC  Rdst            | 0        | 0                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 0      | 0011   |
| DEC  Rdst            | 0        | 0                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 0      | 0100   |
| OUT  Rdst            | 0        | 0                | 0      | 0         | 0          | 0          | 0         | 0         | 0         | 0           | 0           | 0            | 1            | 1      | 0000   | 0      |
| IN  Rdst             | 0        | 0                | 0      | 0         | 1          | 0          | 0         | 0         | 0         | 0           | 1           | 0            | 1            | 0      | 0000   | 0      |
| SWAP Rsrc, Rdst      | 0        | 0                | 0      | 0         | 1          | 1          | 1         | 1         | 0         | 0           | 0           | 0            | 0            | 0      | 0101   | 0      |
| ADD Rdst, Rsrc1, Rsrc2 | 0      | 0                | 0      | 0         | 1          | 0          | 1         | 1         | 1         | 0           | 0           | 0            | 0            | 0      | 0110   | 0      |
| ADDI Rdst, Rsrc1, Imm | 0       | 1                | 0      | 0         | 1          | 0          | 1         | 1         | 0         | 0           | 0           | 0            | 0            | 0      | 0110   | 0      |
| SUB  Rdst, Rsrc1, Rsrc2 | 0      | 0                | 0      | 0         | 1          | 0          | 1         | 1         | 1         | 0           | 0           | 0            | 0            | 0      | 0111   | 0      |
| AND  Rdst, Rsrc1, Rsrc2 | 0      | 0                | 0      | 0         | 1          | 0          | 1         | 1         | 1         | 0           | 0           | 0            | 0            | 0      | 1000   | 0      |
| OR Rdst, Rsrc1, Rsrc2 | 0       | 0                | 0      | 0         | 1          | 0          | 1         | 1         | 1         | 0           | 0           | 0            | 0            | 0      | 1001   | 0      |
| XOR Rdst, Rsrc1, Rsrc2 | 0      | 0                | 0      | 0         | 1          | 0          | 1         | 1         | 1         | 0           | 0           | 0            | 0            | 0      | 1010   | 0      |
| CMP Rsrc1, Rsrc2     | 0        | 0                | 0      | 0         | 0          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 1011   | 0      |
| BITSET Rdst, Imm     | 0        | 1                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 1100   | 0      |
| RCL Rsrc, Imm       | 0        | 1                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 1101   | 0      |
| RCR Rsrc, Imm       | 0        | 1                | 0      | 0         | 1          | 0          | 1         | 0         | 0         | 0           | 0           | 0            | 0            | 0      | 1110   | 0      |
| PUSH  Rdst          | 0        | 0                | 0      | 1         | 0          | 0          | 1         | 0         | 0         | 1           | 0           | 0            | 0            | 0     



  
## <img src="https://github.com/YaraHisham61/OS_Scheduler/assets/88517271/859c6d0a-d951-4135-b420-6ca35c403803" width="30" height="30" /> Contributors <a name = "contributors"></a>
<table>
  <tr>
   <td align="center">
    <a href="https://github.com/AhmedSamy02" target="_black">
    <img src="https://avatars.githubusercontent.com/u/96637750?v=4" width="150px;" alt="Ahmed Samy"/>
    <br />
    <sub><b>Ahmed Samy</b></sub></a>
    </td>
   <td align="center">
    <a href="https://github.com/kaokab33" target="_black">
    <img src="https://avatars.githubusercontent.com/u/93781327?v=4" width="150px;" alt="Kareem Samy"/>
    <br />
    <sub><b>Kareem Samy</b></sub></a>
    </td>
    
   <td align="center">
    <a href="https://github.com/nancyalgazzar" target="_black">
    <img src="https://avatars.githubusercontent.com/u/94644017?v=4" width="150px;" alt="Nancy Ayman"/>
    <br />
    <sub><b>Nancy Ayman</b></sub></a>
    </td>
   <td align="center">
    <a href="https://github.com/YaraHisham61" target="_black">
    <img src="https://avatars.githubusercontent.com/u/88517271?v=4" width="150px;" alt="Yara Hisham"/>
    <br />
    <sub><b>Yara Hisham</b></sub></a>
    </td>
  </tr>
 </table>

 ## <img src="https://github.com/YaraHisham61/Architecture_Project/assets/88517271/c4a8b264-bf74-4f14-ba2a-b017ef999151" width="30" height="30" /> License <a name = "license"></a>
> This software is licensed under MIT License, See [License](https://github.com/YaraHisham61/Architecture_Project/blob/master/LICENSE)
