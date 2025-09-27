# Домашнее задание к занятию «Индексы» - "Shchemelinin Anton`


### Задание 1

<img width="1419" height="801" alt="{E1E20314-7245-4BF4-A401-2FE1A6B7616B}" src="https://github.com/user-attachments/assets/867c839f-c89c-41f2-9a1f-b1631f8956e0" />


### Задание 2

Узкие места: читает всю таблицу payment, самой ресурсозатратный момент это отсутствие условия i.film_id = f.film_id из-за этого, соединяет каждую строку из одной таблицы со всеми строками из другой. С добавлением недостающего JOIN i.film_id = f.film_id, запрос выполняется 0.015 секунды вместо 5 секунд. 

<img width="1755" height="938" alt="{F0CA55AB-1AC9-4438-A778-BA4F3CE9F5BE}" src="https://github.com/user-attachments/assets/86a821db-4699-4a04-b778-1ae6f7851397" />
