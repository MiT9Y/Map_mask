lst = [90, 45, 3, 43]
n_lst = [v for i, v in enumerate(lst) if i % 2 == 0]
print('1 -', n_lst)

lst = [1, 5, 1, 5, 1]
n_lst = []
if len(lst) > 0:
	for i in range(1, len(lst)):
		if (lst[i] > lst[i - 1]):
			n_lst.append(lst[i])
print('2 -', n_lst)

lst = [-5, 5, 10]
i_min = lst.index(min(lst))
i_max = lst.index(max(lst))
v = lst[i_min]
lst[i_min] = lst[i_max]
lst[i_max] = v
print('3 -', lst)