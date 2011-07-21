Orgasm - a Ruby (dis)?assembler library
====================================

Well, tonight I worked a bit on this and it's coming out pretty cool, here's a partial usage

```ruby
>> require 'orgasm'; require 'orgasm/arch/i386'
true
>> Orgasm::Architecture.i386.disassembler.disassemble("\x37\xD5\x0A\x00")
[
    [0] #<Instruction(aaa)>,
    [1] #<Instruction(aad)>,
    [2] #<Unknown(1): 00>
]
>> Orgasm::Architecture.i386.generator.do { xor eax, eax }
[
    [0] #<Instruction(xor): #<Register: eax, 32 bits>, #<Register: eax, 32 bits>>
]
```

The disassembler returns Base objects that then are styled by various styles, so the data
that goes around is always the same.

The assembler will create binary stuff directly from those objects, so if everything's right
passing a shellcode in to the disassembler and passing the result to the assembler should give
out the same string.
