Orgasm - a Ruby (dis)?assembler library (NOT a (dis)?assembler FOR Ruby, a (dis)?assembler IN Ruby)
===================================================================================================

Well, tonight I worked a bit on this and it's coming out pretty cool, here's a partial usage

```ruby
>> require 'orgasm'; require 'orgasm/arch/x87'
true
>> (Orgasm::Architecture.x86[8086].disassembler | Orgasm::Architecture.x87[8087].disassembler).do("\xc1\x83\x00\x36\xd9\xf0")
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 0x36, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler | Orgasm::Architecture.x87[8087].disassembler).do("\xc1\x83\x00\x36\xd9\xf0")
[
    [0] #<Instruction(add): #<Register: eax, 32 bits>, #<Immediate: 0x36, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler | Orgasm::Architecture.x87[8087].disassembler).do("\xc1\x66\x83\x00\x36\xd9\xf0")
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 0x36, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler).do("\xc1\x66\x83\x00\x36\xd9\xf0")
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 0x36, 8 bits>>,
    [1] #<Unknown(2): D9 F0> 
]
]
>> (Orgasm::Architecture.x87[8087].disassembler).do("\xc1\x66\x83\x00\x36\xd9\xf0")
[
    [0] #<Unknown(5): C1 66 83 00 36>,
    [1] #<Instruction(f2xm1)>
]
```

The disassembler returns Base objects that then are styled by various styles, so the data
that goes around is always the same.

The assembler will create binary stuff directly from those objects, so if everything's right
passing a shellcode in to the disassembler and passing the result to the assembler should give
out the same string.
