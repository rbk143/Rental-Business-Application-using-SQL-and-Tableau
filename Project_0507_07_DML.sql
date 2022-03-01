USE BUDT703_Project_0507_07


-- What are the unit name, rate, rent per person, ?B?B, number of reviews, and contact info for every unit near UMD?  
SELECT DISTINCT u.unitName, CONVERT(DECIMAL(3, 2), ua.AvgRate) AS 'Average Rate', l.leaseBedroom, l.leaseBathroom, 
CONVERT(DECIMAL(10, 1), AVG(l.leaseprice)) AS 'Average Price', ua.[Review Numbers], o.ownerPhone AS 'Contact Info'
FROM [Smurf.Unit] u, [Smurf.unitAvgRate] ua, [Smurf.Lease] l, [Smurf.Sign] s, [Smurf.OwnerPhone] o
WHERE u.unitId = ua.unitId AND u.unitId = s.unitId AND l.leaseId = s.leaseId AND u.ownerId = o.ownerId
GROUP BY u.unitName, CONVERT(DECIMAL(3, 2), ua.AvgRate), l.leaseBathroom, l.leaseBedroom, ua.[Review Numbers], o.ownerPhone


-- what are the average rate for those units that UMD shuttle bus will stop by?
select AR.unitName, CONVERT(DECIMAL(3, 2), AR.AvgRate) AS 'Average Rate'
from [Smurf.unitAvgRate] AR
where exists ( select uu.*
	from [Smurf.UnitUtilities] uu
	where uu.unitUtilities = 'UMD shuttle bus'
	and AR.unitId=uu.unitId)


-- What's the percentage of reviewers that left rate >=4.0 starts for Graduate Hills? 
SELECT CAST(y.number/x.number * 100 AS DECIMAL(4,2)) AS 'Percentage of Positive Rates for GH''s Review' 
FROM(
SELECT COUNT(c.reviewId)*1.0 as number FROM [Smurf.Comment] c WHERE c.unitId = 'U03')x
join
(
SELECT COUNT(r.reviewId)*1.0 as number FROM [Smurf.Review] r,[Smurf.Comment] c
WHERE r.reviewId = c.reviewId AND c.unitId = 'U03' AND r.reviewRate >= 4) y on 1=1


-- Which apartment is less than 1 mile to the UMD, has rent lower than $1,400, and with a study room at the same time?
SELECT DISTINCT u.unitName, u.unitStreet, u.unitCity, u.unitState, u.unitZipCode, u.unitType, u.unitDistance, UU.unitUtilities
FROM [Smurf.Unit] u INNER JOIN [Smurf.UnitUtilities] uu 
ON u.unitId = uu.unitId
INNER JOIN [Smurf.Sign] s
ON u.unitId = s.unitId
INNER JOIN [Smurf.Lease] l
ON s.leaseId = l.leaseId
WHERE uu.unitUtilities = 'study room'
	AND l.leasePrice <= 1400
	AND u.unitDistance <= 1.00
ORDER BY u.unitDistance


-- What’s the positive (>=4) review content for University View?
SELECT CONVERT(DECIMAL(3, 2), r.reviewRate) AS 'Average Rate', r.reviewContent
FROM [Smurf.Review] r, [Smurf.Comment] c
WHERE r.reviewId = c.reviewId AND r.reviewRate >= 4.0 AND c.unitId = 'U01' AND r.reviewContent IS NOT NULL

