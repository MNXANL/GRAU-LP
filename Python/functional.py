

def fib(n):
    if (n<2):
        return n
    else:
        return fib(n-1) + fib(n-2)
    

# Functional DP
def memory(f):
    dict = {}    #Empty dictionary
    def getValueInDict(x):   #Is the value stored on the dictionary?
        if x in d:           # YES! Return it
            return d[x]
        else:                # NO! Calculate, store and return that value 
            r = f(x)
            d[x] = r
            return r
        return f(x)
    return getValueInDict


fib = memo(fib)

print(fib(10))  # Calculates FIB from [0..10]
print(fib(20))  # Calculates FIB from [10..20]
print(fib(30))  # Calculates FIB from [20..30]
print(fib(40))  # Calculates FIB from [30..40]
print(fib(50))  # Calculates FIB from [40..50]
                # The rest of values are obtained from the dictionary -> gotta go fast!

"""
How is it made in Haskell?:

v n = [i -> f i | i = 1..n]

fib 0 = 0
fib 1 = 1
fib n = v (n-1) + v (n-2)
"""
