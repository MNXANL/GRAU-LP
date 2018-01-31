
# Function with default value
def f(x = 3):
    return x

# But such assignation only happens once!!!
def flist(x = [])
    x.append(3)
    return x

    
f(5)
f()     # In other words, f(3)


print( flist() ) # [3] 
print( flist() ) # [3, 3]  NANI!?

