# Домашнее задание к занятию «Уязвимости и атаки на информационные системы» - "Shchemelinin Anton`



### Задание 1

Vsftpd 2.3.4  https://www.exploit-db.com/exploits/17491
Samba 3.0.20-3.0.25rc3  https://www.exploit-db.com/exploits/6673
UnrealIRCd 3.2.8.1 backdoor  https://www.exploit-db.com/exploits/18211


### Задание 2


Отличия режимов сканирования по трафику:

SYN  Отправка SYN-пакетов без полного TCP-handshake; трафик минимальный
FIN  Отправка FIN-пакетов (завершение соединения); трафик с FIN-флагом, без SYN/ACK.
Xmas  Отправка пакетов с FIN/PSH/URG-флагами ; нестандартный трафик, обходит некоторые фаерволы.
UDP  Отправка пустых UDP-пакетов; трафик без TCP, возможны ICMP-ответы, медленнее из-за таймаутов.
(Запись в Wireshark показала различия в флагах TCP/UDP и ответах.)

Ответ сервера:
SYN: Open — SYN-ACK; closed/filtered — RST или ничего.
FIN/Xmas: Open — игнор; closed — RST.
UDP: Open — UDP-ответ или ICMP unreachable (ошибка); closed — ICMP port unreachable; filtered — таймаут.
