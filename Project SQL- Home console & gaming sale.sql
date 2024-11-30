create table tblConsole (
ConsoleName varchar (50) not null,
Company varchar (50) not null,
GenYears varchar (20) not null,
ReleaseYear int not null,
Gen int not null,
Discontinue int null,
UnitsSoldMillions int null)

select * from tblConsole

insert into tblConsole
values ('Magnavox Odyssey', 'Magnavox', '1972-1978', 1972, 1, 1975, 0.35),
('Home Pong', 'Atari', '1972-1978', 1975, 1, 1978, 0.15),
('Atari 2600', 'Atari', '1978-1982', 1977, 2, 1992, 30),
('Magnavox Odyssey 2', 'Magnavox', '1978-1982', 1978, 2, 1984, 2),
('Intellivision', 'Mattel', '1978-1982', 1979, 2, 1990, 3),
('Atari 5200/7800', 'Atari', '1982-1988', 1982, 3, 1984, 2),
('Nintendo Entertainment System', 'Nintendo', '1982-1988', 1983, 3, 1995, 62),
('Sega Master System', 'Sega', '1982-1988', 1986, 3, 1996, 13),
('Sega Genesis', 'Sega', '1988-1994', 1988, 4, 1997, 33),
('Super Nintendo', 'Nintendo', '1988-1994', 1990, 4, 2003, 49),
('PlayStation', 'Sony', '1994-1998', 1994, 5, 2006, 102),
('Sega Saturn', 'Sega', '1994-1998', 1994, 5, 2000, 9),
('Nintendo 64', 'Nintendo', '1994-1998', 1996, 5, 2002, 33),
('Sega Dreamcast', 'Sega', '1998-2005', 1998, 6, 2001, 9),
('PlayStation 2', 'Sony', '1998-2005', 2000, 6, 2013, 155),
('GameCube', 'Nintendo', '1998-2005', 2001, 6, 2007, 22),
('Xbox', 'Microsoft', '1998-2005', 2001, 6, 2009, 24),
('Xbox 360', 'Microsoft', '2005-2012', 2005, 7, 2016, 84),
('PlayStation 3', 'Sony', '2005-2012', 2006, 7, 2017, 87),
('Wii', 'Nintendo', '2005-2012', 2006, 7, 2013, 101),
('Wii U', 'Nintendo', '2012-2017', 2012, 8, 2017, 14),
('PlayStation 4', 'Sony', '2012-2017', 2013, 8, null, 117),
('Xbox One', 'Microsoft', '2012-2017', 2013, 8, 2020, 58),
('Nintendo Switch', 'Nintendo', '2017-Ongoing', 2017, 9, null, 138),
('PlayStation 5', 'Sony', '2017-Ongoing', 2020, 9, null, 55),
('Xbox Series', 'Microsoft', '2017-Ongoing', 2020, 9, null, 28)


create table tblGame(
GameName varchar(100) null,
Console varchar(50) null,
UnitSoldMil float null,
Publisher varchar(50) null,
Developer varchar(50) null,
ReleaseDate nvarchar(20) null)

select * from tblConsole
select * from tblGame

insert into tblGame
values ('Pac-Man', 'Atari 2600', 7.7, 'Atari', 'Atari', '01/03/1982'),
('Pitfall!', 'Atari 2600', 4, 'Activision', 'Activision', '20/04/1982'),
('Frogger', 'Atari 2600', 4, 'Parker Bros.', 'Konami', '01/01/1982')

select * from tblGame
where GameName is null


select C.ConsoleName, C.Company, G.GameName, G.ReleaseDate, C.GenYears, C.Gen, G.UnitSoldMil, G.Publisher, G.Developer
from tblConsole as C
left join tblGame as G
on C.ConsoleName = G.Console
order by ReleaseDate --checking for any missing values as is null returns nothing

select * from tblGame
where ReleaseDate = ' '

delete from tblGame
where ReleaseDate = ' ' --deleting rows where release date is empty

select * from tblGame order by ReleaseDate
go


with ModernGameSales as
(select C.ConsoleName, C.Company, G.GameName, G.ReleaseDate, C.GenYears, C.Gen, G.UnitSoldMil, G.Publisher, G.Developer,
sum(G.UnitSoldMil) over(partition by G.GameName) as TotalSalesMillions
from tblConsole as C
right join tblGame as G
on C.ConsoleName = G.Console
where Gen>=5)

select distinct GameName, TotalSalesMillions
from ModernGameSales
where TotalSalesMillions>1
order by TotalSalesMillions desc -- determine number of modern games with sales above 1 million units

with CompanyGameSales as
(select C.ConsoleName, C.Company, C.Gen, G.UnitSoldMil, G.GameName,
sum(G.UnitSoldMil) over(partition by C.Company order by G.GameName) as TotalSales
from tblConsole as C
right join tblGame as G
on C.ConsoleName = G.Console
where UnitSoldMil>0 and Gen between 6 and 8)

select Company, max(TotalSales) as MaxGameSalesMillions
from CompanyGameSales
--where Company != 'Sega'
group by Company
order by MaxGameSalesMillions desc -- determine which modern console company sold the most game unit

select Company, sum(UnitsSoldMillions) as TotalConsoleSalesMillions
from tblConsole
group by Company
order by TotalConsoleSalesMillions desc --determine which company sold the most console throughout history


