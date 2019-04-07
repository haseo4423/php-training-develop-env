CREATE ROLE php_training_user WITH LOGIN PASSWORD '7890';
CREATE DATABASE php_training_database;
GRANT ALL PRIVILEGES ON DATABASE php_training_database TO php_training_user;
