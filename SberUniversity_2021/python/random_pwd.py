from random import *
from chk_pwd import *

def get_pwd(pwd_len):
	res = ''
	src = ['1234567890', 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '!@#$%^&*()-+']
	for i in range(len(src)):
		res += choice(src[i])
	if type(pwd_len) != int: pwd_len = 12
	if pwd_len < 12: pwd_len = 12
	pwd_len -= len(src)
	while pwd_len > 0:
		res += choice(src[randrange(len(src))])
		pwd_len -= 1
	return res

pwd = get_pwd(32)
print(pwd)
chk_pwd(pwd)
