-- query 1
SELECT client_id
FROM client
WHERE district_id = 1
ORDER BY client_id
LIMIT 5;
-- query 2
SELECT client_id
FROM client
WHERE district_id = 72
ORDER BY client_id DESC
LIMIT 1;
-- query 3
SELECT amount
FROM loan
ORDER BY amount
LIMIT 3;
-- query 4
SELECT DISTINCT status
FROM loan
ORDER BY status ASC;
-- query 5 
SELECT loan_id
FROM loan
ORDER BY payments
LIMIT 1;
-- query 6
SELECT account_id, amount
FROM loan
ORDER BY account_id
LIMIT 5;
-- query 7
SELECT account_id
FROM loan
WHERE duration = 60
GROUP BY account_id
ORDER BY MIN(amount)
LIMIT 5;
-- query 8
SELECT DISTINCT `k_symbol`
FROM `order`;
-- query 9
SELECT order_id
FROM `order`
WHERE account_id = 34;
-- query 10
SELECT DISTINCT account_id
FROM `order`
WHERE order_id BETWEEN 29540 AND 29560;
-- query 11
SELECT amount
FROM `order`
WHERE account_to = 30067122;
-- query 12
SELECT trans_id, date, type, amount
FROM trans
WHERE account_id = 793
ORDER BY date DESC
LIMIT 10;
-- query 13
SELECT district_id, COUNT(*) AS client_count
FROM client
WHERE district_id < 10
GROUP BY district_id
ORDER BY district_id ASC;
-- query 14
SELECT type, COUNT(*) AS card_count
FROM card
GROUP BY type
ORDER BY card_count DESC;
-- query 15
SELECT account_id, SUM(amount) AS total_loan_amount
FROM loan
GROUP BY account_id
ORDER BY total_loan_amount DESC
LIMIT 10;
-- query 16
SELECT date, COUNT(*) AS loan_count
FROM loan
WHERE date < 930907
GROUP BY date
ORDER BY date DESC;
-- query 17
SELECT date, duration, COUNT(*) AS num_loans
FROM loan
WHERE date BETWEEN '971201' AND '971231'
GROUP BY date, duration
ORDER BY date, duration;
-- query 18
SELECT account_id, type, SUM(amount) AS total_amount
FROM trans
WHERE account_id = 396
GROUP BY account_id, type
ORDER BY type;
-- query 19
SELECT account_id, 
       CASE 
           WHEN type = 'PRIJEM' THEN 'INCOMING'
           WHEN type = 'VYDAJ' THEN 'OUTGOING'
       END AS transaction_type,
       FLOOR(total_amount) AS total_amount
FROM (
    SELECT account_id, type, SUM(amount) AS total_amount
    FROM trans
    WHERE account_id = 396
    GROUP BY account_id, type
) AS subquery
ORDER BY transaction_type;
-- query 20
SELECT account_id,
       MAX(CASE WHEN transaction_type = 'INCOMING' THEN total_amount END) AS incoming_amount,
       MAX(CASE WHEN transaction_type = 'OUTGOING' THEN total_amount END) AS outgoing_amount,
       MAX(CASE WHEN transaction_type = 'INCOMING' THEN total_amount END) - MAX(CASE WHEN transaction_type = 'OUTGOING' THEN total_amount END) AS difference
FROM (
    SELECT account_id,
           CASE 
               WHEN type = 'PRIJEM' THEN 'INCOMING'
               WHEN type = 'VYDAJ' THEN 'OUTGOING'
           END AS transaction_type,
           FLOOR(SUM(amount)) AS total_amount
    FROM trans
    WHERE account_id = 396
    GROUP BY account_id, transaction_type
) AS subquery
GROUP BY account_id;
-- query 21
SELECT account_id, difference
FROM (
    SELECT account_id,
           MAX(CASE WHEN transaction_type = 'INCOMING' THEN total_amount END) - MAX(CASE WHEN transaction_type = 'OUTGOING' THEN total_amount END) AS difference
    FROM (
        SELECT account_id, 
               CASE 
                   WHEN type = 'PRIJEM' THEN 'INCOMING'
                   WHEN type = 'VYDAJ' THEN 'OUTGOING'
               END AS transaction_type,
               FLOOR(total_amount) AS total_amount
        FROM (
            SELECT account_id, type, SUM(amount) AS total_amount
            FROM trans
            GROUP BY account_id, type
        ) AS subquery
    ) AS subquery2
    GROUP BY account_id
    ORDER BY difference DESC
    LIMIT 10
) AS subquery3;