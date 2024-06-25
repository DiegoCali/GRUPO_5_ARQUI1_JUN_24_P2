new_nums = [5, 6, 7, 8, 9]
# Read data
f = open('Tests/test.txt', 'r')
string = f.read()
f.close()
# Convert to array
array = string.split()
array.pop()
print(array)
# Add new numbers
for nums in new_nums:
    array.append(nums)
array.append('$')
# Write file
f = open('Tests/test.txt', 'w')
for data in array:
    f.write(str(data) + '\n')
f.close()
