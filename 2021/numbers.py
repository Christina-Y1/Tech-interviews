## 1. Напишите функцию на python. На вход подается массив целых чисел nums. На выходе должно быть кол-во совпадающих пар чисел.

n = int(input())
nums = [int(input()) for i in range(n)]
counter = 0
for i in range(len(nums)):
    for j in range(i + 1, len(nums)):
        if nums[i] == nums[j]:
            counter += 1
print(counter)