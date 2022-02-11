def chk_pwd(s):
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
	return