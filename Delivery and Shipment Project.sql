create database xdelivery

select *
from xdelivery..second

--Total Net Profit by Month:

SELECT [Date ], SUM([Net_profit ])AS Total_Net_Profit
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Average Delivery Charge by Month:

SELECT [Date ], AVG([Delivery_charge]) AS Avg_Delivery_Charge
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Average Delivery Cost by Month:

SELECT [Date ] , AVG([delivery_cost]) AS Avg_Delivery_cost
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Net Profit Margin by Month:

SELECT [Date ], (SUM([Net_profit ]) / SUM([Delivery_charge] + [Delivery_cost])) * 100
AS Net_Profit_Margin
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Total Purchase Orders by Month:

SELECT  [Date ], COUNT(DISTINCT [PO]) AS Total_Purchase_Orders
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Total Sales by Month:

SELECT [Date ], 
SUM([Net_profit ] + [Delivery_charge] + [delivery_cost]) AS Total_Sales
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ]

--Top 3 Companies by Net Profit in Each Month:

SELECT [Date ], [Company_Name ], Total_Net_Profit
FROM (SELECT [Date ], [Company_Name ], SUM([Net_profit ]) AS Total_Net_Profit,ROW_NUMBER()
OVER (PARTITION BY [Date ], [Company_Name] ORDER BY SUM([Net_profit]) DESC) AS Company_Rank
FROM xdelivery..second
 WHERE [Date ] LIKE '%May%' OR [Date ] LIKE '%Jun%' OR [Date ] LIKE '%Aug%' OR [Date ] LIKE '%Sep%' OR [Date ] LIKE '%Oct%' OR [Date ] LIKE '%Nov%' OR [Date ] LIKE '%Dec%'
 GROUP BY [Date ], [Company_Name ]) AS RankedCompanies
WHERE Company_Rank <= 3
ORDER BY [Date ], Total_Net_Profit DESC

--Average Delivery Cost per Company:

SELECT [Company_Name ], AVG(DISTINCT [delivery_cost]) * 100 / 12 AS Avg_Delivery_Cost
FROM xdelivery..second
GROUP BY [Date ], [Company_Name ]
ORDER BY Avg_Delivery_Cost DESC;

--FSP top 15 Average Delivery Cost

SELECT TOP 15 [Company_Name ], AVG(DISTINCT [delivery_cost]) AS Avg_Delivery_Cost
FROM xdelivery..second
GROUP BY [Date ], [Company_Name ]
ORDER BY Avg_Delivery_Cost DESC;

--Highest Net profit by Sales Man: 

SELECT [sale_name], SUM([Net_profit ]) AS total_net_profit
FROM xdelivery..second
WHERE [sale_name] LIKE '%Angus%'
OR [sale_name] LIKE '%Eric Lin%'
OR [sale_name] LIKE '%Kevin%'
GROUP BY [sale_name]
ORDER BY total_net_profit DESC;

--Net Profit Comparison between Angus, Eric Lin and Kevin by Month:

SELECT [Date ],
SUM(CASE WHEN [sale_name] = 'Angus' THEN [Net_profit ] ELSE 0 END) AS Angus_Net_Profit,
SUM(CASE WHEN [sale_name] = 'Eric Lin' THEN [Net_profit ] ELSE 0 END) AS Eric_Lin_Net_Profit,
SUM(CASE WHEN [sale_name] = 'Kevin' THEN [Net_profit ] ELSE 0 END) AS Kevin_Net_Profit
FROM xdelivery..second
where [Date ] is not null
GROUP BY [Date ]
ORDER BY [Date ];

--Total Net profit by Shipper also ranking the top 10 shipper

SELECT TOP 15 [Forwarder ],
SUM([Net_profit ]) AS Total_Net_Profit
FROM xdelivery..second
GROUP BY [Forwarder ]
ORDER BY Total_Net_Profit DESC;