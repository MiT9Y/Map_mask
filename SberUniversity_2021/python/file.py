#f = open('test.txt', 'r')
#for line in f: print(line, end = '')
#f.close()

#f = open('test.txt', 'a')
#for i in range(1, 4):
#        f.write(str(i) + '\n')
#f.close()

def email_gen(list_of_names):
    emails = []
    for i in list_of_names:
        letter = 1
        while i[1] + '.' + i[0][0:letter] + '@company.io' in emails:
            letter+=1
        emails.append(i[1] + '.' + i[0][0:letter] + '@company.io')
    return emails

print(email_gen([['Ivan', 'Petrov']]))

f = open('task_file.txt', 'r')
titel = f.readline()[:-1].replace(' ', '').split(',')
input_lst = []
for line in f:
	input_lst.append(line[:-1].replace(' ', '').split(','))
f.close()

for v in input_lst:
	if len(v) < 5: continue
	if v[1] == '' or v[2] == '' or v[3] == '' or v[4] == '': continue
	if not(v[3].isdigit() and len(v[3]) == 7): continue
	v[0] = email_gen([[v[1], v[2]]])[0]
f = open('task_file_new.txt', 'w')
f.write(', '.join(titel) + '\n')
for v in input_lst:
	f.write(', '.join(v) + '\n')
f.close()
