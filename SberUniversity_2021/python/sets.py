src = [1, 1, 1, 1, 1]
set_src = frozenset(src)
print('1 -', len(set_src))

src_1 = [1, 2, 3, 4, 5, 6, 7]
src_2 = [10, 2, 3, 4, 8]
d_src_1 = frozenset(src_1)
d_src_2 = frozenset(src_2)
print('2 -', len(d_src_1.intersection(d_src_2)))

src_1 = {1, 10, 223, 413, 2}
src_2 = {1, 10, 223, 413, 2}
inter_set = src_2.intersection(src_1)
if len(inter_set) < len(src_1):
	print('3 - False')
elif len(src_1) == len(src_2):
	print('3 - False')
else: print('3 - True')
