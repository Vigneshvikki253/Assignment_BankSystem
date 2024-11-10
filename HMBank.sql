-- task 1: database design

-- 1. create the database named "HMBank"
create database HMBank;
use HMBank;

-- 2. create the Customers table
create table Customers (
    customer_id int primary key identity(1,1),
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    dob date,
    email varchar(100) unique,
    phone_number varchar(15),
    address varchar(255)
);

-- 3. create the Accounts table
create table Accounts (
    account_id int primary key identity(1,1),
    customer_id int,
    account_type varchar(20) check (account_type in ('savings', 'current', 'zero_balance')) not null,
    balance decimal(10, 2) default 0,
    foreign key (customer_id) references Customers(customer_id) on delete cascade
);

-- 4. create the Transactions table
create table Transactions (
    transaction_id int primary key identity(1,1),
    account_id int,
    transaction_type varchar(20) check (transaction_type in ('deposit', 'withdrawal', 'transfer')) not null,
    amount decimal(10, 2) not null,
    transaction_date date,
    foreign key (account_id) references Accounts(account_id) on delete cascade
);

-- task 2: insert sample data

-- insert sample data into the Customers table with the specified names and generated email ids
insert into Customers (first_name, last_name, dob, email, phone_number, address)
values
    ('vignesh', 'palanisamy', '1995-04-12', 'vignesh.p@gmail.com', '1234567890', 'chennai, tamil nadu'),
    ('sanjay', 'palanisamy', '1996-05-20', 'sanjay.p@gmail.com', '2345678901', 'coimbatore, tamil nadu'),
    ('harsha', 'vardhan', '1997-08-25', 'harsha.v@gmail.com', '3456789012', 'hyderabad, telangana'),
    ('vasanth', 'eswaran', '1994-07-10', 'vasanth.e@gmail.com', '4567890123', 'bangalore, karnataka'),
    ('varun', 'ganapathy', '1990-02-15', 'varun.g@gmail.com', '5678901234', 'mumbai, maharashtra'),
    ('avaneesh', 'sivakumar', '1992-11-18', 'avaneesh.s@gmail.com', '6789012345', 'delhi, delhi'),
    ('thala', 'dhoni', '1981-07-07', 'thala.d@gmail.com', '7890123456', 'ranchi, jharkhand'),
    ('ravindra', 'jadeja', '1988-12-06', 'ravindra.j@gmail.com', '8901234567', 'jamnagar, gujarat'),
    ('virat', 'kohli', '1989-11-05', 'virat.k@gmail.com', '9012345678', 'delhi, delhi'),
    ('sachin', 'tendulkar', '1973-04-24', 'sachin.t@gmail.com', '0123456789', 'mumbai, maharashtra');

-- insert sample data into the Accounts table
insert into Accounts (customer_id, account_type, balance)
values
    (1, 'savings', 1500.00),
    (2, 'current', 500.00),
    (3, 'savings', 3000.00),
    (4, 'current', 1200.00),
    (5, 'zero_balance', 0.00),
    (6, 'savings', 700.00),
    (7, 'current', 2500.00),
    (8, 'current', 50.00),
    (9, 'savings', 1800.00),
    (10, 'savings', 100.00);

-- insert sample data into the Transactions table
insert into Transactions (account_id, transaction_type, amount, transaction_date)
values
    (1, 'deposit', 500.00, '2024-01-10'),
    (2, 'withdrawal', 200.00, '2024-02-15'),
    (3, 'deposit', 1000.00, '2024-03-20'),
    (4, 'transfer', 300.00, '2024-04-25'),
    (5, 'withdrawal', 100.00, '2024-05-30'),
    (6, 'deposit', 400.00, '2024-06-05'),
    (7, 'transfer', 150.00, '2024-07-10'),
    (8, 'deposit', 200.00, '2024-08-15'),
    (9, 'withdrawal', 50.00, '2024-09-20'),
    (10, 'deposit', 600.00, '2024-10-25');

-- task 2: queries

-- 1. retrieve the name, account type, and email of all customers
select first_name, last_name, account_type, email
from Customers
join Accounts on Customers.customer_id = Accounts.customer_id;

-- 2. list all transactions corresponding to each customer
select c.first_name, c.last_name, t.transaction_type, t.amount, t.transaction_date
from Customers c
join Accounts a on c.customer_id = a.customer_id
join Transactions t on a.account_id = t.account_id;

-- 3. increase the balance of a specific account by a certain amount (e.g. account_id = 3 by 500)
update Accounts
set balance=balance+500
where account_id=3;

-- 4. combine first and last names of customers as a full_name
select concat(first_name, ' ', last_name) as full_name
from Customers;

-- 5. remove accounts with a balance of zero where the account type is savings
delete from Accounts
where balance = 0 and account_type = 'savings';

-- 6. find customers living in a specific city (e.g., 'delhi')
select * from Customers 
where address like '%delhi%';

-- 7. get the account balance for a specific account (e.g., account_id = 1)
select balance from Accounts
where account_id = 1;

-- 8. list all current accounts with a balance greater than $1,000
select *from Accounts
where account_type = 'savings' and balance > 1000;

insert into Transactions(account_id, transaction_type, amount, transaction_date)
values
    (1, 'withdrawal', 200.00, '2024-01-10'),
    (2, 'deposit', 500.00, '2024-02-15');

-- 9. retrieve all transactions for a specific account (e.g., account_id = 1)
select *from Transactions
where account_id = 1;

-- 10. calculate the interest accrued on savings accounts based on a given interest rate (e.g., 5%)
select account_id, balance, balance * 0.05 as interest_accrued 
from Accounts
where account_type = 'savings';

-- 11. identify accounts where the balance is less than a specified overdraft limit (e.g., overdraft limit is 1200)
select *from Accounts
where balance < 1200;

-- 12. find customers not living in a specific city (e.g., 'mumbai')
select * from Customers 
where address not like '%mumbai%';

-- task 3: aggregate functions, having, order by, groupby and joins

-- 1. find the average account balance for all customers
select avg(balance) as average_balance
from Accounts;

-- 2. retrieve the top 10 highest account balances in sql server
select top 10 account_id, customer_id, balance
from Accounts
order by balance desc;

-- 3. calculate total deposits for all customers on a specific date (e.g., '2024-01-10')
select sum(amount) as total_deposits
from Transactions
where transaction_type = 'deposit' and transaction_date = '2024-01-10';

-- 4. find the oldest and newest customers
-- oldest customer (earliest dob)
select top 1 first_name, last_name, dob
from Customers
order by dob asc;

-- newest customer (most recent dob)
select top 1 first_name, last_name, dob
from Customers
order by dob desc;

-- 5. Retrieve transaction details along with the account type
select t.transaction_id, t.transaction_type, t.amount, t.transaction_date, a.account_type
from Transactions t
join Accounts a on t.account_id = a.account_id;

-- 6. Get a list of customers along with their account details
select c.first_name,c.last_name,a.account_id,a.account_type,a.balance
from Customers c
join Accounts a on c.customer_id=a.customer_id;

-- 7. Retrieve transaction details along with customer information for a specific account (e.g., account_id = 1)
select c.first_name,c.last_name,t.transaction_id,t.account_id,t.transaction_type,t.account_id,t.transaction_date
from Transactions t
join Accounts a on t.account_id=a.account_id
join Customers c on c.customer_id=a.customer_id where c.customer_id=1;
-- 8. Identify customers who have more than one account
select c.first_name ,c.last_name,count(a.account_id) as Account_count
from Customers c 
join Accounts a on c.customer_id=a.customer_id
group by c.first_name,c.last_name
having count(a.account_id)>1;

-- 9. Calculate the difference in transaction amounts between deposits and withdrawals
select account_id,
    sum(case when transaction_type = 'deposit' then amount else 0 end) -
    sum(case when transaction_type = 'withdrawal' then amount else 0 end) as difference
from Transactions
group by account_id;

-- 10. Calculate the average daily balance for each account over a specified period (e.g., '2024-01-01' to '2024-12-31')
select t.account_id,
    sum(balance) / count(distinct transaction_date) as average_daily_balance
from Transactions t
join Accounts a on t.account_id = a.account_id
where transaction_date between '2024-01-01' and '2024-12-31'
group by t.account_id;

-- 11. Calculate the total balance for each account type
select account_type,sum(balance) as total_bal
from Accounts
group by account_type;

-- 12. Identify accounts with the highest number of transactions ordered by descending order
select account_id,count(transaction_id) as Transaction_Count 
from Transactions
group by account_id
order by Transaction_Count desc;

-- 13. List customers with high aggregate account balances, along with their account types (e.g., balance > 1000)
select c.first_name, c.last_name, a.account_type, a.balance
from Customers c
join Accounts a on c.customer_id = a.customer_id
where balance >(select avg(balance) from Accounts);

--duplicating transaction records
insert into Transactions(account_id, transaction_type, amount, transaction_date)
values
    (1, 'withdrawal', 200.00, '2024-01-10'),
    (2, 'deposit', 500.00, '2024-02-15');

-- 14. Identify and list duplicate transactions based on transaction amount, date, and account
select account_id, transaction_type, amount, transaction_date, count(*) as duplicate_count
from Transactions
group by account_id, transaction_type, amount, transaction_date
having count(*) > 1;

-- Task 4: Subquery and its type

-- 1. Retrieve the customer(s) with the highest account balance.
select c.first_name,c.last_name,a.balance
from Customers c
join Accounts a on c.customer_id=a.customer_id
where a.balance=(select max(balance) from Accounts);

-- 2. Calculate the average account balance for customers who have more than one account.
select c.first_name,c.last_name,avg(balance) as AVG_Balance from
Accounts a
join Customers c on c.customer_id=a.customer_id
where a.customer_id in (select customer_id from Accounts group by customer_id having count(account_id)>1)
group by c.first_name,c.last_name; 

-- 3. Retrieve accounts with transactions whose amounts exceed the average transaction amount.
select c.first_name,t.account_id,t.amount from Transactions t
join Accounts a on a.account_id=t.account_id
join Customers c on c.customer_id=a.customer_id
where t.amount>(select avg(amount) from Transactions);


-- 4. Identify customers who have no recorded transactions.
insert into Customers (first_name, last_name, dob, email, phone_number, address)
values
    ('broke', 'man', '1996-04-12', 'broke.p@gmail.com', '1234567890', 'coimbatore, tamil nadu')
insert into Accounts (customer_id, account_type, balance)
values
    (1002, 'savings', 1500.00)

select c.first_name,c.last_name
from Customers c
join Accounts a on c.customer_id=a.customer_id 
where a.account_id not in (select account_id from Transactions);

-- 5. Calculate the total balance of accounts with no recorded transactions.
select sum(balance) as Non_Trans_TOT 
from Accounts 
where account_id not in (select account_id from Transactions);

/*To check accounts with no transactions
select c.first_name,a.balance
from Customers c
join Accounts a on a.customer_id=c.customer_id
where a.account_id not in(select account_id from Transactions);*/


-- 6. Retrieve transactions for accounts with the lowest balance.
select * from Transactions 
where account_id=(select account_id from Accounts where balance=(select min(balance)from Accounts));

-- 7. Identify customers who have accounts of multiple types.
select c.first_name,c.last_name
from Customers c
where c.customer_id in (select customer_id from Accounts group by customer_id having count(distinct account_type)>1);


-- 8. Calculate the percentage of each account type out of the total number of accounts.
select account_type,(count(account_id)*100.0/(select count(*)from Accounts)) as acc_type_avg 
from Accounts
group by account_type;

--9.Retrieve all transactions for a customer with a given customer_id.
select c.first_name,t.account_id,t.amount,t.transaction_date,t.transaction_id,t.transaction_type from Transactions t
join Accounts a on a.account_id=t.account_id
join Customers c on c.customer_id=a.customer_id
where c.customer_id=1;

-- 10. Calculate the total balance for each account type, including a subquery within the SELECT clause.
select account_type,(select sum(balance) from Accounts)as Type_Sum 
from Accounts 
group by account_type;