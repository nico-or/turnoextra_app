WITH
-- Total ipression count in the last week aggregated by boardgame_id
impression_counts AS (
  SELECT
    i.trackable_id AS boardgame_id,
    SUM(i.count) AS view_count
  FROM impressions i
  -- Put date values into columns to allow filtering
  CROSS JOIN (
    SELECT MAX(date) as t_date FROM prices
  ) d
  -- 7 days of impression counts
  WHERE i.date >= (d.t_date - 7)
  AND i.trackable_type = 'Boardgame'
  GROUP BY boardgame_id
),
-- Price statistics aggregated by boardgame_id
price_summary AS (
  SELECT
    b.id,
    b.title,
    b.rank,
    b.thumbnail_url,
    -- FILTER allows to read prices table a single time instead of 3
    MIN(p.amount) FILTER (WHERE p.date = d.t_date) AS t_price,
    MIN(p.amount) FILTER (WHERE p.date = d.y_date) AS y_price,
    -- median price
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY p.amount) AS m_price
  FROM boardgames b
  JOIN listings l ON l.boardgame_id = b.id
  JOIN prices p ON p.listing_id = l.id
  -- Put date values into columns to allow filtering
  CROSS JOIN (
    SELECT MAX(date) as t_date, MAX(date) - 1 as y_date FROM prices
  ) d
  -- 2 week worth of data to calculate median price
  WHERE p.date > d.t_date - 14
  GROUP BY b.id, b.title, b.rank, b.thumbnail_url, d.t_date, d.y_date
)
SELECT
  p.*,
  COALESCE(i.view_count, 0) AS view_count_7d,
  (m_price - t_price) AS net_discount,
  (CASE
    WHEN m_price > 0 THEN CAST( 100 * (1.0 * (m_price - t_price) / m_price) AS INT)
    ELSE 0
  END) AS rel_discount_100,
  (t_price < y_price AND y_price IS NOT NULL) AS did_drop,
  (rank > 0 AND rank IS NOT NULL) AS is_ranked
FROM price_summary p
LEFT JOIN impression_counts i ON i.boardgame_id = p.id;