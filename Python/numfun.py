import math

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
    if n <= 1 :  return False
    if n == 2 :  return True
    if n%2 == 0:  return False
    for i in range(3, int(math.sqrt(n))+1, 2):
        if (n % i == 0):  return False
    return True
    
    
def slowFib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return slowFib(n-1) + slowFib(n-2)





#Not working as it should...
def quickFib(n):
    a, b = 0,1
    for i in range(n):
        a, b = b, a+b
    return a

# for i in range(20):
#     print(isPrime(i))
