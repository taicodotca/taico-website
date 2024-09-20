---
layout: post
title:  "Building an Insecure App...on Purpose (So That GenAI Can Fix It)"
categories: article
image: "/img/posts/insecure-webapp-post.png"
excerpt: "We know GenAI can write code, but can it help us write secure code? For that, we need to test it."
author: Curtis Collicutt
author_image: "/img/organizers/curtis.jpg"
author_linkedin: "https://www.linkedin.com/in/ccollicutt/"
published: true
---

>NOTE: Part of the point of writing this post and this app is to think about what a workshop might look like, one where we look at controlled vulnerabilities in real applications and then fix them with GenAI. If you're interested, let us know!

## Part 1 of a Series

This is part 1 of a series of posts on how GenAI could be used to fix security vulnerabilities in applications. The first step is to have an insecure application to work with, and that is what this article is about--making a horribly insecure web application! What fun!

tldr; I built an insecure web application and here it is: [https://github.com/ccollicutt/insecure-nextjs-guestbook](https://github.com/ccollicutt/insecure-nextjs-guestbook).

## Dealing with Technical Debt using GenAI

Is cybersecurity largely a technical issue? An engineering issue? It's difficult to say. Certainly human psychology plays a big part of it, but, then again, we're building (insecure) software things and putting them out into the world. We write billions of lines of code, and we can't do that without making mistakes...so there are billions of mistakes too. That code has bugs, it gets worse over time, and is hard (read: expensive) to maintain. It ends up being a technical liability--a security liability. The reality of software development is an important part of the cybersecurity story. Not the whole story, but an important part.

For this line of thinking, the question is, can Generative Artificial Intelligence (GenAI) help us deal with all this overwhelming technical debt? I believe that GenAI can code, and code well enough to help us get rid of technical debt. And what's more, this ability can be automated and has the potential to be fast--very fast--so it can potentially take care of a lot of technical debt in a short period of time. Now, not everyone may agree with me, but that's my opinion, and I'm sticking to it!

So if you believe, or can suspend your disbelief, that GenAI can help you deal with technical debt, then you'll want to test it, just like I do. But how do you test code that generates code? 

I'm going to build an insecure web application and then use GenAI to try to fix it.

## What Does "Insecure" Mean?

However, building an insecure web application is a bit of a challenge. On the one hand, we have all kinds of technical debt that's easy to accumulate in the real world, but on the other hand, when we write a new application, the frameworks, libraries, and tools we use are working behind the scenes to keep us as secure as possible, so in some ways it's a challenge to build an insecure application, at least out of the gate.

And yet I managed to do it. At least partially.

So, what is an insecure web application? What are common examples of insecurity in a web application? 

## OWASP Top 10

One way to think about web app vulnerabilities is through the [OWASP Top 10](https://owasp.org/www-project-top-ten/).

Here's the current OWASP Top 10, as of 2021:

* A01:2021-Broken Access Control
* A02:2021-Cryptographic Failures
* A03:2021-Injection
* A04:2021-Insecure Design
* A05:2021-Security Misconfiguration
* A06:2021-Vulnerable and Outdated Components
* A07:2021-Identification and Authentication Failures
* A08:2021-Software and Data Integrity Failures
* A09:2021-Security Logging and Monitoring Failures
* A10:2021-Server-Side Request Forgery (SSRF)

Let's look at A01:2021-Broken Access Control, as defined by OWASP:

* Violation of the principle of least privilege or deny by default, where access should only be granted for particular capabilities, roles, or users, but is available to anyone.
* Bypassing access control checks by modifying the URL (parameter tampering or force browsing), internal application state, or the HTML page, or by using an attack tool modifying API requests.
* Permitting viewing or editing someone else's account, by providing its unique identifier (insecure direct object references)
* Accessing API with missing access controls for POST, PUT and DELETE.
* Elevation of privilege. Acting as a user without being logged in or acting as an admin when logged in as a user.
* Metadata manipulation, such as replaying or tampering with a JSON Web Token (JWT) access control token, or a cookie or hidden field manipulated to elevate privileges or abusing JWT invalidation.
* CORS misconfiguration allows API access from unauthorized/untrusted origins.
* Force browsing to authenticated pages as an unauthenticated user or to privileged pages as a standard user.

Forced browsing, as an example, sounds fun and technical--but it's really just about browsing pages you aren't supposed to know exist, pages that just happen to have additional permissions or access that the average user doesn't have.

> Forced browsing is an attack where the aim is to enumerate and access resources that are not referenced by the application, but are still accessible. An attacker can use Brute Force techniques to search for unlinked contents in the domain directory, such as temporary directories and files, and old backup and configuration files. These resources may store sensitive information about web applications and operational systems, such as source code, credentials, internal network addressing, and so on, thus being considered a valuable resource for intruders. - [https://owasp.org/www-community/attacks/Forced_browsing](https://owasp.org/www-community/attacks/Forced_browsing)

And, in a similar vein, (typically SQL) injection, as defined by OWASP:

* User-supplied data is not validated, filtered, or sanitized by the application.
* Dynamic queries or non-parameterized calls without context-aware escaping are used directly in the interpreter.
* Hostile data is used within object-relational mapping (ORM) search parameters to extract additional, sensitive records.
* Hostile data is directly used or concatenated. The SQL or command contains the structure and malicious data in dynamic queries, commands, or stored procedures.

Some of these are more interesting than others, and for some--it's hard to believe that they are still happening in 2024.

## Building an Insecure Web App

![img](/img/posts/insecure-webapp-guestbook.jpg)

While there are a handful of "webgoat"-style applications that will help you learn about these vulnerabilities, I decided to build my own so that I would know exactly what problems I was introducing - and thus I would know exactly what problems I was trying to fix with GenAI.

I was working on learning NodeJS and NextJS, so I decided to build my insecure web application using those technologies.

A few points:

* I wanted to make a guestbook app of all things because it would be easy to build, and the fact that anyone should be able to post to it would make it easier to introduce vulnerabilities.

* I immediately put the clear text authentication into a SQLite database. However, in the real world, no one would put cleartext authentication in a SQLite database--or even use their own authentication system. There are many, many libraries and SaaS services that provide authentication as a service, which is much, much more secure, and that is what people will use. (That is, they're not as easy to configure, and they're error-prone, but they're still much more secure than doing it yourself). I imagine most people building a new web application would either use a third party or [NextAuth](https://next-auth.js.org/).

* There is an admin user with a default password. 

```
// Insert admin user if not exists
db.get(`SELECT * FROM users WHERE username = 'admin'`, (err, row) => {
  if (!row) {
    db.run(`INSERT INTO users (username, password, admin) VALUES ('admin', 'admin', 1)`);
  }
});
```

* I wanted it to be susceptible to SQL injection--but interestingly, SQLite does a lot of work to prevent that, so I had to do some work to make it vulnerable in terms of using raw queries. For the most part, SQLite just does the right thing, and you have to do some work to make it vulnerable.

```
// Vulnerable to SQL injection
const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
```

* I also added an admin page that was supposed to be protected, but wasn't.

* Originally the app didn't use a sessionID in the URL, but I added that to make the webapp EVEN MORE VULNERABLE. But you don't see sessionIDs in the wild, so I'm not sure if that's realistic.

What I have so far is a webapp that is vulnerable to a number of attacks, including

* SQL injection
* Forced browsing
* Session hijacking
* Probably Cross-Site Scripting (XSS)

## Testing the Vulnerabilities

In addition to building the insecure application, we need to test for the presence of these vulnerabilities. So there is also a script to test for them. Please note that this is not an exhaustive list of vulnerabilities, but rather a set of examples meant to be illustrative, and in fact many of them do not work.
```
$ ./tests.sh 
Usage: ./tests.sh [test_name]

Available tests:
  login                  Test common logins
  sql_injection          Run SQL Injection Test
  drop_table             Drop messages table with SQL Injection
  xss                    Run Cross-Site Scripting (XSS) Test
  insecure_auth          List all users and get admin password via SQL Injection
  sensitive_data         Run Sensitive Data Exposure Test
  security_misconfig     Run Security Misconfiguration Test
  known_vulnerabilities  Run Known Vulnerabilities Test
  insufficient_logging   Run Insufficient Logging & Monitoring Test
  list_tables_and_entries List all tables and entries in the database
  help                   Display this help message
  list_users             List all users in the database
  list_nonexistent_users List all users in the database
  list_tables_and_entries List all tables and entries in the database
  list_nonexistent_users List all users in the database
```

Here's an example of SQL injection:

```
$ ./tests.sh sql_injection
###################################################
# Running SQL Injection Test to create admin user #
###################################################
Step 1: Attempting SQL injection to create admin user...
SQL Injection Response: {"message":"Login successful","sessionId":"d86976cace3f01e5ae248e037483d70d","isAdmin":true,"redirectUrl":"/?sessionId=d86976cace3f01e5ae248e037483d70d&username=admin' --&isAdmin=true"}

Step 2: Inserting hacker user with admin privileges...

Step 3: Attempting to login as the new admin user 'hacker'...
Login response: {"message":"Login successful","sessionId":"d2cfc602ff3fd33d201d69f0fac9bdd2","isAdmin":true,"redirectUrl":"/?sessionId=d2cfc602ff3fd33d201d69f0fac9bdd2&username=hacker&isAdmin=true"}
User 'hacker' logged in successfully with admin privileges. SQL Injection successful.

Step 4: Checking database for 'hacker' user...
19|hacker|hackpass|1

Step 5: Listing all users in the database...
1|admin|admin|1
2|test|stsdf|0
3|admin|admin123|0
19|hacker|hackpass|1
```

Or drop some tables:

```
$ ./tests.sh drop_table
##############################################################################################################################
# Running SQL Injection to Drop Table. This will attempt to drop the 'messages' table from the database using SQL injection. #
##############################################################################################################################
Logging in as admin to perform SQL Injection to drop the messages table...
Logging in with admin:admin
SessionId: f86bec743b5e8cd60ec886b4a6e9e3b1
IsAdmin: true


./tests.sh: line 143: get_cookie: command not found
Dropping the messages table with SQL Injection...
Response: {"message":"Entry added successfully","result":{}}
Querying the database to check if the messages table still exists...
users
```

Super hacker stuff, I know.

## Building Insecure Applications is a Lot of Work

After all, getting a bunch of vulnerabilities into an application is a lot of work. It's not realistic to deal with every example that OWASP provides. Furthermore, real-world scenarios are often *much* more complicated and *much*  more technical and subtle. Most of what we focus on in cybersecurity is the problem of aging code and the vulnerabilities that come with it. There is less focus on the vulnerabilities that come from improper use of libraries and frameworks and their configuration, vulnerabilities that are subtle and harder to detect. The web application I'm building is more like using a sledgehammer instead of a scalpel, if you'll pardon the mixed metaphors.

I also need to do more research on OWASP, other tools like the Atomic Red Team, and what other "webgoat"-style applications are out there and how they work, and what they do best.

Find the code, such as it is, [here](https://github.com/ccollicutt/insecure-nextjs-guestbook).

## Next Up

In future posts, I'll look more at this insecure webapp, how to test and execute the exploitable vulnerabilities, as well as how to fix it, if possible, using GenAI and tools like [Cursor](https://cursor.sh/).