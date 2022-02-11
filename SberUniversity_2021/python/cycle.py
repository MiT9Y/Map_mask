print('-----')
var = 1
while var < 14:
	print(var, end = ' ')
	var += 1

print('')
print('')
print('-----')
var = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
for i in var:
	print(i, end = ' ')

print('')
print('')
print('-----')
for i in range(1,14):
    print(i, end=' ')

print('')
print('')
print('-----')
for var in 'Python':
    if var == 'h':
        continue
    print(var, end=' ')

print('')
print('')
print('-----')
for var in 'Python':
    if var == 'h':
        break
    print(var, end=' ')

print('')
print('')
print('-----')
for var in 'Python':
    if var == 'a':
        break 
else:
    print('Символа a нет в слове Python')

print('')
print('')
print('-----')
var = [758, 483, 893, 393, 293, 292, 292, 485, 828, 182]
sum = 0
for i in var:
	sum +=i
print(sum)

print('')
print('')
print('-----')
var = [8, 4, 0, 3, 9, 2, 3, 0]
sum = 0
for i in var:
	if i == 0:
		sum += 1
print(sum)

print('')
print('')
print('-----')
n = 9
i = 1
while i <= n:
	j = 1
	while j <= i:
		print(j, end = '')
		j += 1
	print('')
	i +=1

print('')
print('')
print('-----')
n = 6
i = 1
while i <= n:
	for s in range(0, ((n * 2 - 1) - (i * 2 - 1)) // 2):
		print(" ", end = '')
	j = 1
	while j < i:
		print(j, end = '')
		j += 1
	while j > 0:
		print(j, end = '')
		j -= 1
	print('')
	i +=1

print('')
print('')
print('-----')
n = 9
i = 1
while i <= n:
	for s in range(0, ((n * 2 - 1) - (i * 2 - 1)) // 2):
		print(" ", end = '')
	j = 1
	while j < i:
		print(j, end = '')
		j += 1
	while j > 0:
		print(j, end = '')
		j -= 1
	print('')
	i +=1
i -= 2
while i > 0:
	for s in range(0, ((n * 2 - 1) - (i * 2 - 1)) // 2):
		print(" ", end = '')
	j = 1
	while j < i:
		print(j, end = '')
		j += 1
	while j > 0:
		print(j, end = '')
		j -= 1
	print('')
	i -=1

print('')
print('')
print('-----')
n = 9
i = 1
while i <= n:
	print(" " * (n - i), end = '')
	j = 1
	while j <= i:
		print(j, end = '')
		j += 1
	print('')
	i +=1
i -= 1
while i > 0:
	print(" " * n, end = '')
	j = i
	while j > 0:
		print(j, end = '')
		j -= 1
	print('')
	i -=1
