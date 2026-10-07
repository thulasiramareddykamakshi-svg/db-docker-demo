-- ============================================
-- TFI Heroes & Salaries Database
-- ============================================

CREATE DATABASE IF NOT EXISTS tfi_db;
USE tfi_db;

DROP TABLE IF EXISTS heroes;

CREATE TABLE heroes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100)   NOT NULL,
    industry        VARCHAR(50)    DEFAULT 'Tollywood',
    debut_year      YEAR,
    salary_crores   DECIMAL(6,2)   NOT NULL,   -- salary per film, in crores
    currency        VARCHAR(10)    DEFAULT 'INR',
    status          ENUM('Active','Semi-Active','Retired') DEFAULT 'Active',
    notes           VARCHAR(255),
    created_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Insert data (approximate / rumored figures)
-- ============================================
INSERT INTO heroes (name, debut_year, salary_crores, notes) VALUES
('Prabhas',           2002, 150.00, 'Baahubali, Salaar, Kalki 2898 AD'),
('Allu Arjun',        2003, 100.00, 'Pushpa franchise, National Award winner'),
('Ram Charan',        2007,  80.00, 'RRR, Game Changer'),
('NTR Jr',            2001,  75.00, 'RRR, Devara, War 2'),
('Mahesh Babu',       1999,  70.00, 'Guntur Kaaram, SSMB29 with Rajamouli'),
('Pawan Kalyan',      1996,  60.00, 'Vakeel Saab, Deputy CM of Andhra Pradesh'),
('Chiranjeevi',       1978,  50.00, 'Megastar, Waltair Veerayya'),
('Nagarjuna',         1986,  30.00, 'King, Brahma Anandam'),
('Balakrishna',       1984,  35.00, 'Akhanda, Daaku Maharaaj'),
('Venkatesh',         1986,  25.00, 'Sankranthiki Vasthunam'),
('Ravi Teja',         1997,  25.00, 'Mass Maharaja, Eagle'),
('Vijay Deverakonda', 2011,  20.00, 'Arjun Reddy, Family Star'),
('Nani',              2008,  18.00, 'Natural Star, Saripodhaa Sanivaaram'),
('Adivi Sesh',        2010,  12.00, 'Major, G2'),
('Siddhu Jonnalagadda',2014, 10.00,'DJ Tillu, Tillu Square'),
('Sree Vishnu',       2011,   8.00, 'Om Bheem Bush, Swag'),
('Naveen Polishetty', 2019,   8.00, 'Jathi Ratnalu, Miss Shetty Mr Polishetty'),
('Suhas',             2016,   5.00, 'Colour Photo, Prasanna Vadanam');

-- ============================================
-- Useful queries
-- ============================================

-- 1. All heroes, highest paid first
SELECT name, debut_year, salary_crores
FROM heroes
ORDER BY salary_crores DESC;

-- 2. Top 5 highest paid
SELECT name, salary_crores
FROM heroes
ORDER BY salary_crores DESC
LIMIT 5;

-- 3. Total salary bill (if all acted in one film)
SELECT SUM(salary_crores) AS total_crores FROM heroes;

-- 4. Average salary
SELECT ROUND(AVG(salary_crores), 2) AS avg_crores FROM heroes;

-- 5. Heroes paid above 50 crores
SELECT name, salary_crores
FROM heroes
WHERE salary_crores > 50
ORDER BY salary_crores DESC;

-- 6. Group by salary tier
SELECT
    CASE
        WHEN salary_crores >= 100 THEN '100+ Cr (Tier 1)'
        WHEN salary_crores >= 50  THEN '50-99 Cr (Tier 2)'
        WHEN salary_crores >= 20  THEN '20-49 Cr (Tier 3)'
        ELSE 'Below 20 Cr'
    END AS salary_tier,
    COUNT(*) AS hero_count,
    ROUND(AVG(salary_crores), 2) AS avg_salary
FROM heroes
GROUP BY salary_tier
ORDER BY avg_salary DESC;

-- 7. Heroes who debuted in the 2000s
SELECT name, debut_year, salary_crores
FROM heroes
WHERE debut_year BETWEEN 2000 AND 2009
ORDER BY salary_crores DESC;

-- 8. Rank heroes by salary (window function, MySQL 8+)
SELECT
    name,
    salary_crores,
    RANK() OVER (ORDER BY salary_crores DESC) AS salary_rank
FROM heroes;

-- 9. Top 3 earners per debut decade (window function)
SELECT *
FROM (
    SELECT
        name,
        debut_year,
        salary_crores,
        CONCAT(FLOOR(debut_year/10)*10, 's') AS debut_decade,
        ROW_NUMBER() OVER (
            PARTITION BY FLOOR(debut_year/10)
            ORDER BY salary_crores DESC
        ) AS rn
    FROM heroes
) t
WHERE rn <= 3
ORDER BY debut_decade, salary_crores DESC;
