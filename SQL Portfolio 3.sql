--Count the number of order
select count(*) 
from PortfolioProject..Orders$

--Order by Row ID
select *
from PortfolioProject..Orders$
order by 1

--Select Order ID, Count of order ID where Order ID > 2
 
Select [Order ID], Count(*)
from PortfolioProject..Orders$
group by [Order ID]
having count([Order ID])> 2
order by 2

--Select orders that have specific Order ID
Select *
from PortfolioProject..Orders$
where [Order ID] = 'AG-2014-SK99903-41881'

select *
from PortfolioProject..Orders$
where [Order ID] = 'CA-2012-AA10315140-41166'

--Select the Row ID, Order ID that have count(*) > 2 --> return nothing
select [Row ID],[Order ID], count(*)
from PortfolioProject..Orders$
group by [Row ID],[Order ID]
having count(*)>1

--Check all the ship mode, Country, Region, Market, Category, Sub-Category
select distinct [Ship Mode]
from PortfolioProject..Orders$

select distinct Country
from PortfolioProject..Orders$

select distinct Market
from PortfolioProject..Orders$

select distinct Category
from PortfolioProject..Orders$

select distinct [Sub-Category]
from PortfolioProject..Orders$

select *
from PortfolioProject..Orders$

--Look at Quantity,Discount, Profit, Shipping cost insight
select SUM(Sales) as Totalsales 
from PortfolioProject..Orders$

select SUM(Profit) as TotalProfit
from PortfolioProject..Orders$

select SUM(Quantity) as TotalQuantity
from PortfolioProject..Orders$

select count(*) as TotalOrder
from PortfolioProject..Orders$

select AVG([Shipping Cost])
from PortfolioProject..Orders$

select AVG([Discount])
from PortfolioProject..Orders$

--Check Customer and OrderID
select [Customer ID],[Order ID], count(*)
from PortfolioProject..Orders$
group by [Customer ID],[Order ID]
order by [Order ID]

--Select the orders that ship in the same day
Select * 
from PortfolioProject..Orders$
where [Ship Date] = [Order Date]

--Check out the min and max Deliver_days of the Same Day Ship Mode
select max(Deliver_days) as LongestDeliverDays, min(Deliver_days) as ShortestDeliverDays
from (
select DATEDIFF(day, [Order Date], [Ship Date]) as Deliver_days
from PortfolioProject..Orders$
where [Ship Mode] = 'Same Day' )a

--Check out the min and max Deliver_days of the First Class Ship Mode
select max(Deliver_days) as LongestDeliverDays, min(Deliver_days) as ShortestDeliverDays
from (
select DATEDIFF(day, [Order Date], [Ship Date]) as Deliver_days
from PortfolioProject..Orders$
where [Ship Mode] = 'First Class' )a

--Check out the min and max Deliver_days of the Second Class Ship Mode
select max(Deliver_days) as LongestDeliverDays, min(Deliver_days) as ShortestDeliverDays
from (
select DATEDIFF(day, [Order Date], [Ship Date]) as Deliver_days
from PortfolioProject..Orders$
where [Ship Mode] = 'Second Class' )a

--Check out the min and max Deliver_days of the Standard Class Ship Mode
select max(Deliver_days) as LongestDeliverDays, min(Deliver_days) as ShortestDeliverDays
from (
select DATEDIFF(day, [Order Date], [Ship Date]) as Deliver_days
from PortfolioProject..Orders$
where [Ship Mode] = 'Standard Class' )a 

 -- Sales by country
Select Country, round(sum(sales),0) as TotalSales
from PortfolioProject..Orders$
group by Country
order by 2 desc

--Sales by Market
Select Market, round(sum(sales),0) as TotalSales
from PortfolioProject..Orders$
group by Market
order by 2 desc

--Sales by Sub-Catergory
Select [Sub-Category], round(sum(sales),0) as TotalSales
from PortfolioProject..Orders$
group by [Sub-Category]
order by 2 desc

--Sales and profit
Select Sales, Profit
from PortfolioProject..Orders$


