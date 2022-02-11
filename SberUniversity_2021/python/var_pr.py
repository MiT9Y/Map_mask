null_variable = None 
not_null_variable = 'something' 
if null_variable == None: 
    print('null_variable is None') 
else: 
    print('null_variable is not None') 
if not_null_variable == None: 
    print('not_null_variable is None') 
else: 
    print('not_null_variable is not None')

a = 10
b = 10
print(a < b)
print(a > b)
print(a == b)
print("")

print(type(None))
print(type(True))
print(type(False))
print(type([100, 200, 300]))
print(type(1))
print(type(5.3))
print(type(5 + 4j))
print(type([1, 5.3, False, 4]))
print(type((1, True, 3, 5+4j)))
print(type(range(5)))
print(type('Hello'))
print(type(b'a'))
print(type(bytearray([1,2,3])))
print(type(memoryview(bytearray('XYZ', 'utf-8'))))
print(type({'a', 3, True}))
print(type(frozenset({1, 2, 3})))
print(type({'a' : 32}))