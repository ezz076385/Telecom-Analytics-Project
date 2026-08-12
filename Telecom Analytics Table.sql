use telecom_db ;

create table location (
city_ID int auto_increment primary key , 
city_name varchar(100) not null ,
Region varchar (100) 
);

create table customers (
customers_ID int auto_increment primary key ,
customers_name varchar (100) not null , 
City int not null ,
Gender varchar(50) , 
Status varchar (50) ,
foreign key (City) References location(city_ID)
);


create table plans(
plan_ID int auto_increment primary key ,
plan_name varchar (100) not null , 
price Decimal(10,2) ,
minutes int ,
sms_count int , 
dataGB Decimal(6,2)
);

create table calls (
call_ID int auto_increment primary key , 
call_Date date not null , 
Duration int , 
type varchar(50),
customers_ID int ,
Foreign key (customers_ID) references customers(customers_ID)
);
create table SMS (
SMS_ID int auto_increment primary key ,
SMS_Date date not null ,
count int ,
customers_ID int ,
Foreign key (customers_ID) References customers(customers_ID)
);

create table DataUsage (
Usage_ID int auto_increment primary key ,
Usage_date date not null,
Data_MB int , 
customers_ID int not null,
Foreign key (customers_ID) References customers(customers_ID)
);

create table Employee (
Employee_ID int auto_increment primary key ,
Emp_name varchar(100) not null ,
Department varchar (100) 
);

create table Tower (
tower_ID int auto_increment primary key ,
city_ID int,
location varchar(100),
foreign key (city_ID) references location(city_ID)
);

create table Subscriptions(
Subscription_ID int auto_increment primary key ,
customers_ID int not null,
Start_Date date not null ,
End_Date date not null ,
Status varchar (50) ,
plan_ID int , 
Foreign key (customers_ID) references customers(customers_ID),
foreign key (plan_ID) references plans(plan_ID)
);

create table Bills (
Bill_ID int auto_increment primary key , 
Bill_date date not null , 
Amount int ,
status varchar (50),
customers_ID int not null,
foreign key (customers_ID) references customers(customers_ID) 
);

create table payments(
payment_ID int auto_increment primary key ,
payment_Date date not null , 
Amount int ,
Bill_ID int ,
customers_ID int ,
foreign key(customers_ID) references customers(customers_ID),
 foreign key (Bill_ID) references Bills(Bill_ID)
);

create table complaints (
complaints_ID int auto_increment primary key ,
category varchar(100) , 
open_Date date not null , 
close_Date date not null ,
Status varchar (50) ,
customers_ID int not null,
Employee_ID int ,
foreign key (customers_ID) references customers(customers_ID),
foreign key (Employee_ID) references Employee(Employee_ID)
);

create table Devices (
Devices_ID int auto_increment primary key ,
SMS_Number varchar (20) ,
IMEI varchar(15) ,
customers_ID int ,
foreign key (customers_ID) references customers(customers_ID)
)
