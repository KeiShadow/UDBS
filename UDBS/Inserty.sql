/*TEST*/
-- 2 vyma�te z�kazn�ka se jm�nem 'pep�k'. (4 body)
-- 3 P�idejte tabulku v�robce (znacka: varchar, telefon:varchar) , kde atribut znacka bude prim�rn�m kl��ek (6 bod�)
-- 4 ud�lejte z atributu Produkt.znacka ciz� kl�� na tabulku Vyrobce. (6 bod�)
 in (select na.nID from test.nakup na, test.reklamace re, test.zakaznik za 
 where na.nID = re.nID and za.zID = na.zID and za.jmeno = 'pepik')
delete from test.nakup where zID 
in (select za.zID from test.nakup na, test.zakaznik za 
where za.zID = na.zID and za.jmeno = 'pepik')
DELETE FROM test.zakaznik WHERE jmeno='pepik'
znacka varchar (30) PRIMARY KEY,
telefon varchar (30) NOT NULL,
)


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
(3, 3, 'B747', 400, 8, 25000, 2002)

