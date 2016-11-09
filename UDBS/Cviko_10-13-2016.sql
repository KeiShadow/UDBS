select count(cena) from koupil; /*Pocet polozek ve sloupci cena v tabulce koupil*/
select sum(cena) from koupil; /*Suma sloupce cena v tabulce koupil*/
Select login from uzivatel;

/*Priklad 1*/
select jmeno, sum(cena) from vyrobek
LEFT JOIN koupil ON vyrobek.vID=koupil.vID group by jmeno;

/*Priklad 2*/
select jmeno from vyrobek LEFT JOIN koupil ON vyrobek.vID=koupil.vID
GROUP BY jmeno order BY count(koupil.vID) desc;

/*Priklad 3*/
/*Spatne*/
Select jmeno, count(koupil.vID) from vyrobek LEFT JOIN koupil
  on vyrobek.vID=koupil.vID WHERE koupil.login 
  in (select login from uzivatel where koupil.rok=2009
   and uzivatel.rok_narozeni>=1980 and uzivatel.rok_narozeni<=1995) GROUP BY jmeno;

/*Reseni profesora*/
Select jmeno, count(k.vID) from vyrobek v LEFT JOIN koupil k
  on v.vID=k.vID and k.rok=2009 
  LEFT JOIN uzivatel u ON u.login=k.login and
    u.rok_narozeni between 1980 and 1995 GROUP BY jmeno;

/*PRIKLAD 4*/

 SELECT u.login, count(k.vID) from uzivatel u LEFT JOIN koupil k 
 ON u.login=k.login and cena = 
 (SELECT min(cena) from koupil k2 where k.vID=k2.vID)
 GROUP BY u.login

 select login, count(*) from koupil group by login;
 select login, count(*) from koupil group by login having count(*)> 20;
 /*Priklad 5*/

 select v.jmeno, count(k.vID) from vyrobek v LEFT JOIN koupil k
 ON v.vID=k.vID group by jmeno 
 /*having count(k.vID)>= all(select count(k.vID) from vyrobek v LEFT JOIN koupil k
 ON v.vID=k.vID group by jmeno);*/
 having count(k.vID)= (select top 1 count(k.vID) 
 from vyrobek v LEFT JOIN koupil k
 ON v.vID=k.vID group by jmeno order by count(k.vID) desc);
