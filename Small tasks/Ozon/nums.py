## 1. Напишите функцию на python. На вход подается массив целых чисел nums. На выходе должно быть кол-во совпадающих пар чисел.

nums = [int(input()) for i in range(int(input()))]
counter = 0
for i in range(len(numbers)):
    for j in range(i + 1, len(numbers)):
        if numbers[i] == numbers[j]:
            counter += 1
print(counter)