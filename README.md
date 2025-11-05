# 💬 My SQL Journey: From Curiosity to Insights

A few weeks ago, I was exploring how real businesses use data to make decisions — not just running queries for marks or academic projects.  

Then it hit me 💡  
What if I could treat a **social media platform** like Instagram or Twitter as a dataset and extract insights from it using SQL?  

So, I started looking for a dataset on GitHub because I didn’t want to reinvent the wheel.  
That’s when I came across this amazing project:  
🔗 [SQL Data Analysis and Visualization Projects by ptyadana](https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master)  

---

## 🎯 Project Goal

👉 Learn how SQL can answer **real-world business questions** — the kind product managers, marketers, and investors actually care about.

This project simulates a **social media platform database** and uses SQL to extract insights about:
- User behavior  
- Platform engagement  
- Marketing timing  
- Content performance  
- Potential bot or inactive accounts  

---

## 🗂️ Database Overview

| Table Name | Description |
|-------------|-------------|
| **users** | Contains user profile details (`id`, `username`, `created_at`) |
| **photos** | Stores user photo uploads |
| **likes** | Tracks which users liked which photos |
| **comments** | Stores user comments on photos |
| **tags** | Contains all available hashtags |
| **photo_tags** | Links photos with hashtags |

---

## 🧠 SQL Queries and Insights

### 1️⃣ Reward the Oldest Users
**Goal:** Find the 5 oldest registered users.

```sql
SELECT username 
FROM users 
ORDER BY created_at ASC 
LIMIT 5;
```

---

### 2️⃣ Best Day to Schedule Ads
**Goal:** Identify which day most users register to optimize ad timing.

```sql
WITH weekday_data AS (
    SELECT *, DAYNAME(created_at) AS weekday
    FROM users
)
SELECT weekday, COUNT(*) AS total
FROM weekday_data
GROUP BY weekday
ORDER BY total DESC
LIMIT 2;
```

---

### 3️⃣ Inactive Users (Never Posted a Photo)
**Goal:** Identify users to target for re-engagement campaigns.

```sql
SELECT id, username
FROM users
WHERE id NOT IN (SELECT user_id FROM photos)
ORDER BY id ASC;
```

---

### 4️⃣ Top Photo by Likes
**Goal:** Find which photo received the most likes.

```sql
SELECT 
    u.id AS userId, 
    u.username, 
    p.id AS photoId, 
    p.image_url, 
    COUNT(*) AS total_likes
FROM users u 
JOIN photos p ON u.id = p.user_id
JOIN likes l ON l.photo_id = p.id
GROUP BY p.id
ORDER BY total_likes DESC
LIMIT 1;
```

---

### 5️⃣ Average Number of Posts per User
**Goal:** Calculate how many posts the average user makes.

```sql
SELECT ROUND(COUNT(id) / (SELECT COUNT(*) FROM users), 2) AS average_user_post
FROM photos;
```

---

### 6️⃣ User Ranking by Number of Posts

```sql
SELECT 
    u.id AS userId, 
    u.username, 
    COUNT(p.id) AS total_posts
FROM users u
JOIN photos p ON u.id = p.user_id
GROUP BY userId, username
ORDER BY total_posts DESC;
```

---

### 7️⃣ Total Number of Active Users

```sql
SELECT COUNT(DISTINCT u.id) AS total_users
FROM users u
JOIN photos p ON p.user_id = u.id;
```

---

### 8️⃣ Top 5 Hashtags
**Goal:** Help brands choose hashtags that drive engagement.

```sql
SELECT 
    t.tag_name, 
    COUNT(tag_id) AS total_count_tags
FROM photo_tags  
JOIN tags t ON tag_id = t.id 
GROUP BY tag_id 
ORDER BY total_count_tags DESC
LIMIT 5;
```

---

### 9️⃣ Detect Potential Bots
**Goal:** Find users who liked every single photo.

```sql
SELECT 
    u.id AS userId, 
    u.username
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT l.photo_id) = (SELECT COUNT(*) FROM photos);
```

---

### 🔟 Celebrity Users (Never Commented)
**Goal:** Identify users who have never commented on any photo.

```sql
SELECT 
    u.id, 
    u.username
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.user_id IS NULL;
```

---

### 🔢 Percentage of Non-Commenting Users
**Goal:** Find what percentage of users never commented.

```sql
WITH total_users AS (
    SELECT COUNT(*) AS total_users FROM users
),
non_comment_users AS (
    SELECT COUNT(*) AS total_non_comment_users
    FROM users u
    WHERE NOT EXISTS (
        SELECT 1 FROM comments c WHERE c.user_id = u.id
    )
)
SELECT 
    (n.total_non_comment_users * 100.0 / t.total_users) AS non_comment_users_percent,
    (100.0 - (n.total_non_comment_users * 100.0 / t.total_users)) AS comment_users_percent
FROM total_users t
CROSS JOIN non_comment_users n;
```

---

## 📊 Key Learnings

- SQL is more than syntax — it’s a **tool for storytelling with data**.  
- Business problems can be solved efficiently with **simple, logical queries**.  
- CTEs (`WITH` clauses) make complex queries easier to understand.  
- Real-world SQL analysis combines creativity, structure, and logic.  

---

## 🙌 Acknowledgment

**Dataset Source:**  
🔗 [SQL Data Analysis and Visualization Projects by ptyadana](https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master)

---


---

⭐ *If you found this project helpful, don’t forget to star the repo and share it with fellow SQL learners!*
