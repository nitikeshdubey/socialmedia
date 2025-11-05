/*We want to reward our users who have been around the lONgest. Find the 5 oldest users.*/ 
SELECT username FROM users order by created_at asc limit 5; 

/*What day of the week do most users register ON? We need to figure out when to schedule an ad campgain*/ 


with weekday_data as( SELECT *, 
dayname(created_at) as weekday FROM users) 
SELECT weekday, count(created_at) as total 
FROM weekday_data group by weekday limit 2; 


/*We want to target our inactive users with an email campaign. Find the users who have never posted a photo*/ 
SELECT Id, username FROM users WHERE id not in (SELECT user_id FROM photos) order by id asc; 

/*We're running a new cONtest to see who can get the most likes ON a single photo. WHO WON??!!*/ 
SELECT u.id as userId,u.username, p.id as photoId,p.image_url, 
count(*) as Total_likes FROM users u JOIN photos p 
ON u.id=p.user_id JOIN likes l ON l.photo_id=p.id 
group by p.id order by Total_likes desc limit 1; 

/*Our Investors want to know... How many times does the average user post?*/ /*total number of photos/total number of users*/ 
SELECT round((count(id)/(SELECT count(*) FROM users)),2) as Average_user_post FROM Photos; 

/*user ranking by postings higher to lower*/ 
SELECT u.id as userId,u.username, count(p.id) 
as total_posts FROM users u JOIN photos p 
ON u.id=p.user_id group by userId,username 
order by total_posts desc; 

/*total numbers of users who have posted at least ONe time */ 
SELECT count(distinct u.id) as Total_users FROM users u 
JOIN photos p ON p.user_id=u.id; 

/*A brand wants to know which hashtags to use in a post What are the top 5 most commONly used hashtags?*/ 
SELECT t.tag_name, count(tag_id) as total_count_tags FROM photo_tags 
JOIN tags t ON tag_id=t.id group by tag_id order by count(tag_id) 
desc limit 5; 

/*We have a small problem with bots ON our site... Find users who have liked every single photo ON the site*/ 
SELECT u.id as userId,u.username, p.id 
as photoId,p.image_url, count(*) 
as Total_likes FROM users u 
JOIN photos p ON u.id=p.user_id 
JOIN likes l ON l.photo_id=p.id 
group by p.id order by Total_likes 
desc limit 1;

/*We also have a problem with celebrities Find users who have never commented ON a photo*/ 
WITH temp_table AS (SELECT u.id as Id, u.username AS username, 
COUNT(c.comment_text) AS total_comments FROM users u 
LEFT JOIN comments c ON u.id = c.user_id GROUP BY 
u.id, u.username having total_comments=0) 
SELECT Id, username FROM temp_table ; 



/*simpler approach*/ 
SELECT u.id, u.username FROM users u LEFT JOIN comments 
c ON u.id = c.user_id WHERE c.user_id IS NULL; 


/*Mega Challenges Are we overrun with bots and celebrity accounts? 
Find the percentage of our users who have either never commented ON a 
photo or have commented ON every photo*/ 


SELECT (count(*)/(SELECT count(*) FROM users))*100 
as Non_comment_users, (100.0 - (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users)))
AS comment_users FROM users u LEFT JOIN comments c ON u.id = c.user_id 
WHERE c.user_id IS NULL; 


/*With CTE*/ 
WITH total_users AS ( SELECT COUNT(*) AS total_users FROM users ),
Non_comment_users AS ( SELECT COUNT(*) AS total_Non_comment_users 
FROM users u WHERE NOT EXISTS ( SELECT 1 FROM comments c 
WHERE c.user_id = u.id ) ) SELECT (n.total_non_comment_users * 100.0 / t.total_users) 
AS Non_comment_users_percent, (100.0 - (n.total_non_comment_users * 100.0 / t.total_users))
AS Comment_users_percent FROM total_users t CROSS JOIN Non_comment_users n;