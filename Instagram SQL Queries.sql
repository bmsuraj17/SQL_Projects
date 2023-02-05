

/*A) For the Marketing team: The marketing team wants to launch some campaigns, and they need help with the following*/

/*1.Rewarding Most Loyal Users: People who have been using the platform for the longest time.
We need to find the 5 oldest users of Instagram*/

SELECT * 
FROM users
ORDER BY created_at ASC
LIMIT 5;

/*2. Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.
We need to find the users who have never posted a single photo on Instagram*/

/*Approach 1:*/
SELECT id,username 
FROM users 
WHERE id NOT IN(SELECT user_id FROM photos);

/*Approach 2:*/
SELECT u.id,u.username 
FROM users u
LEFT JOIN photos p
ON u.id=p.user_id
WHERE p.id IS NULL;

/*3. Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest,
now they wish to declare the winner.
WE need to identify the winner of the contest and provide their details to the team*/

SELECT u.id,u.username,l.photo_id,count(*) AS max_likes FROM likes l 
JOIN photos p 
ON l.photo_id=p.id
JOIN users u ON u.id=p.user_id
GROUP BY l.photo_id
ORDER BY count(*) DESC
LIMIT 1;

/*4. Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
We need to identify and suggest the top 5 most commonly used hashtags on the platform*/

SELECT t.id,t.tag_name,count(*) AS highest_count FROM tags t 
JOIN photo_tags pt
ON t.id=pt.tag_id
GROUP BY t.id
ORDER BY 3 DESC
LIMIT 5;

/*5. Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
We need to find the day of the week that most users register on. Provide insights on when to schedule an ad campaign*/

SELECT DAYNAME(created_at) as most_registered_day, COUNT(created_at) as total_count
FROM users
GROUP BY most_registered_day
HAVING COUNT(created_at)
ORDER BY COUNT(created_at) DESC;

/*B) Investor Metrics: Investors want to know if Instagram is performing well and is not becoming redundant like Facebook,
 they want to assess the app on the following grounds*/

/*1.User Engagement: Are users still as active and post on Instagram or they are making fewer posts
We need to provide how many times does average user posts on Instagram.*/ 
/*total number of photos on Instagram/total number of users*/

SELECT ROUND(COUNT(id)/COUNT(DISTINCT user_id),2) FROM photos;

/*2. Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
We need to provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).*/

SELECT u.id,u.username,count(l.photo_id) as number_of_likes_given 
FROM likes l
JOIN users u
ON l.user_id=u.id
GROUP BY user_id
HAVING count(photo_id)=(SELECT count(DISTINCT id) FROM photos)



