import math

def myLength(L):
	lng = 0
	for i in range (len(L)):
		lng = lng + 1
	return lng

def myMaximum(L):
	max = L[0]
	for i in range(len(L)):
		if L[i] > max:
			max = L[i]
	return max

def average(L):
	sum = 0
	for i in range(len(L)):
		sum = sum + L[i]
	return (sum/len(L))

def buildPalindrome(L1): return (list(reversed(L1)) +L1)



def remove(L, rm):
	return [i for i in L   if i not in rm]




def flatten(L):
	if isinstance(L, list):
		Lflat = []
		for l in (L):
			Lflat = Lflat + flatten(l)
		return Lflat
	else: 
		return [L]


def oddsNevens(L):
	fst = []
	snd = []
	for i in range(len(L)):
		if  L[i] % 2 == 1:
			fst.append(L[i])
		else:
			snd.append(L[i])
	return (fst, snd)




def isPrime(n):
    if n <= 1 :  return False
    if n == 2 :  return True
    if n%2 == 0:  return False
    for i in range(3, int(math.sqrt(n))+1, 2):
        if (n % i == 0):  return False
    return True
    
def primeDivisors(Num):
	L = []
	for x in range(1, Num+1, 1):
		if (Num % x == 0 and isPrime(x)): L.append(x)
	return L


