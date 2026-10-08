# IOCLA Homework 2 - x86 Assembly (32-bit, NASM)

Tema 2 la Introducere în Organizarea și Limbajul Calculatoarelor (IOCLA), scrisă în assembly x86 pe 32 de biți (NASM).

## Conținut
| Task | Fișier | Descriere |
|------|--------|-----------|
| 1 | `task-1/remove_numbers.asm` | Elimină dintr-un vector numerele impare și puterile lui 2 |
| 2.1 | `task-2/subtask1.asm` | Validarea datelor calendaristice dintr-un vector de evenimente |
| 2.2 | `task-2/subtask2.asm` | Sortarea evenimentelor (validitate, dată, nume) |
| 3 | `task-3/base64.asm` | Codare Base64 |
| 4 | `task-4/sudoku.asm` | Verificarea liniilor, coloanelor și casetelor 3x3 dintr-un Sudoku |

## Notă
Arhiva conține doar soluțiile. Scheletul temei (`include/io.mac`, teste, checker) aparține cursului și nu este inclus, deci proiectul nu se poate compila din acest repository singur.

## Explicații

### Task 1
La primul subtask trebuie sa verificam numerele impare. Numerele impare au toate bitul cel mai putin
semnificativ 1, asa ca putem verifica daca un numar este impar printr-o operatie AND cu 1. Daca
rezultatul este 1, numarul este impar. Daca nu este impar, punem rezultatul in destinatie(edx). Am
luat eax ca indice si l-am curatat la inceput cu xor ca sa fie 0. Facem aceeasi chestie si pt
puterile lui 2, doar ca aici ca un numar sa fie putere de 2 facem and pe el si el - 1(explicatia
este ca puterile lui 2 au doar bitul 1 setat pe puterea respectiva, in rest 1, iar daca scadem 1 din
el se fac toate 1 pana in bitul respectiv care devine 0). Dupa facem aceleasi conditii de eliminare
sau adaugare in destinatie.

### Task 2

Subtask 1: In aceasta functie verificam validitatea fiecarei date dintr-un vector de evenimente.
Incepem prin a initializa indexul eax cu 0 si parcurgem vectorul folosind o bucla. Adresa fiecarui
eveniment este calculata inmultind indexul cu 36 (dimensiunea structurii event) si adaugand
rezultatul la adresa de baza ebx, care pointeaza spre inceputul vectorului. Accesam campul year (2
bytes) direct in registrul dx si verificam daca este intre 1990 si 2030. Pentru month si day,
folosim dl si curatam partea superioara dh pentru a obtine valoarea completa in dx. Verificam daca
luna este intre 1 si 12, iar ziua este cel putin 1. In functie de luna, decidem care este limita
superioara a zilei: daca luna este februarie, se accepta pana la 28; pentru lunile cu 30 de zile
(aprilie, iunie, septembrie, noiembrie), se permite maxim 30; iar restul lunilor pot avea pana la
31 . Daca oricare verificare esueaza, mergem la eticheta invalid, setam campul valid cu 0 si trecem
la urmatorul eveniment. Daca toate verificarile sunt trecute, mergem la valid si marcam evenimentul
ca valid cu 1. Bucla continua pana cand procesam toate elementele din vector.

Subtask 2: La inceput, comparam daca lungimea vectorului este 0 sau 1, caz in care nu e nevoie de
sortare. Apoi folosim doua bucle: una exterioara (care scade lungimea efectiva la fiecare pas) si
una interioara (care compara perechi de elemente). In bucla interioara, calculam adresele
evenimentelor i si i+1 folosind indexul esi, pe care il inmultim cu dimensiunea structurii event (36
de bytes). Compararea incepe cu campul valid. Daca evenimentul i este invalid si i+1 este valid,
facem swap. Daca ambele sunt valide (sau invalide), trecem la compararea campurilor din date: intai
year, apoi month, apoi day. Compararea este facuta in mod clasic, cu instructiuni cmp si salturi
conditionale (jg, jl etc.). Daca datele sunt egale, comparam numele. Aici folosim o bucla care
parcurge cei 31 de bytes alocati pentru name, comparand caracter cu caracter (registrii al si dl),
si facem swap daca numele i+1 este "mai mic" (in ordine lexicografica). Daca toate caracterele sunt
egale, nu facem swap. In caz ca este nevoie de swap, folosim o variabila auxiliara temp in segmentul
.bss ca sa luam tot eventul (adica toti cei 36 de bytes). Se fac trei bucle de copiere: prima
copiaza event[i] in temp, a doua copiaza event[i+1] peste event[i], iar a treia copiaza temp in
event[i+1]. Dupa swap, setam un flag (ebp) care semnaleaza ca a avut loc o schimbare in aceasta
iteratie, iar bucla exterioara va mai rula inca o data. Daca nu s-a facut niciun swap, inseamna ca
vectorul este deja sortat si iesim din bucla.

### Task 3

Incepem cu initializarea unui index (ecx) pentru a parcurge sirul de intrare, iar apoi intram intr-o
bucla ce proceseaza fiecare bloc de 3 octeti. Pentru fiecare bloc, cei 3 octeti sunt combinati
intr-un registru de 24 de biti (eax) folosind shiftari si or. Acesti 24 de biti sunt apoi imparti in
4 grupuri de cate 6 biti, fiecare grup reprezentand un caracter in alfabetul Base64. Fiecare grup de
6 biti este procesat prin mutarea acestuia intr-un registru (edx), aplicarea unei masti pentru a
pastra doar cei 6 biti relevanti, iar apoi se foloseste acea valoare pentru a indexa alfabetul
Base64 si a obtine caracterul corespunzator. Dupa procesarea celor 3 octeti, indexul (ecx) este
avansat cu 3 si bucla continua cu urmatorul bloc de octeti. In fiecare iteratie a buclei, se iau 3
octeti din sirul de intrare si se formeaza un bloc de 24 de biti (3 * 8 biti). Acest bloc de 24 de
biti este apoi impartit in 4 grupuri de cate 6 biti. Fiecare grup de 6 biti este folosit pentru a
extrage un index care va indica pozitia unui caracter in alfabetul Base64. La final, se calculeaza
lungimea sirului rezultat in urma codificarii.

### Task 4

Toate aceste functii urmeaza aceeasi idee de baza: se initializeaza un vector auxiliar vect de 9
bytes cu 0, fiecare pozitie corespunzand unei cifre de la 1 la 9. Pe masura ce parcurgem celulele
zonei de interes (linie, coloana sau casuta), daca intalnim o cifra valida (intre 1 si 9), verificam
daca a mai fost deja inregistrata in vector. Daca da, secventa este invalida (se intoarce 2). Daca
nu, o inregistram (setam vect[val - 1] = 1) si continuam. Daca parcurgerea se incheie fara erori, se
intoarce 1. Pentru check_row, se incepe prin a calcula adresa de start a liniei in Sudoku folosind
formula row * 9, iar apoi se itereaza cele 9 celule ale liniei. La fiecare pas, se extrage valoarea
si se foloseste ca index in vectorul auxiliar pentru verificare. 
In check_column, pentru a accesa
elementele unei coloane, se merge pe rand prin fiecare linie si se extrage elementul de pe pozitia
row * 9 + column, in total 9 elemente. Acestea sunt tratate in acelasi mod ca in functia anterioara:
se verifica daca sunt valide si unice. 
Functia check_box este putin mai complexa, pentru ca trebuie
sa acceseze o submatrice 3x3 pe baza unui index de la 0 la 8. Se calculeaza mai intai randul si
coloana de start a casutei folosind box / 3 * 3 si box % 3 * 3, apoi se convertesc in offset intr-un
vector prin box_row * 9 + box_col. Se parcurg cele 3 randuri ale casutei, fiecare cu cate 3 coloane,
si se aplica acelasi principiu de verificare a cifrelor.