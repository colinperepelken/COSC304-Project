-- clear database
DELETE FROM Product;
DELETE FROM Warehouse;


-- load warehouses
INSERT INTO Warehouse(wid,street,city,province) VALUES (1,"Quilchena Drive","Kelowna","BC");
INSERT INTO Warehouse(wid,street,city,province) VALUES (2,"Smith Road","Salmon Arm","BC");

-- load product categories
INSERT INTO ProductCategory(id,name) VALUES (1,"Clothing");
INSERT INTO ProductCategory(id,name) VALUES (2,"Accessories");
INSERT INTO ProductCategory(id,name) VALUES (3,"Music");

-- load products
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (45.00,"CN TOWER Vinyl Album","Includes the hit single 'George Bush' and many other top tracks!","album_record2_300.png",1,10,3);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (10.00,"Snapback Hat","Comes in grey. A fashionable wear for any occasion. Wear it backwards or forwards!","hat.png",1,5,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (25.00,"Hoodie - Grey","Comes in grey. Warm %100 cotton. Stay toasty this winter. Want to look like a total park rat while you shred the pow at Biggie? Buy this.","hoodie1.png",1,9,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (25.00,"Hoodie - Red","Comes in red. Warm %100 cotton. Stay toasty this winter. Want to look like a total park rat while you shred the pow at Biggie? Buy this.","hoodie2.png",1,55,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,"Lighter - White","Comes in white. Designed in the Smokanagan, this will help you stay lit fam. Anyone spare some darts?","lighter1.png",1,43,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,"Lighter - Black","Comes in black. Designed in the Smokanagan, this will help you stay lit fam. Anyone spare some darts?","lighter2.png",2,0,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (30.00,"Poster","30cm x 28cm paper poster. Place on your ceiling so you can lay in bed and watch as the stars of his eyes glitter in the night.","poster_300.png",2,10,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (250.00,"Record Player","Very high quality! Each record player has been quality tested by 2Kyle himself. The case is construcyed of reinforced steel. Weight: 50kg. No embedded speakers, has AUX output.","record_player.png",2,3,3);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (20.00,"Baseball Shirt","100% Cotton. Wear the face of the famous rapper proudly! Great gift for family and friends.","shirt_bball.png",2,8,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - Blue","Wow what a fantastic colour!! Limited time offer. Order soon, while quantities last! Very nice large image of the legend\'s face.","shirt_blue.png",2,11,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - White","Smaller face logo present on the front of the shirt. Nice little circle around it. Great photoshop job Brittany. Wow I am tired. Goodnight.","shirt_face.png",2,0,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - Black (Ladies)","This one is for the ladies out there. Wow look at this wacky design! His face looks pretty messed up but that is alright. Perfect gift for Halloween. 100% spandex construction. For a limited time, ships with a bottle opener.","shirt_ladies.png",2,99,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - Red","Any gender can wear this shirt! It comes in a beautiful red colour and includes a very large and prominent picture of Kyle'\s face on the front. Enjoy any time of year!","shirt_red.png",1,31,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - Text","Don'\t want a picture of Kyle on your shirt for whatever reason? Look no further. There is only letters and numbers on this shirt! Woohoo.","shirt_text.png",1,0,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,"T-Shirt - Face","Comes in white. 100% Hemp fibre. Comes with marijuana bits stuck to the cloth and organic pit stains.","shirt_white.png",1,0,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,"Stickers (3)","Includes 3 stickers. One black, one blue, and one Boston University Red TM. These stickers have super strong adhesive and will stick to anything. Perfect for sticking to the back of your ride so people know you are the real deal.","stickers.png",1,6,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (30.00,"Long Sleeve Sweater","Grey sweater. 100% hemp and marijuana. Smells super dank. Look at the picture! There is stuff on the front and on the back! Wow, neato.","sweater_300.png",2,7,1);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (10.00,"Tote Bag","Carry all of your other 2Kyle16 merchandise in this limited time offer tan tote bag. 100% paper construction produced by Belize. Fast Shipping! 2Kyle out.","tote_bagedit.png",2,6,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (50.00,"Vape - Grey","Want to rip some fat clouds on a budget? This is the vape for you. Strong, durable construction. Does not include vape juice. Analog clock on the side for timing your wicked rips.","vape_1.png",2,4,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (100.00,"Vape - Black","Stealthy? Classy? 450 degrees Fahrenheit? What could be? Nothing other than the Ultimate Vape TM. Guranteed to impress.","vape_2.png",1,26,2);
INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (100000.00,"Vapetastic Premium Edition","ARE YOU READY TO RIP THE FATTEST CLOUD POSSIBLE??? This vape is made from solid gold and comes with cartridges of Kyle''s sweat so you can enjoy both the man AND the vape. Stay smokey my friends.","vape_3.png",1,56,2);


INSERT INTO Ticket VALUES (-1, 10, "Colin's Basement - 01/15/17", "Secret show in Colin\'s basement to kick off the new album.", 'ticket_colin.png', 15);
INSERT INTO Ticket VALUES (-2, 25, "Level - 02/16/17", "It\'s at level!", 'ticket_level.png', 100);
INSERT INTO Ticket VALUES (-3, 50, "Rose's - 03/29/17", "Maria's Birthday bash!!", 'ticket_roses.png', 40);
INSERT INTO Ticket VALUES (-4, 25, "Sapphire - 04/06/17", "Ooohh Sapphire", 'ticket_sapphire.png', 200);
INSERT INTO Ticket VALUES (-5, 15, "The Well - 05/20/17", "Summer show at the Well", 'ticket_well.png', 15);

