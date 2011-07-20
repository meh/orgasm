Orgasm - a Ruby (dis)?assembler library
====================================

Well, tonight I worked a bit on this and it's coming out pretty cool, here's a partial usage

```ruby
>> require 'orgasm/disassembler'; require 'orgasm/arch/i386/disassembler'
true
>> Orgasm::Disassembler.for('i386').disassemble("\x01\x03")
[
    [0] add ebx, eax
]
>> Orgasm::Style.current 'AT&T'
AT&T
>> Orgasm::Disassembler.for('i386').disassemble("\x01\x03")
[
    [0] addl %eax, %ebx
]
>> 
```

The disassembler returns Base objects that then are styled by various styles, so the data
that goes around is always the same.

The assembler will create binary stuff directly from those objects, so if everything's right
passing a shellcode in to the disassembler and passing the result to the assembler should give
out the same string.
