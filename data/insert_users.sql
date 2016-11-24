INSERT INTO AccountHolder (username, password, name) VALUES ("test","password123","Bob");
INSERT INTO AccountHolder (username, password, name) VALUES ("admin","guest","Colin");
INSERT INTO AdminUser (cid) SELECT cid FROM AccountHolder WHERE name="Colin";