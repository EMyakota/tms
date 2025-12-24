#5. Напишите программу, которая выводит на экран результат вычисления 2+2.
print(2 + 2);

#6. Напишите программу, которая запрашивает у пользователя его имя и 
# выводит на экран сообщение "Привет, [имя]!".
name = input("Enter your name ")
print (f"Привет, {name}")

#7. Напишите программу, которая выводит на экран числа от 1 до 10
for i in range(1,11):
    print(i)

#8. Напишите программу, которая запрашивает у пользователя его возраст
# и выводит на экран сообщение "Ваш возраст [возраст] лет".
age = input("Enter your age ")
print (f"Ваш возраст {age} лет")

#9. Напишите программу, которая запрашивает у пользователя два числа и
# выводит на экран их произведение.
a1 = input("Enter first number for multiply ")
a2 = input("Enter second number for multiply ")

print(f"multiply:{int(a1)*int(a2)}")

#10.Напишите программу, которая запрашивает у пользователя слово и
# выводит на экран его первую букву.
word = input("Enter your word ")
print (f"Первая буква слова {word[0]}")

#11. Напишите программу, которая запрашивает у пользователя целое число и выводит на экран его квадрат.
a1 = input("Enter first number to exponentiate ")
n = input("Enter to exponentiate for number ")
res = 1
for i in range(1,int(n)+1):
    res = res*int(a1)
print(f"result:{res}")

#12. Напишите программу, которая выводит на экран таблицу умножения на число 5
a = 5 
for i in range(1,11):
    multi = i*a
    print (multi)

#13. Напишите программу, которая запрашивает у пользователя два числа и
# выводит на экран их среднее арифметическое.
a1 = input("Enter first number for avg ")
a2 = input("Enter second number for avg ")
print(f"avg:{(int(a1)+int(a2))/2}")

# Для любого количества чисел
n = input("Enter quantities for number ")
sum = 0
for i in range(1,int(n)+1):
    a = int(input("Enter number "))
    sum = sum + a
res = sum/int(n)
print(f"result:{res}")