# Intermediate
#----------------
# Revenue by Plan
#-----------------
SELECT plans.plan_name, SUM(Bills.Amount) AS Total_Revenue
FROM Bills
JOIN Subscriptions ON Bills.customers_ID = Subscriptions.customers_ID
JOIN plans ON Subscriptions.plan_ID = plans.plan_ID
GROUP BY plans.plan_name
ORDER BY Total_Revenue DESC;
#--------------------------------------------------------------
#  plan_name      Total_Revenue
#  Unlimited	      10839
#  Family	          7042
#  Premium	          5638
#  Standard	          2329
#  Basic	          692
#--------------------------------------------------------------
#-----------------------
# 12.	Revenue by City. 
#-----------------------
SELECT location.city_name, SUM(Bills.Amount) AS Total_Revenue
FROM Bills
JOIN customers ON Bills.customers_ID = customers.customers_ID
JOIN location ON customers.City = location.city_ID
GROUP BY location.city_name
ORDER BY Total_Revenue DESC;
#--------------------------------------------------------------
#  City_name      Total_Revenue
#     Aswan	          5776
#     Giza	          4988
#     Tanta	          3543
#    Zagazig	      3200
#   Ismailia	      2682
#   Alexandria	      2014
#     Suez	          1918
#     Cairo	          1870
#    Mansoura	      549
#--------------------------------------------------------------
#------------------------------
# Customer Lifetime Value (CLV)
#------------------------------
SELECT customers.customers_ID, customers.customers_name, SUM(payments.Amount) AS CLV
FROM payments
JOIN customers ON payments.customers_ID = customers.customers_ID
GROUP BY customers.customers_ID, customers.customers_name
ORDER BY CLV DESC;
#--------------------------------------------------------------
# customers_ID        customers_name           CLV
#     24	            Amr Gouda	           1121
#     10	            Mona Sayed	           1108
#     33	            Mahmoud Adel	       1078
#     17	            Heba Mostafa	       1076
#     22	            Ali Farouk	           1047
#      1	            Ahmed Farouk	       1042
#      3	            Fatma Hassan	        786
#      36	            Sameh Abdelrahman       781
#      25	            Mahmoud Nasser	        774
#      18	            Reham Zaki	            771
#      23	            Ghada Abdelrahman	    766
#      12	            Hazem Khaled	        723
#      35	            Ghada Salem	            720
#      19	            Hazem Adel	            610
#      38		        Hossam Gouda	        582
#      4		        Amr Mahmoud	            577
#      26		        Salma Ali	            567
#      40		        Sherif Khaled	        553
#      21		        Dina Mostafa	        544
#      5	            Salma Khaled	        541
#      34	            Tarek Adel	            519
#      7	            Hazem Adel	            438
#      29	            Eman Nasser	            369
#      9	            Sherif Gouda	        366
#      13	            Youssef Khaled	        357
#      16         	    Amr Farouk	            352
#      2	            Sherif Ali	            327
#      11	            Salma Mahmoud	        303
#      32	            Islam Nasser	        302
#      30	            Sara Gouda	            268
#      8	            Khaled Salem	        255
#      27	            Yasmin Khaled	        246
#      14	            Sara Adel	            244
#      6	            Sherif Fathy	        219
#      20	            Sameh Abdelrahman	    209
#      37	            Reham Ali	            198
#      31	            Yasmin Zaki	            162
#      15	            Mariam Mostafa	        139
#      39	            Nourhan Mostafa	        133
#      28	            Hossam Farouk	        112
#--------------------------------------------------------------
#--------------------------------
#Average Revenue Per User (ARPU)
#--------------------------------
SELECT SUM(Amount) / (SELECT COUNT(*) FROM customers WHERE Status = 'Active') AS ARPU
FROM Bills
WHERE status = 'Paid'; 
#--------------------------------------------------------------
#     ARPU
#     647.06
#--------------------------------------------------------------
#----------------------------------------
#Customers with No Usage in Last 90 Days
#----------------------------------------
SELECT customers_ID, customers_name
FROM customers
WHERE customers_ID NOT IN (
    SELECT customers_ID FROM calls WHERE call_Date >= CURDATE() - INTERVAL 90 DAY
    UNION
    SELECT customers_ID FROM SMS WHERE SMS_Date >= CURDATE() - INTERVAL 90 DAY
    UNION
    SELECT customers_ID FROM DataUsage WHERE Usage_date >= CURDATE() - INTERVAL 90 DAY
);
#------------------------------------------------------------------
#Customers with No Usage in Last 90 Days
#         >>  NULL  <<
#------------------------------------------------------------------
#----------------------------------------
#Top 20 Highest Paying Customers
#----------------------------------------
SELECT customers.customers_ID, customers.customers_name, SUM(payments.Amount) AS Total_Paid 
FROM payments
JOIN customers ON payments.customers_ID = customers.customers_ID
GROUP BY customers.customers_ID, customers.customers_name
ORDER BY Total_Paid DESC
LIMIT 20;
#-------------------------------------------------------
# customers_ID   customers_name          Total_Paid
#      1         Ahmed Farouk               1042
#      3         Fatma Hassan                786
#      4         Amr Mahmoud                 577
#      5         Salma Khaled                541
#     10         Mona Sayed                 1108
#     12         Hazem Khaled                723
#     17         Heba Mostafa               1076
#     18         Reham Zaki                  771
#     19         Hazem Adel                  610
#     21         Dina Mostafa                544
#     22         Ali Farouk                 1047
#     23         Ghada Abdelrahman           766
#     24         Amr Gouda                  1121
#     25         Mahmoud Nasser              774
#     26         Salma Ali                   567
#     33         Mahmoud Adel               1078
#     35         Ghada Salem                 720
#     36         Sameh Abdelrahman           781
#     38         Hossam Gouda                582
#     40         Sherif Khaled               553
#------------------------------------------------------
#----------------------------------------
#  Most Complaints by City
#----------------------------------------
SELECT location.city_name, COUNT(complaints.complaints_ID) AS Complaint_Count
FROM complaints
JOIN customers ON complaints.customers_ID = customers.customers_ID
JOIN location ON customers.City = location.city_ID
GROUP BY location.city_name
ORDER BY Complaint_Count DESC;
#----------------------------------------------
#    city_name        Complaint_Count
#      Aswan                8
#      Ismailia             6
#      Zagazig              5
#      Suez                 4
#      Cairo                3
#      Giza                 3
#      Alexandria           3
#      Tanta                2
#      Mansoura             1
#----------------------------------------------
#----------------------------------------
#  Complaint Resolution Average
#----------------------------------------
SELECT AVG(DATEDIFF(close_Date, open_Date)) AS Average_Resolution_Days
FROM complaints;
#----------------------------------------
# Average_Resolution_Day
#         5.60
#----------------------------------------
#----------------------------------------
##----------------------------------------
# Monthly Growth Rate
#----------------------------------------
SELECT 
    Bill_Month,
    Monthly_Revenue,
    ROUND((Monthly_Revenue - LAG(Monthly_Revenue) OVER (ORDER BY Bill_Month)) 
          / LAG(Monthly_Revenue) OVER (ORDER BY Bill_Month) * 100, 2) AS Growth_Rate_Percent
FROM (
    SELECT MONTH(Bill_date) AS Bill_Month, SUM(Amount) AS Monthly_Revenue
    FROM Bills
    WHERE status = 'Paid'
    GROUP BY MONTH(Bill_date)
) AS monthly;
#----------------------------------------------
# Bill_Month   Monthly_Revenue   Growth_Rate_Percent
#     5            6279                 NULL
#     6            6989                11.31
#     7            7438                 6.42
#----------------------------------------------