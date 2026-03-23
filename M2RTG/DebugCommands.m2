restart

load "DebugTest.m2"

f(5, 0)

m
n

listLocalSymbols

return 17 --lets set v := 17 instead

listLocalSymbols

continue --keep going after stopped

---------
--try again, but instead of continue, lets do step 1 a couple times


-----------

g(3)
g(3)
g(3)
g(3)

listLocalSymbols

end --step out

listLocalSymbols

return 28

listLocalSymbols
q
u

step 1

q
u
listLocalSymbols

step 1
