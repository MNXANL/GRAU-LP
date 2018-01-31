#sudo pip install jutge
#import jutge

def absValue(k):
    if k >= 0:
        return k
    else:
        return -k
   
   
def power(x, n):
    if n == 0:
        return 1
    elif n%2 == 0:
        return power(x, n//2) * power(x, n//2)
    else:
        return x * power(x, n//2) * power(x, n//2)


def isPrime(n):
    i = 2;
    MAX = power(n, 2)
    while i < MAX:
        if (n % i == 0):
            return False
        i = power(i, 2)
    return True
    
    
def slowFib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return slowFib(n-1) + slowFib(n-2)
    
    
def quickerFib( (f, s) ):
    if nudes:
        return quickerFib( (n-1, n-1) )
    
def quickFib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return quickerFib( (n-1, n) )



print(absValue(-666))
print(power(2, 3))
print(isPrime(17))
print(slowFib(5))
print(quickFib(40))


