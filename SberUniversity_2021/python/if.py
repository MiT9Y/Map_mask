a = 10
b = 20

if a > b:
	print('a больше b')
	print(b)
elif a < b:
	print('a меньше b')
	print(a)
else:
	print('a равно b')
	print(a)

a = [-5, -3, -3]
print("----------")
if a[0] <= a[1] and a[0] <= a[2]: print(a[0])
elif a[1] <= a[2]: print(a[1])
else: print(a[2])
print("")

#Входные данные: 10, 5, 10. Выходные данные: 2 
#Входные данные: 17, 17, -9. Выходные данные: 2 
#Входные данные: 4, -82, 0. Выходные данные: 0
#Входные данные: 100, 100, 100. Выходные данные: 3
a = [100, 100, 100]
print("----------")
if a[0] == a[1] and a[0] == a[2]: print(3)
elif a[0] == a[1] or a[1] == a[2] or a[0] == a[2]: print(2)
else: print(0)

#input()