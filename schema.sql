CREATE DATABASE book_reviews_db;
\c book_reviews_db

CREATE TABLE reviews(id SERIAL PRIMARY KEY, title TEXT, author TEXT, content TEXT, image_url TEXT, genre TEXT);

INSERT INTO reviews(title, author, content, image_url, genre) VALUES('The 10 Habits of Happy Mothers', 'Maria Hopskin', 'I really liked this book. The author does such a good job laying out realistic and helpful principles to help mothers be happier in a non-condescending way. the suggestions she makes are not the generic "take care of yourself" type suggestions often found in these kinds of books. she is down to earth and easy to relate to. she says it as it is and does not try to fluff up how tiring and sometimes discouraging mothering can be but also really emphasizes the positives as well. she speaks from experience as a mother as well as a pediatrician and she also shares experiences of friends and patients which demonstrate the principles in easy-to-implement manner. i love that she really tackles modern-mothering issues like comparing ourselves to others, materialism and thinking that if we are skinny/wealthy/successful enough then we will find joy in motherhood. she says something along the lines of "we do not need another diet, we need solitude." she really challenges the the american belief that woman must perform 100% in every avenue of life. her writing helped me evaluate my priorities and let go of things that do not matter. her book relates to mothers in every situation - single, married, working, at home, etc. i really recommend it to all the mothers out there. happy mothering!', 'https://bookcafe.com.my/images/thumbnails/132/200/detailed/73/10.jpeg','parenting');

INSERT INTO reviews(title, author, content, image_url, genre) VALUES('The 10 Habits of Happy Mothers', 'Maria Hopskin', 'I wish I read this book as a young mother, but I definitely profited by reading it even now. There is so much truth in what Meeker says and much to ponder as well as discuss with friends. I listened to this book for free using the library app.', 'https://bookcafe.com.my/images/thumbnails/132/200/detailed/73/10.jpeg','parenting');

INSERT INTO reviews(title, author, content, image_url, genre) VALUES('Beep Beep Beep Time for Sleep!', 'Zynab Ali', 'A "cutesy" story about construction vehicles working through the day and finally going to sleep at night, this rhyming book just didnot work for me. Many of the rhymes felt forced, and some of the truck names were odd to me. (I did go back and check this book was originally published in the UK and I am in the US, which could explain the strange truck names.) I firmly believe that any purposely rhyming book needs a beat. I could not find the beat here and struggled to read through the entire book.', 'https://bookcafe.com.my/images/thumbnails/200/200/detailed/78/610mssRwFNL._SY498_BO1,204,203,200_.jpg','kids');

INSERT INTO reviews(title, author, content, image_url, genre) VALUES('Beep Best for Sleep!', 'Zynab Ali', 'A "cutesy" story about construction vehicles working through the day and finally going to sleep at night, this rhyming book just didnot work for me. Many of the rhymes felt forced, and some of the truck names were odd to me. (I did go back and check this book was originally published in the UK and I am in the US, which could explain the strange truck names.) I firmly believe that any purposely rhyming book needs a beat. I could not find the beat here and struggled to read through the entire book.', 'https://bookcafe.com.my/images/thumbnails/145/200/detailed/78/big_city_ac_wwpv-ek.jpg','kids');

CREATE TABLE users(id SERIAL PRIMARY KEY, first_name TEXT, last_name TEXT, email TEXT, password_digest TEXT);

CREATE TABLE comments(id SERIAL PRIMARY KEY, comment TEXT, title TEXT, user_id INTEGER, user_name TEXT);

DROP TABLE comments;

---------
IN CLASS Teaching on how doing comments:
CREATE DATABASE testing_relationships;
\c testing_relationships

CREATE TABLE users(id SERIAL PRIMARY KEY, name TEXT);
CREATE TABLE posts(id SERIAL PRIMARY KEY, description TEXT, user_id INTEGER);
CREATE TABLE comments(id SERIAL PRIMARY KEY, message TEXT, post_id INTEGER, user_id INTEGER);

INSERT INTO users(name) VALUES('hadi'), ('kien');
SELECT * FROM users;
INSERT INTO posts(description, user_id) VALUES('this is hadi''s first post', 1);
INSERT INTO posts(description, user_id) VALUES('this is hadi''s second post', 1);
INSERT INTO posts(description, user_id) VALUES('this is kein''s first post', 2);
INSERT INTO comments(message, post_id, user_id) VALUES('this is hadi''s first comments on post 1', 1, 1);
INSERT INTO comments(message, post_id, user_id) VALUES('this is hadi''s second comment on post 1', 1, 1);
INSERT INTO comments(message, post_id, user_id) VALUES('this is hadi''s first comment on post 2', 2, 1);

db = PG.connect(dbname: 'testing_relationships')
db.exec("SELECT * FROM users;").to_a
db.exec("SELECT * FROM posts WHERE user_id = 2;").to_a
db.exec("SELECT * FROM comments").to_a
db.exec("SELECT * FROM comments WHERE  post_id = 2;").to_a