str = 'Abraсadabra'

print('1 - ' + str[2])
print('2 - ' + str[len(str) - 2])
print('3 - ' + str[0:5])
print('4 - ' + str[0:len(str) - 2])

print('5 - ', end = '')
for i in range(0, len(str)):
	if (i % 2 == 0): print(str[i], end = '')
print('')

print('6 - ', end = '')
for i in range(0, len(str)):
	if (i % 2 != 0): print(str[i], end = '')
print('')

print('7 - ', end = '')
for i in range(0, len(str)):
	print(str[len(str) - i - 1], end = '')
print('')

print('8 - ', end = '')
for i in range(0, len(str)):
	if (i % 2 == 0): print(str[len(str) - i - 1], end = '')
print('')

print('9 -', len(str))

print('')
print('--------')
s = "a1 2b  3   abc d3e r2D2"
arr = s.split(' ')
i = 0
while i < len(arr):
	if len(arr[i]) > 0:
		if arr[i][0].islower():
			arr[i] = arr[i][0].upper() + arr[i][1:]
	i += 1
s = ' '.join(arr)
print(s)

s = 'Testtttttttttt$tttttt2'
numb = '1234567890'
l_str = 'abcdefghijklmnopqrstuvwxyz'
u_str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
special = '!@#$%^&*()-+'
chk = [0, 0, 0, 0, 0]
if len(s) > 11: chk[0] = 1
for smb in s:
	if numb.find(smb) != -1: chk[1] = 1
	if l_str.find(smb) != -1: chk[2] = 1
	if u_str.find(smb) != -1: chk[3] = 1
	if special.find(smb) != -1: chk[4] = 1
if (sum(chk) == 5):
	print("Сильный пароль.")
else:
	print("Слабый пароль. Рекомендации:", end = '')
	sep = ''
	if chk[0] == 0:
		print(" увеличить число символов до 12 и более", end = '')
		sep = ','
	if chk[1] == 0:
		print(sep + " добавить 1 цифру", end = '')
		sep = ','
	if chk[2] == 0:
		print(sep + " добавить 1 строчную букву", end = '')
		sep = ','
	if chk[3] == 0:
		print(sep + " добавить 1 заглавную букву", end = '')
		sep = ','
	if chk[4] == 0: print(sep + " добавить 1 спецсимвол", end = '')
	print('')
