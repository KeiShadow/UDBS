SELECT * from uzivatel;
SELECT * from koupil;
SELECT * from vyrobek;

SELECT login FROM uzivatel WHERE (rok_narozeni>1980 and rok_narozeni <1990) or rok_narozeni%2=0;
SELECT distinct rok FROM Koupil WHERE vID=1;
SELECT uzivatel.login ,jmeno FROM uzivatel, vyrobek, koupil WHERE uzivatel.login=koupil.login and koupil.vID = vyrobek.vID and uzivatel.mesto='Ostrava';
SELECT distinct jmeno FROM uzivatel, vyrobek, koupil WHERE uzivatel.login=koupil.login and koupil.vID = vyrobek.vID and jmeno like '%a' ORDER BY jmeno DESC;

SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='vinetu'
INTERSECT
SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='pepik'

SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='vinetu'
EXCEPT
SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='pepik'

SELECT distinct vyrobek.vID FROM vyrobek
EXCEPT
SELECT distinct vyrobek.vID FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID

SELECT distinct jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='vinetu'
UNION
SELECT distinct jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='pepik'
EXCEPT
SELECT distinct jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='vinetu'
INTERSECT
SELECT distinct jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='pepik'

SELECT jmeno from vyrobek 
WHERE jmeno in (SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='vinetu')
 and jmeno in(SELECT jmeno FROM vyrobek, koupil WHERE vyrobek.vID=koupil.vID and login='pepik')

SELECT jmeno from vyrobek 
WHERE vID in (SELECT vID FROM koupil WHERE login='vinetu')
 and vID in(SELECT vID FROM koupil WHERE login='pepik')

SELECT jmeno from vyrobek 
WHERE vID in (SELECT vID FROM koupil WHERE login='vinetu')
 and vID NOT in(SELECT vID FROM koupil WHERE login='pepik')

 SELECT vID from vyrobek 
WHERE vID  NOT in (SELECT vID FROM koupil)
 and vID  NOT in(SELECT vID FROM koupil )

SELECT jmeno from vyrobek 
WHERE vID NOT in (SELECT vID FROM koupil WHERE login='vinetu')
or vID NOT in(SELECT vID FROM koupil WHERE login='pepik') 
and vID  in (SELECT vID FROM koupil WHERE login='vinetu' and login='pepik')
