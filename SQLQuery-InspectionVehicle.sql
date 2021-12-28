create table station(
	StationName nvarchar(25) not null,
	StationID int identity(10000000,1) not null primary key,
	Car bit not null,
	Bus bit not null,
	Trailer bit not null,
	Motorcycle bit not null,
)


create table technician(
	FirstName nvarchar(25) not null,
	LastName nvarchar(30) not null,
	FullName as FirstName+' '+LastName,
	TechnicianID int identity(200000000,1) primary key not null ,
	NationalID nchar(10) not null,
	Gender bit not null,      --    0-->male & 1-->female
	Birthday date not null,
	Age as DATEDIFF(day, Birthday, DATEFROMPARTS(year(getdate()), month(getdate()), day(getdate())))/365,
)


create table vehicle(
	NumberPlate nvarchar(25) not null,
	VIN int identity(30000000,1) primary key not null,
	ProductionDate date not null check(DATEDIFF(day, ProductionDate, DATEFROMPARTS(year(getdate()), month(getdate()), day(getdate())))/365 < 20),
	Brand nvarchar(25) not null,
	Color nvarchar(15) not null,
	OwnerFirstName nvarchar(25) not null,
	OwnerLastName nvarchar(30) not null,
	OwnerNationalID nchar(10) not null,
)


create table inspectionLicense(
	licenseID int identity(1000000000,1) primary key not null,
)


create table stationVehicle(
	ID int identity(1000000000,1) primary key not null,
)
create table stationTechnician(
	TSID int identity(1000000000,1) primary key not null,
)
alter table stationTechnician
ADD StationID int  FOREIGN KEY (StationID) REFERENCES station(StationID) not null;

alter table stationTechnician
ADD TechnicianID int  FOREIGN KEY (TechnicianID) REFERENCES technician(TechnicianID) not null;

alter table stationVehicle
ADD VIN int  FOREIGN KEY (VIN) REFERENCES vehicle(VIN) not null;

alter table stationVehicle
ADD StationID int  FOREIGN KEY (StationID) REFERENCES station(StationID) not null;


alter table technician
ADD licenseID int  FOREIGN KEY (licenseID) REFERENCES inspectionLicense(licenseID) ;


alter table inspectionLicense
ADD VIN int  FOREIGN KEY (VIN) REFERENCES vehicle(VIN) not null;

alter table inspectionLicense
ADD StationID int  FOREIGN KEY (StationID) REFERENCES station(StationID) not null;


insert into [dbo].[station]
values
(N'ستاد مرکزی',1,1,1,1),
(N'شقایق',1,0,1,1),
(N'ترمینال غرب',0,1,0,0),
(N'بیهقی',1,0,0,1),
(N'نیایش',1,0,0,1)


set IDENTITY_INSERT [dbo].[technician] on
insert into [dbo].[technician] (FirstName,LastName,TechnicianID,NationalID,Gender,Birthday)
values
(N'امیر',N'روحی',100000001,'0022370341',0,'1999-07-26'),
(N'فرهاد',N'رحیمی',100000002,'0021347690',0,'1980-11-03'),
(N'مریم',N'ملکی',100000003,'0014729374',1,'1991-06-07'),
(N'پویا',N'اسدی',100000004,'0022092375',0,'1988-02-19'),
(N'گوهر',N'میرزایی',100000005,'3937916120',1,'1999-05-13'),
(N'حسنا',N'زنگنه',100000006,'3937916120',1,'1999-05-13')
set IDENTITY_INSERT [dbo].[technician] off


insert into [dbo].[vehicle]
values
(N'22ب57711','2015-08-16','saipa','white',N'امیر',N'روحی','0022370341'),
(N'34ص98177','2017-09-24','BMW','silver',N'قاسم',N'لطفی','0011223455'),
(N'17ی23746','2017-01-01','toyota','black',N'اصغر',N'نعمتی','0022761299'),
(N'86د52133','2016-06-15','honda','blue',N'مصطفی',N'ناصری','0018637144'),
(N'97ر76538','2011-08-27','irankhodro','white',N'محمد',N'هدایتی','0013983714'),
(N'66ن55420','2013-11-05','peugeot','white',N'مهدی',N'فراهانی','0022739101')

delete from [dbo].[vehicle] where OwnerNationalID = '0022739101'

select count(Color) as CountColor
from [dbo].[vehicle]
where Color = 'white'


select OwnerFirstName,OwnerLastName
from vehicle
inner join technician
on vehicle.OwnerLastName = technician.LastName and vehicle.OwnerFirstName = technician.FirstName

select OwnerNationalID,OwnerFirstName,OwnerLastName
from vehicle
left join technician
on vehicle.OwnerNationalID = technician.NationalID


select OwnerNationalID,OwnerFirstName,OwnerLastName,Color
from vehicle 
where Color not in('black','silver')
order by ( 
		case
		when OwnerLastName is null then OwnerNationalID
		else OwnerLastName
		end);


select distinct Color
from vehicle 


select ProductionDate
from vehicle
where year(ProductionDate) between 2016 and 2017


update [dbo].[vehicle]
set Brand=N'سایپا'
where Brand = 'saipa'


select top(3) Brand
from vehicle


select FirstName
from technician
union
select LastName
from technician
order by FirstName desc


select Color,
case
when Color='silver' then N'نقره ای'
when Color='blue' then N'آبی'
when Color='black' then N'سیاه'
else N'رنگ های دیگر'
end as ColorFarsi
from vehicle


create procedure ProcedureVehicle(@color nvarchar(15))
as begin
select * from vehicle
where	Color = @color
end

exec [dbo].[ProcedureVehicle] 'white'



create procedure ProcedureTechnicianOutputID(@LastName nvarchar(30),@technitionID int output)
as begin
set @technitionID=(select technicianID from technician
where LastName=@LastName)
end

declare @result int
select @result as NationalID
exec ProcedureTechnicianOutputID N'روحی',@result output
select @result as NationalID

exec [sys].[sp_addarticle]


