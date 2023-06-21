# Arhivă cu date de la Evaluarea Națională [(EN)](../README.md)
Aceasta este o arhivă cu [datele publicate de Ministerul Educației](http://static.evaluare.edu.ro) despre rezultatele la Evaluarea Națională.
Am creat această arhivă deoarece Ministerul nu disponibilizează toate datele din anii precedenți.

# Utilizare
Datele în format csv se află în folderul `data`.
```
$ git clone https://github.com/Nikoof/en-data && cd en-data
$ tree data
data
├── 2019.csv
├── 2020.csv
├── 2021.csv
├── 2022.csv
└── ...
```
Pot fi, de asemenea, descărcate direct de pe pagina releases.

## Script
Scriptul utilizat pentru a le colecta este disponibil în acest repo.
```
$ chmod u+x en-data.sh
$ ./en-data -h
```

## Dependențe
- curl
- jq
