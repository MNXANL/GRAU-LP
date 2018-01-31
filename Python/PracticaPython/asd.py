#!/usr/bin/python3



inp = input()

def wb2w(LS):
	ctr = 0;
	start = False
	ended = False
	for x in LS:

		if x == 'end':
			if  start:
				ended = True
			else:
				print('wrong sequence')
				break


		if start and not ended:	
			print(x)
			ctr += 1
		
		if x == 'beginning':
			if ended:
				print('wrong sequence')
				break
			else:
				start = True
	if (start and not ended):
		print('wrong sequence')
	else: print(ctr)	

		

		



wb2w(inp.split(' '))