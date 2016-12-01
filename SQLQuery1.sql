-- 1.A
-- Vypi�te produkty, kter� byly v�dy reklamov�ny mu�i, kte�� je koupili.
-- Jin�mi slovy, vypi�te produkty, kter�, kdy� koupil mu�, tak je i reklamoval.
-- Nevypisujte produkty, kter� nikdy mu� nekoupil.
/*
select n.pID from test.Nakup n
 LEFT JOIN test.Reklamace r ON r.nID=n.nID
 JOIN test.Zakaznik z ON z.zID = n.zID WHERE z.pohlavi='muz'
 GROUP BY n.pID
 HAVING COUNT(n.nID)=SUM(CASE WHEN r.poradi IS NULL THEN 0 ELSE 1 END)

 -- 1.B
-- Vypi�te produkty, kter� byly v�dy reklamov�ny �enami, kter� je koupili.
-- Jin�mi slovy, vypi�te produkty, kter�, kdy� koupila �ena, tak je i reklamovala.
-- Nevypisujte produkty, kter� nikdy �ena nekoupil.

SELECT n.pID from test.Nakup n
LEFT JOIN test.Reklamace r ON r.nID = n.nID
JOIN test.Zakaznik z ON z.zID=n.zID WHERE z.pohlavi='zena'
GROUP BY n.pID
HAVING COUNT(n.nID)= SUM(CASE WHEN r.poradi IS NULL THEN 0 ELSE 1 END)



 -- 2.A
-- Pro ka�d�ho z�kazn�ka vypi�te po�et jeho n�kup�, kde byla cena pod pr�m�rnou cenou dan�ho produktu.

SELECT z.zID, z.jmeno, COUNT(n.pID) FROM test.Zakaznik z
LEFT JOIN test.Nakup n  ON z.zID = n.zID
 AND n.cena < ALL(
	SELECT AVG(cena)
	FROM test.Nakup n1
	WHERE n1.pID=n.pID
 
 )
 GROUP BY z.zID, z.jmeno
 

 -- 2.B
-- Pro ka�d� produkt vypi�te po�et jeho n�kup� u kter�ch byla cena pod pr�m�rnou cenou dan�ho produktu.
SELECT p.pID, p.oznaceni, COUNT(n.pID) FROM test.Produkt p
LEFT JOIN test.Nakup n ON n.pID = p.pID
AND n.cena < ALL(
 SELECT AVG(cena) FROM test.Nakup n1
 WHERE n.pID=n1.pID
)
GROUP BY p.pID, p.oznaceni

-- 3.A
-- Vypi�te jm�no nejv�ce nakupuj�c�ho z�kazn�ka �ensk�ho pohlav�. 
-- Jin�mi slovy jde n�m o �enu, kter� m� mezi �enami nejvy��� celkov� po�et nakoupen�ch kus� zbo��.
SELECT z.jmeno, SUM(n.kusu) FROM test.Zakaznik z
JOIN test.Nakup n ON n.zID=z.zID WHERE z.pohlavi='zena'
 GROUP BY z.jmeno
 HAVING SUM(n.kusu)>= ALL(
  SELECT SUM(n2.kusu) FROM test.Zakaznik z2
  JOIN test.Nakup n2 ON n2.zID=z2.zID WHERE z2.pohlavi='zena'
  GROUP BY z2.zID
 
 )

 -- 3.A
-- Vypi�te jm�no nejv�ce nakupuj�c�ho z�kazn�ka �ensk�ho pohlav�. 
-- Jin�mi slovy jde n�m o �enu, kter� m� mezi �enami nejvy��� celkov� po�et nakoupen�ch kus� zbo��.
--asi neuznatelne

 SELECT TOP 1 z.jmeno, SUM(n.kusu) as pocet FROM test.Zakaznik z
  JOIN test.Nakup n ON n.zID = z.zID WHERE z.pohlavi = 'zena'
    GROUP BY z.jmeno
  HAVING SUM(n.kusu)=
  (CASE WHEN SUM(n.kusu)>=SUM(n.kusu) then SUM(n.kusu) else 0 END) 
  ORDER BY SUM(n.kusu) desc

  --Mozna uznatelne
SELECT TOP 1 z.jmeno,SUM(n.kusu) as pocet 
FROM test.zakaznik z
JOIN test.nakup n ON n.zID=z.zID 
WHERE z.pohlavi='zena'
GROUP BY z.jmeno
ORDER BY SUM(n.kusu) desc


-- 3.B
-- Vypi�te jm�no nejv�ce nakupuj�c�ho z�kazn�ka, kter� si nech�v� zas�lat reklamu. 
-- Jin�mi slovy jde n�m o z�kazn�ka, kter� m� nejvy��� celkov� po�et nakoupen�ch kus� zbo�� mezi z�kazn�ky, kte�� si nech�vaj� zas�lat reklamu.
SELECT z.jmeno, SUM(n.kusu) as pocet from test.Zakaznik z
JOIN test.Nakup n ON n.zID=z.zID WHERE z.posilat_reklamu is not null
GROUP BY z.jmeno
HAVING SUM(n.kusu) >= ALL(
 SELECT SUM(n1.kusu) from test.Zakaznik z2
 JOIN test.Nakup n1 on n1.zID=z2.zID where z2.posilat_reklamu is not null
 GROUP BY z2.zID
)
--Nev�m zda uznateln� kod
SELECT TOP 1 z.jmeno, SUM(n.kusu) as pocet from test.Zakaznik z
JOIN test.Nakup n ON n.zID=z.zID WHERE z.posilat_reklamu is not null
GROUP BY z.jmeno
ORDER BY SUM(n.kusu) desc


-- �tvrtek 1.A
-- U ka�d�ho z�kazn�ka, kter� m� alespo� jeden n�kup, vypi�te kolik reklamac� m� pr�m�rn� na jeden n�kup. 
-- Pro korektn� zobrazen� v�sledku je pot�eba po�ty n�kup� p�ed po��t�n�m pr�m�ru p�etypovat na float s pomoc� CAST(count(*) as FLOAT).
-- Vypi�te (zID, jmeno, pr�m�r)
SELECT zID, jmeno, avg(reklamace) as AVG_REKLAMACE from(
SELECT n.nID,n.zID,z.jmeno, cast(count(r.nID)as float) reklamace from test.Nakup n
JOIN test.Zakaznik z on n.zID=z.zID
LEFT JOIN test.Reklamace r on r.nID=n.nID 
GROUP BY n.nID,n.zID, z.jmeno
)zak
group by zID, jmeno
ORDER BY zID

-- 1.B
-- U ka�d�ho produktu vypi�te kolik reklamac� m� pr�m�rn� na jeden n�kup. Set�i�te podle pID.
-- Pro korektn� zobrazen� v�sledku je pot�eba po�ty n�kup� p�etypovat s pomoc� CAST(hodnota as FLOAT).
-- Vypi�te (pID, oznaceni, pr�m�r)

SELECT pID, oznaceni, avg(reklamace) as REKLAMACE from(
 select n.nID, n.pID, p.oznaceni, cast(count(r.nID) as float) reklamace from test.Nakup n
 JOIN test.Produkt p on p.pID=n.pID
 LEFT JOIN test.Reklamace r on r.nID=n.nID
 GROUP BY n.nID, n.pID, p.oznaceni
 )zak
 GROUP BY pID, oznaceni
 ORDER BY pID

-- 2.A
-- Vypi�t� zID a jm�no z�kazn�k�, kte�� nakoupili nejv�t�� po�et kus� jednoho zbo��.
SELECT distinct z.zID, z.jmeno,n.pID, sum(n.kusu) as kusy
  FROM test.Nakup n
JOIN test.Zakaznik z on n.zID=z.zID
GROUP BY z.zID, z.jmeno,n.pID
having sum(n.kusu) >= all(
	select sum(n.kusu)
	from test.nakup n
	join test.Zakaznik z on z.zID = n.zID
	group by n.zID, n.pID
)

-- 2.B
-- Vypi�te pID a ozna�en� produkt�, kter� byly koupeny jedn�m z�kazn�kem v nejv�ce kusech
SELECT distinct p.pID, p.oznaceni, SUM(n.kusu) as kusy
 FROM test.Nakup n
JOIN test.Produkt p ON p.pID=n.pID 
GROUP BY p.pID, p.oznaceni, n.zID
HAVING SUM(n.kusu) >= ALL(
 select SUM(n.kusu) from test.Nakup n
  join test.Produkt p on p.pID=n.pID
  GROUP BY p.pID, n.zID
)


SELECT p.pID, p.oznaceni, SUM(n.kusu) as kusy from test.Produkt p
JOIN test.Nakup n on p.pID=n.pID
GROUP BY p.pID, p.oznaceni, n.zID
HAVING SUM(n.kusu)>=ALL(
 SELECT SUM(n.kusu) from test.Nakup n
 JOIN test.Produkt p ON n.pID=p.pID
 GROUP BY p.pID, p.oznaceni, n.zID
)

-- 3.A
-- Vypi�te m�s�ce ve kter�ch nikdy nebyl prod�n v�robek zna�ky `Whirpool'.
-- Mno�inu v�ech m�s�c� je mo�n� z�skat s pomoc� funkce month(test.nakup.den) a tabulky test.nakup.

SELECT DISTINCT MONTH(n.den) as mesic from test.Nakup n
except
SELECT DISTINCT month(n1.den) as mesic
from test.Nakup n1
JOIN test.Produkt p on p.pID=n1.pID
WHERE p.znacka = 'Whirpool'

-- 3.B
-- Vypi�te m�s�ce ve kter�ch nikdy nebyl prod�n v�robek zna�ky `Green line'.
-- Mno�inu v�ech m�s�c� je mo�n� z�skat s pomoc� funkce month(test.nakup.den) a tabulky test.nakup.

SELECT DISTINCT MONTH(n.den) as mesic FROM test.Nakup n
except
SELECT DISTINCT MONTH(n1.den) as mesic from test.Nakup n1
JOIN test.Produkt p on n1.pID = p.pID
WHERE p.znacka='Green line'

-- 1.A 
-- Vypi�te v�echny produkty, kter� nebyly v ��dn�m roce koupeny dvakr�t.

select *
from test.Produkt p
where 2 != all
(
	select count(*)
	from test.nakup n
	where n.pID = p.pID
	group by year(n.den)
)


SELECT p.oznaceni, p.pID, YEAR(n.den) as rok, COUNT(p.pID) as KOUPENO from test.Produkt p
JOIN test.Nakup n on p.pID=n.pID 
LEFT JOIN test.Nakup n1 on n1.nID = n.nID
GROUP BY p.oznaceni,  p.pID, YEAR(n.den)
HAVING COUNT(p.pID)< 2
ORDER BY p.pID

-- 2.A
-- Vypi�te v�echny produkty, kter� byly reklamov�ny za cenu vy��� ne� dva tis�ce korun maxim�ln� jednou. Vypi�te pID, ozna�en� a po�et reklamac�.
-- Eliminujte produkty, kter� nebyly nikdy koupeny
SELECT p.pID, r.cena FROM test.Zakaznik z
JOIN test.Nakup n on n.zID=z.zID
JOIN test.Produkt p on n.pID=p.pID
LEFT JOIN test.Reklamace r on r.nID=n.nID and r.cena < 2000 or r.cena is null
ORDER BY p.pID

SELECT p.pID, r.cena from test.Zakaznik z
JOIN test.Nakup n on n.zID=z.zID
JOIN test.Produkt p on p.pID=n.pID
LEFT JOIN test.Reklamace r on r.nID = n.nID WHERE r.cena < 2000 or r.cena is NULL
ORDER BY p.pID

-- 2.B
-- Vypi�te v�echny produkty, kter� u ni� d�lka reklamace p�es�hla 10 dn� maxim�ln� jednou. Vypi�te pID, ozna�en� a po�et reklamac�.
-- Eliminujte produkty, kter� nebyly nikdy koupeny

SELECT p.pID, p.oznaceni, COUNT(r.cena) from test.Produkt p
JOIN test.Nakup n ON n.pID=p.pID
LEFT JOIN test.Reklamace r ON r.nID=n.nID and r.delka >10 
GROUP BY p.pID, p.oznaceni
HAVING count(r.cena)<2


-- 3.A
-- U ka�d�ho z�kazn�ka vypi�te: (1) kolik r�zn�ch produkt� reklamoval, (2) v kolika r�zn�ch letech nakupoval zbo��. 
-- Pro druhou hodnotu pou�ijte funkci YEAR(test.Nakup.den), kter� vr�t� rok n�kupu.
SELECT z.jmeno, z.zID,
(
 SELECT COUNT(distinct pID) as Kolik from test.Nakup n 
 JOIN test.Reklamace r on r.nID=n.nID where n.zID=z.zID
),
(
SELECT COUNT(distinct YEAR(n.den)) as ROKY
 from test.Nakup n 
 where n.zID=z.zID
) from test.Zakaznik z

-- 2.A
-- Vypi�te produkty, kter� pokud byly reklamov�ny, tak pouze z�kazn�ky registrovan�mi v roce 2006
-- Z v�sledku odstra�te produkty, kter� nikdy nebyly koupeny.

SELECT distinct p.pID, p.oznaceni from test.Produkt p
 JOIN test.Nakup n on n.pID=p.pID WHERE not exists 
 (
  SELECT * from test.Nakup n
  JOIN test.Reklamace r on n.nID=r.nID
  JOIN test.Zakaznik z on z.zID=n.zID and (z.rok_registrace!=2006 or z.rok_registrace is null)
  where n.pID=p.pID
 )

select distinct p.pID, p.oznaceni
from test.produkt p
join test.Nakup n on p.pID = n.pID
where not exists
(
	select *
	from test.nakup n
	join test.reklamace r on n.nID = r.nID 
	join test.Zakaznik z on z.zID = n.zID and 
		(z.rok_registrace != 2006 or z.rok_registrace is null)
	where n.pID = p.pID
)

-- 1.A
-- Vypi�te produkty, kter� byly v�dy reklamov�ny mu�i, kte�� je koupili.
-- Jin�mi slovy, vypi�te produkty, kter�, kdy� koupil mu�, tak je i reklamoval.

-- Nevypisujte produkty, kter� nikdy mu� nekoupil.

SELECT p.pID FROM test.Produkt p
JOIN test.Nakup n on n.pID=p.pID
JOIN test.Zakaznik z on z.zID=n.zID
LEFT JOIN test.Reklamace r on r.nID=n.nID WHERE z.pohlavi='muz'
GROUP BY p.pID
HAVING COUNT(n.kusu) = SUM(CASE WHEN r.poradi is null THEN 0 ELSE 1 END)


-- 1.B
-- Vypi�te produkty, kter� byly v�dy reklamov�ny �enami, kter� je koupili.
-- Jin�mi slovy, vypi�te produkty, kter�, kdy� koupila �ena, tak je i reklamovala.
-- Nevypisujte produkty, kter� nikdy �ena nekoupil.

SELECT  p.pID FROM test.Produkt p 
JOIN test.Nakup n on n.pID = p.pID 
JOIN test.Zakaznik z on z.zID = n.zID
LEFT JOIN test.Reklamace r on r.nID = n.nID WHERE z.pohlavi='zena'
GROUP BY p.pID
HAVING COUNT(n.kusu) = SUM(CASE WHEN r.poradi is null THEN 0 ELSE 1 END)

-- 2.A
-- Pro ka�d�ho z�kazn�ka vypi�te po�et jeho n�kup�, kde byla cena pod pr�m�rnou cenou dan�ho produktu.

SELECT z.zID, z.jmeno, COUNT(n.pID) FROM test.Zakaznik z
 LEFT JOIN test.Nakup n on z.zID=n.zID AND
 n.cena < ALL(
  SELECT AVG(cena) FROM test.Nakup n1
  WHERE n.pID=n1.pID

 )
 GROUP BY z.zID, z.jmeno


 -- 2.B
-- Pro ka�d� produkt vypi�te po�et jeho n�kup� u kter�ch byla cena pod pr�m�rnou cenou dan�ho produktu.

SELECT p.pID, p.oznaceni, COUNT(n.pID) FROM test.Produkt p
LEFT JOIN test.Nakup n on p.pID=n.pID AND
n.cena <ALL(
 SELECT AVG(cena) FROM test.Nakup n1
 WHERE n.pID=n1.pID
)
GROUP BY p.pID, p.oznaceni


-- 3.A
-- Vypi�te jm�no nejv�ce nakupuj�c�ho z�kazn�ka �ensk�ho pohlav�. 
-- Jin�mi slovy jde n�m o �enu, kter� m� mezi �enami nejvy��� celkov� po�et nakoupen�ch kus� zbo��.

SELECT TOP 1 z.zID, z.jmeno, z.pohlavi, SUM(n.kusu) as kusu FROM test.Nakup n
JOIN test.Zakaznik z on z.zID = n.zID where z.pohlavi ='zena'
GROUP BY z.zID, z.jmeno, z.pohlavi
ORDER BY z.zID desc

SELECT z.jmeno, SUM(n.kusu) as kusy FROM test.Zakaznik z
JOIN test.Nakup n on n.zID=z.zID where z.pohlavi='zena'
GROUP BY z.jmeno
HAVING SUM(n.kusu)>=ALL(
 SELECT SUM(n1.kusu) from test.Nakup n1 
 JOIN test.Zakaznik z1 on z1.zID=n1.zID where z1.pohlavi='zena'
 GROUP BY z1.zID
)

-- 3.B
-- Vypi�te jm�no nejv�ce nakupuj�c�ho z�kazn�ka, kter� si nech�v� zas�lat reklamu. 
-- Jin�mi slovy jde n�m o z�kazn�ka, kter� m� nejvy��� celkov� po�et nakoupen�ch kus� zbo�� mezi z�kazn�ky, kte�� si nech�vaj� zas�lat reklamu.

SELECT z.jmeno, SUM(n.kusu) as kusy FROM test.Nakup n
JOIN test.Zakaznik z on z.zID=n.zID where z.posilat_reklamu is not null
GROUP by z.jmeno
HAVING SUM(n.kusu)>= ALL(
 SELECT SUM(n1.kusu) from test.Nakup n1
 JOIN test.Zakaznik z1 on z1.zID=n1.zID where z1.posilat_reklamu is not null
 GROUP BY z1.zID
)

-- 1.A
-- U ka�d�ho z�kazn�ka, kter� m� alespo� jeden n�kup, vypi�te kolik reklamac� m� pr�m�rn� na jeden n�kup. 
-- Pro korektn� zobrazen� v�sledku je pot�eba po�ty n�kup� p�ed po��t�n�m pr�m�ru p�etypovat na float s pomoc� CAST(count(*) as FLOAT).
-- Vypi�te (zID, jmeno, pr�m�r)

SELECT zID, jmeno, AVG(reklamaci)
 from (
  SELECT n.nID, n.zID, z.jmeno, CAST(count(r.nID) as FLOAT) reklamaci from test.Nakup n
  join test.zakaznik z on z.zID = n.zID
  LEFT JOIN test.Reklamace r on r.nID=n.nID 
  GROUP BY n.nID, n.zID, z.jmeno
 )zak
 GROUP BY zID, jmeno
 ORDER BY zID


 -- 1.B
-- U ka�d�ho produktu vypi�te kolik reklamac� m� pr�m�rn� na jeden n�kup. Set�i�te podle pID.
-- Pro korektn� zobrazen� v�sledku je pot�eba po�ty n�kup� p�etypovat s pomoc� CAST(hodnota as FLOAT).
-- Vypi�te (pID, oznaceni, pr�m�r)
SELECT pID, oznaceni, AVG(prumer) from (
 SELECT n.nID, n.pID, p.oznaceni, CAST(COUNT(r.nID)as FLOAT) prumer FROM test.Nakup n
  JOIN test.Produkt p on p.pID=n.pID
  LEFT JOIN test.Reklamace r on r.nID=n.nID
  GROUP BY n.nID, n.pID, p.oznaceni	
)zak
GROUP BY pID, oznaceni
ORDER BY pID
 

-- 2.A
-- Vypi�t� zID a jm�no z�kazn�k�, kte�� nakoupili nejv�t�� po�et kus� jednoho zbo��.
SELECT z.zID, z.jmeno, n.pID, SUM(n.kusu) FROM test.Nakup n
JOIN test.Zakaznik z on z.zID=n.zID
GROUP BY z.zID, z.jmeno, n.pID
HAVING SUM(n.kusu) >=ALL(
 SELECT SUM(n.kusu) FROM test.Nakup n
 GROUP BY n.zID, n.pID
)

-- 2.B
-- Vypi�te pID a ozna�en� produkt�, kter� byly koupeny jedn�m z�kazn�kem v nejv�ce kusech
SELECT DISTINCT p.pID, p.oznaceni, SUM(n.kusu) as nej_kusu FROM test.Nakup n
JOIN test.Produkt p on p.pID=n.pID
GROUP BY p.pID, p.oznaceni, n.zID
HAVING SUM(n.kusu) >= ALL(
 SELECT SUM(n.kusu) FROM test.Nakup n
 JOIN test.Produkt p on p.pID=n.pID
 GROUP BY n.zID, p.pID
)


-- 3.A
-- Vypi�te m�s�ce ve kter�ch nikdy nebyl prod�n v�robek zna�ky `Whirpool'.
-- Mno�inu v�ech m�s�c� je mo�n� z�skat s pomoc� funkce month(test.nakup.den) a tabulky test.nakup.


SELECT DISTINCT MONTH(n.den) as mesic FROM test.Nakup n
except
SELECT DISTINCT MONTH(n1.den) as mesic FROM test.Nakup n1
JOIN test.Produkt p on n1.pID=p.pID WHERE p.znacka='Whirpool'


-- 3.B
-- Vypi�te m�s�ce ve kter�ch nikdy nebyl prod�n v�robek zna�ky `Green line'.
-- Mno�inu v�ech m�s�c� je mo�n� z�skat s pomoc� funkce month(test.nakup.den) a tabulky test.nakup.
SELECT DISTINCT MONTH(n.den) as mesic FROM test.Nakup n
except
SELECT DISTINCT MONTH(n1.den) as mesic FROM test.Nakup n1
JOIN test.Produkt p on n1.pID=p.pID WHERE p.znacka='Green line'

-- 1.A 
-- Vypi�te v�echny produkty, kter� nebyly v ��dn�m roce koupeny dvakr�t.
SELECT * from test.Produkt p 
WHERE 2 !=ALL(
	 select count(*)
	from test.nakup n
	where n.pID = p.pID
	group by year(n.den)


)*/
