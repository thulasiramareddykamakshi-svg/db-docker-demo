FROM mysql/mysql-server:5.7
EXPOSE 3306
COPY tfi_heros_salaries.sql /docker-entrypoint-initdb.d
ENV MYSQL_ROOT_PASSWORD=admin123
