SELECT * from uzivatel;
SELECT * from koupil;
SELECT * from vyrobek;

SELECT jmeno from vyrobek WHERE vID IN(SELECT vID from koupil WHERE aktualni_cena > ALL(SELECT cena from koupil));


/*uloha 6*/

SELECT jmeno FROM vyrobek
 WHERE aktualni_cena>ALL(select cena from koupil where vyrobek.vID=koupil.vID) 
 and vID IN(SELECT vID from koupil)


 SELECT jmeno from vyrobek WHERE vID in(
 SELECT distinct vID from koupil K1
  WHERE vID IN(SELECT vID from koupil K2 WHERE K1.vID = K2.vID and k1.login=K2.login and K1.rok!=K2.rok))


/*Uloha 7: Naleznete v ˇ sechny u ˇ zivatele, kte ˇ rˇ´ı nakoupili nejak ˇ y v´ yrobek nejlevn ´ eji ˇ
(tzn. nikdo nekupoval stejny v´ yrobek za ni ´ zˇsˇ´ı cenu).
(V´ysledek: Kasa, Pepik, RychlaRota, Vinetu)*/
/*moje reseni*/
SELECT distinct login from koupil k1 WHERE cena <= ALL(SELECT cena from koupil k2 WHERE k1.vID=k2.vID)
/*profesorovo reseni*/
SELECT distinct login from koupil k1 WHERE cena < ALL(SELECT cena from koupil k2 WHERE k1.vID=k2.vID and k1.login!=k2.login)

SELECT distinct * from koupil;

/*Naleznete u ˇ zivatele, kte ˇ rˇ´ı provedli jen jeden nakup. */
/*Uloha c.1*/
SELECT distinct login from koupil k1 WHERE login NOT IN (SELECT login from koupil k2 where k1.login=k2.login and k1.rok!=k2.rok);
/*uloha c.2*/
SELECT distinct login from koupil k1 WHERE login NOT IN (SELECT login from koupil k2 where k1.vID!=k2.vID);
/*uloha c.3 Nedodelane*/
SELECT jmeno from vyrobek WHERE vID IN (SELECT vID from koupil WHERE vyrobek.vID=koupil.vID)
