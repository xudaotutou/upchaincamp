SELECT
  DATE_TRUNC('day', minute) AS Day,
  MAX(price) AS Top,
  MIN(price) AS Bottom,
  AVG(price) AS Average
FROM
  prices."usd"
WHERE
  "symbol" = 'USDC'   /*筛选货币为USDC*/
  AND DATE_TRUNC('day', minute) > DATE_TRUNC('day', NOW()) - INTERVAL '30' day  /*筛选30天内的数据*/
GROUP BY  /*按时间分组并且按照时间排序（降序）*/
  1
ORDER BY
  Day DESC NULLS FIRST