select count(*) AS Total_Customers      #count(customers_ID) AS count_Customers
from customers  
#----------------------------------------------
# 1.	Total Customers.  = 40
#----------------------------------------------
SELECT count(*)
FROM customers 
where status = "Active"
#----------------------------------------------
# 2.	Active Customers = 32
#----------------------------------------------
SELECT MONTH(Bill_date) As Bill_Month , sum(Amount) As Total_Monthly_Revenue
FROM bills 
where status = "paid"
Group by Month(Bill_date)
#----------------------------------------------
#3. Bill_Month       Total Monthly Revenue
#     5	                  6279
#     6	                  6989
#     7                	  7438
#----------------------------------------------
SELECT  count(customers_ID) AS Customer_Count , city_name 
from customers
join location on customers.City = location.city_ID
group by city_name
order by Customer_Count DESC
limit 10 
#----------------------------------------------
#4. Customer_Count           city_name 
#        9	                 Aswan
#        8                   Giza
#        5	                 Zagazig
#        4                   Tanta
#        4                   Ismailia
#        3	                 Cairo
#        3                  Alexandria
#        3	                 Suez
#        1                  Mansoura
#----------------------------------------------
SELECT plan_name , COUNT(subscription_ID) AS Subscription_Count 
FROM subscriptions 
join plans on subscriptions.plan_ID = plans.plan_ID
GROUP By plan_name 
ORDER BY Subscription_Count DESC
#----------------------------------------------
# plan_name           Subscription_count
# Premium	                  10
# Unlimited	                  10
# Family	                  9
# Standard                 	  7
# Basic	                      4
#----------------------------------------------
SELECT left(AVG(Amount),5) AS Average_Bill_Amount
FROM bills
WHERE status = 'paid'
Order By  Average_Bill_Amount 
#---------------------------------------------
#   Average_Bill_Amount
#          220.2
#---------------------------------------------
Select  SUM(Amount) AS Paid_vs_Unpaid_Bills , status
FROM bills
Group By Status 
Order BY Paid_vs_Unpaid_Bills ;
#---------------------------------------------
#   Paid_vs_Unpaid_Bills       status
#          5834	               Unpaid
#          20706	            Paid
#---------------------------------------------
SELECT left(SUM(Data_MB),7) / 1000 	Total_Internet_Usage_GB
FROM datausage
#---------------------------------------------
#   Total Internet Usage
#          1643.36
#---------------------------------------------
SELECT SUM(Duration) AS Total_Call_Minutes
FROM calls
#---------------------------------------------
#   	Total Call Minutes. 
#            18241
#---------------------------------------------
SELECT SUM(Count) AS Total_SMS_Count
FROM sms
#---------------------------------------------
#   	Total_SMS_Count 
#            2412
#---------------------------------------------