Orgasm - a Ruby (dis)?assembler library (NOT a (dis)?assembler FOR Ruby, a (dis)?assembler IN Ruby)
===================================================================================================
Orgasm aims to be a library to easily work with real and virtual architectures.

It's designed in three different parts that do different things.

Disassembler
------------
The disassembler takes in a stream of opcodes (could be an array with hex values or simply a string extracted from
a binary) and gives back an array of Instruction objects.

A disassembler can be piped with another to get back a stream of instructions from both, for instance x86 and x87 are
two different architectures and to get the stream of a normal x86 binary you have to pipe both families of architectures.

Example:

```ruby
>> require 'orgasm'; require 'orgasm/arch/x87'
true
>> (Orgasm::Architecture.x86[8086].disassembler | Orgasm::Architecture.x87[8087].disassembler).do(%w(c1 83 c0 2a d9 f0))
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 42, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler | Orgasm::Architecture.x87[8087].disassembler).do(%w(c1 83 c0 2a d9 f0))
[
    [0] #<Instruction(add): #<Register: eax, 32 bits>, #<Immediate: 42, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler | Orgasm::Architecture.x87[8087].disassembler).do(%w(c1 66 83 c0 2a d9 f0))
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 42, 8 bits>>,
    [1] #<Instruction(f2xm1)>
]
>> (Orgasm::Architecture.x86[:i386].disassembler).do(%w(c1 66 83 c0 2a d9 f0))
[
    [0] #<Instruction(add): #<Register: ax, 16 bits>, #<Immediate: 42, 8 bits>>,
    [1] #<Unknown(2): D9 F0>
]
]
>> (Orgasm::Architecture.x87[8087].disassembler).do(%w(c1 66 83 c0 2a d9 f0))
[
    [0] #<Unknown(5): C1 66 83 00 2a>,
    [1] #<Instruction(f2xm1)>
]
```

Generator
---------
The generator implements a DSL to generate in a readable way the stream of Instruction objects.

It follows the Intel syntax as close as possible.

The aim of the generator is to make easy the assembling part.

Example:

```ruby
>> require 'orgasm'; require 'orgasm/arch/x86'
true
>> r = Orgasm::Architecture.x86[8086].generator.do {
     data {
       lol :word
     }

     macros {
       inc_and_check {|what|
         inc m(what)
         cmp m(what), 23
       }
     }

     mov m(:lol), 0

     label :again
     inc_and_check(:lol)
     jnl l(:again)

     call e(:exit)
   }
[
    [0] #<Instruction(mov): #<Address: 0x0, 16 bits>, 0>,
    [1] #<Label: again>,
    [2] #<Instruction(inc): #<Address: 0x0, 16 bits>>,
    [3] #<Instruction(cmp): #<Address: 0x0, 16 bits>, 23>,
    [4] #<Instruction(jnl): #<Label: again>>,
    [5] #<Instruction(call): #<Extern: exit>>
]
>> r.data
{
    :lol => #<Address: 0x0, 16 bits>
}
```

Assembler
---------
The assembler takes in an array of Instruction objects and converts them to a stream of opcodes.

Notes
-----
If you want better performances, install `ffi-inliner`.
