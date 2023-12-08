# I pledge my honor that I have abided by the Stevens Honor System.
#Anna Hauk
import sys
import os
import string

def usage():
    print("usage:")
    print("\tpython annaBinAnnasm.py assemblerSourcefile.s")

def write_ram_image(ram):
    with open("ram","wt") as f:
        print("v3.0 hex words addressed",file=f)
        for i in range(16):
            offset = (i*16).to_bytes(1,"big").hex()
            line = ""
            for j in range(16):
                b= ram[(i*16) + j].to_bytes(1,"big").hex()
                line = line + f" {b}"
            print(f"{offset}:{line}",file=f)

def write_rom_image(rom):
    with open("rom","wt") as f:
        print("v3.0 hex words addressed",file=f)
        for i in range(16):
            offset = (i*16).to_bytes(1,"big").hex()
            line = ""
            for j in range(16):
                b= rom[(i*16) + j].to_bytes(2,"big").hex()
                line = line + f" {b}"
            print(f"{offset}:{line}",file=f)

def get_int_value_list(valueString,size):
    vs=valueString.lower()
    if vs.startswith("0x"):
        return int(vs[2:],16).to_bytes(size,'big')
    else:
        return int(valueString).to_bytes(size,'big')

def get_size(directive,value):
    if directive=="byte":
        return 1
    if directive=="hword":
        return 2
    if directive=="word":
        return 4
    if directive=="skip":
        return int(value)
    if directive=="string":
        return len(value)+1

if __name__ == '__main__':
    if (len(sys.argv)!=2):
        usage()
        os._exit(0)

    inTextSection = False
    inDataSection = False
    dataAddress = 0
    instructionAddress = 0
    ram = [0] * 256
    rom = [0] * 256
    ram_label_map={}

    with open(sys.argv[1],"r") as f:
        for line in f:
            line = line.strip()
            if "//" in line:
                split_line = line.split("//")
                if (len(split_line)==1):
                    continue
                line = split_line[0].strip()
            if ".text" in line:
                inTextSection = True
                inDataSection = False
                continue
            if ".data" in line:
                inDataSection = True
                inTextSection = False
                continue

            if line == "":
                continue

            if inTextSection:
                print(line.strip())
                tokens=line.strip().split()
                instruction=tokens[0].strip().lower()
                if instruction=="ldr":
                    operands="".join(tokens[1:]).split(",")
                    register=int(operands[0].strip().lower()[1])
                    ra = "{0:02b}".format(register)
                    operand=operands[1].strip().lower()
                    if operand.startswith("#"):
                        # this is a register load immediate
                        operand=operand[1:]
                        opcode='000001'
                        if operand.startswith("0x"):
                            operand=int(operand[2:],16)
                        else:
                            operand=int(operand)
                    else:
                        # this is a register load from memory
                        opcode='000010'
                        if operand.startswith("0x"):
                            operand=int(operand[2:],16)
                        else:
                            operand=int(operand)
                    operand_bit_string = "{0:08b}".format(operand)
                    rom[instructionAddress]=int(opcode+ra+operand_bit_string,2)
                if instruction=="sub" or instruction=="add":
                    rt,ra,rb=["{0:02b}".format(int(o.strip().lower()[1])) for o in "".join(tokens[1:]).split(",")]
                    opcode = "000100" if instruction=="add" else "000101"
                    rom[instructionAddress]=int(opcode+ra+rb+rt+'0000',2)
                if instruction=="str":
                    operands="".join(tokens[1:]).split(",")
                    register=int(operands[0].strip().lower()[1])
                    ra = "{0:02b}".format(register)
                    operand=operands[1].strip().lower()
                    opcode='000011'
                    if operand.startswith("0x"):
                        operand=int(operand[2:],16)
                    else:
                        operand=int(operand)
                    operand_bit_string = "{0:08b}".format(operand)
                    rom[instructionAddress]=int(opcode+ra+operand_bit_string,2)
                instructionAddress=instructionAddress+1


            if inDataSection:
                line=line.split(":")
                label=line[0].strip()
                directive=line[1].split()[0].strip().lower()[1:]
                value=line[1].split()[1].strip()
                if directive == "string":
                    value = value[1:-1]
                    value=value.replace("\\","")
                ram_label_map[label]={
                    "address" : dataAddress,
                    "directive" : directive,
                    "size" : get_size(directive,value),
                    "valueString" : value
                }
                dataAddress=dataAddress+ram_label_map[label]["size"]

    for k in sorted(ram_label_map,key=lambda l: ram_label_map[l]["address"]):
        rlm=ram_label_map[k]
        address=rlm["address"]
        if rlm["directive"] in ["byte","hword","word"]:
            for offset,b in enumerate(get_int_value_list(rlm["valueString"],rlm["size"])):
                ram[address+offset]=int(b)
        if rlm["directive"] == "string":
            s=rlm["valueString"]
            for i,c in enumerate(s):
                ram[address+i]=ord(c)
            ram[address+i+1]=0

    write_ram_image(ram)
    write_rom_image(rom)
