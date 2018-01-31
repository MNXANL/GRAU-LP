#sudo pip install jutge
import jutge

#def factorial(n):
#   if n == 0:
#       return 1
#   else:
#       return n * factorial(n-1)

#def factorial(n):
#    f = 1
#    i = 2
#    while i <= n:
#        f *= i
#        i += 1
#    return f


def factorial(n):
    f = 1
    for i in range(2, n):
        f *= i
    return f


k = jutge.read(int)
while k is not None:
    print("*** FACTORIAL *** ")
    print(factorial(k))
    k = jutge.read(int)


#list(map(lambda x: 3*x, [1, 2, 3, 4, 5, [6], 7, 8, 9, 10]))
