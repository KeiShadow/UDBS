/*TEST*/
/*
1 přidejte do tabulky zakaznik atribut vek typu integer, který nemůže být NULL. Všem současným zákazníkům v databázi nastavte hodnotu atributu na 20. (4 body)
-- 2 vymažte zákazníka se jménem 'pepík'. (4 body)
-- 3 Přidejte tabulku výrobce (znacka: varchar, telefon:varchar) , kde atribut znacka bude primárním klíček (6 bodů)
-- 4 udělejte z atributu Produkt.znacka cizí klíč na tabulku Vyrobce. (6 bodů)

*/

/*1
 Pridani veku do tabulky s defaultni hodnotou atributu 20
*/
ALTER TABLE test.Zakaznik ADD vek int NOT NULL Default 20 
/*2
 Vymazani zakaznika z tabulek
*/
delete from test.reklamace where nID
 in (select na.nID from test.nakup na, test.reklamace re, test.zakaznik za 
 where na.nID = re.nID and za.zID = na.zID and za.jmeno = 'pepik')
delete from test.nakup where zID 
in (select za.zID from test.nakup na, test.zakaznik za 
where za.zID = na.zID and za.jmeno = 'pepik')
DELETE FROM test.zakaznik WHERE jmeno='pepik'


/*3
Vytvoreni tabulky ez
*/
CREATE TABLE Vyrobce (
znacka varchar (30) PRIMARY KEY,
telefon varchar (30) NOT NULL,
)
SELECT * from Vyrobce

/*
4)
-with NOCEHCK: Podle mě teda nebude kontrolvat hodnoty v tabulce ve ktere se ma menit sloupec na FK
-CONSTRAINT jsou CONSTRAINTy nevim co to presne znamena ale funguje to :D Typický "ajták"
FK znamena Fake klic
*/

ALTER TABLE test.Produkt with NOCHECK ADD CONSTRAINT FK_znacka FOREIGN KEY (znacka) REFERENCES Vyrobce(znacka)
/*
Tenhle je lepsi tam, neni to constraint a funguje to stejne radsi bych pouzival tenhle prikaz
Kdyby se ptal profesor:D
*/
ALTER TABLE test.Produkt with NOCHECK ADD FOREIGN KEY (znacka) REFERENCES Vyrobce(znacka)

/*
Smazani Fake klice :D 
Funguje pouze pro ten prvni pripad s tim FK_znacka
*/
Alter TABLE test.Produkt DROP CONSTRAINT FK_znacka



/*Procvicovani*/
INSERT INTO dbo.Spolecnost Values 
('Czech airlines', 'Praha', 'Prazska 2', '12000', 'CR', '+420 234 789 111');
INSERT INTO dbo.Spolecnost Values 
('Delta', 'Detroit', 'Elm street 55', '15122', 'USA', '+100 900 987 000')
INSERT INTO dbo.Spolecnost Values 
('Emirates', 'Dubai','Arabic 34', '98000', 'Emirates', '+456 111 123 321')

Select * from Letadlo;
INSERT INTO Letadlo(cislo_letadla,Spolecnost_cislo_spolecnosti,typ_letadla,pocet_mist,pocet_motoru,dolet,rok_vyroby) 
Values 
(1, 1, 'B737', 100, 4, 20000, 2000),
(2, 1, 'A777', 200, 6, 30000, 2008),
(3, 3, 'B747', 400, 8, 25000, 2002)

ALTER TABLE Spolecnost ADD vlastnik varchar(30) NULL
ALTER TABLE Letadlo ADD posledni_oprava date not null default '2016-11-09'

ALTER TABLE Letadlo DROP COLUMN posledni_oprava

SELECT * FROM Trasa
insert into Trasa (START, cil, vzdalenost, mezipristani, pocet_pasazeru) values ('Ostrava', 'Svinov', 2000, 9, 50);


ALTER TABLE Trasa ADD CHECK (vzdalenost between 50 and 20000) 
SELECT * FROM Spolecnost
EXEC sp_rename 'Spolecnost.zeme', 'stat'

Create table Pilot(
  id INT PRIMARY KEY IDENTITY,
  jmeno varchar(30) NOT NULL,
  prijmeni varchar(30) NOT NULL,
  pohlavi varchar(1) NOT NULL,
  pocet_naletanych_hodin int NOT NULL
  
);

ALTER TABLE Pilot ADD CHECK (pocet_naletanych_hodin>100) 
ALTER TABLE Pilot ADD CHECK (pohlavi='M' or pohlavi='Z') 

Select * from Trasa

INSERT INTO Pilot (jmeno,prijmeni,pohlavi,pocet_naletanych_hodin) 
VALUES ('Petr','Noga','M',200)
Select * from Letovy_plan

ALTER TABLE Letovy_plan ADD id_pilot int NOT NULL
/*Tadyk to slo lehce zde nebyly vyplneny bunky tzn. tabulka byla prazdna*/
ALTER TABLE Letovy_plan ADD FOREIGN KEY (id_pilot) references Pilot(id)
Insert INTO Letovy_plan Values(1,1,1)












