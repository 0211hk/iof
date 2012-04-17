#!/usr/local/bin/io -
Obj := Object clone do(
    m := method(bl,
        bl type println
        e := try(
            doMessage(bl)
        )
        e catch(Exception,
            writeln("error")
        )
    )
)

o := Obj clone
o m(block(
    Exception raise("generic foo exception")
))
