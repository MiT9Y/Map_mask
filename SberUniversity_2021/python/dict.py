src = {'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5}
#dict_el_name = input()
dict_el_name = 'c'
print('1 -', src.get(dict_el_name))

src = {'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5}
dict_el_val = 5
for k, v in src.items():
	if v == dict_el_val:
		print('2 -', k)
		break
else: print('2 - None')

src = ['abc', 'bcd', 'abc', 'abd', 'abd', 'dcd', 'abc']
c_dict = {}

for str in src:
	c_dict.update({str:c_dict.get(str, 0) + 1})
print('3 -', list(c_dict.values()))