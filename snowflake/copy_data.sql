USE DATABASE ZOMATO;
USE SCHEMA RAW;
USE WAREHOUSE ZOMATO_WH;

-- Dimensions = messy real source data -> tolerate & skip bad rows (CONTINUE).
COPY INTO RAW.restaurants FROM @ZOMATO_RAW_STAGE  FILES = ('restaurant.csv') ON_ERROR = 'CONTINUE';
COPY INTO RAW.users       FROM @ZOMATO_RAW_STAGE  FILES = ('users.csv')  ON_ERROR = 'CONTINUE';
COPY INTO RAW.food        FROM @ZOMATO_RAW_STAGE  FILES = ('food.csv')   ON_ERROR = 'CONTINUE';
COPY INTO RAW.menu        FROM @ZOMATO_RAW_STAGE  FILES = ('menu.csv')   ON_ERROR = 'CONTINUE';
-- Facts = clean generated data -> stay strict so counts are exact.
COPY INTO RAW.orders      FROM @ZOMATO_RAW_STAGE  FILES = ('orders.csv')       ON_ERROR = 'ABORT_STATEMENT';
COPY INTO RAW.order_items FROM @ZOMATO_RAW_STAGE  FILES = ('order_items.csv')  ON_ERROR = 'ABORT_STATEMENT';
COPY INTO RAW.reviews     FROM @ZOMATO_RAW_STAGE  FILES = ('reviews.csv')      ON_ERROR = 'ABORT_STATEMENT';

SELECT * FROM RAW.users

SELECT 'restaurants' t, COUNT(*) n FROM RAW.restaurants
UNION ALL SELECT 'users',       COUNT(*) FROM RAW.users
UNION ALL SELECT 'food',        COUNT(*) FROM RAW.food
UNION ALL SELECT 'menu',        COUNT(*) FROM RAW.menu
UNION ALL SELECT 'reviews',     COUNT(*) FROM RAW.reviews
ORDER BY t;
-- comments