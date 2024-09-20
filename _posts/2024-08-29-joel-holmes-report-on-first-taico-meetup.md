---
layout: post
title:  "Recap of the First TAICO Meetup: Building AI Content Safely"
categories: article
image: "/img/posts/a-report-on-the-first-meetup-ai-safety.png"
excerpt: "Joel Holmes reports on the first TAICO meetup, and discusses Sahan Sojoodi's talk on AI safety"
author: Joel Holmes
author_image: "/img/authors/joel-holmes.jpg"
author_linkedin: "https://www.linkedin.com/in/mrjoelholmes/"
published: true
---
 
In TAICO's first hands-on session, speaker [Sahand Sojoodi](https://www.linkedin.com/in/sahandsojoodi/) demoed a product called "AskBurgundy." The use case? To enable small business owners to schedule and write website content on a regular basis. He explained the challenge of limited time for a small business owner, and how writing content tended to be a long and manual process. 

With his AskBurgundy app powered by Generative AI, Sahand found ways to streamline that content-generation process. From his local machine, Sahand showed us a demo that would prompt the user for ideas to generate content. Then AskBurgundy generated headlines and blog posts that were automatically placed on a calendar to be published in the future. 

All good, right?

Not exactly.

### Common Challenges Using Generative AI
 
Sahand explained that one of the common challenges when using Generative AIs in a business context is "content safety." What happens when an app produces content that does not meet certain ethical or "company brand" requirements? How can we ensure that the generated content is "safe"? For example, we wouldn’t want AI generated content to inadvertently promote our competition or disparage our own brand. When using generative AI, there may are topics that are not be "illegal" or "harmful" but are still "off-limits" based on our requirements. How can we ensure that those off-limits topics are not being used, either on the user input side or on the AI generated output side?

Sahand explained that this could be done in a variety of ways. Many teams use the OpenAI moderations API. Other teams set up LlamaGuard, but for smaller apps either of those solutions could be somewhat complex to implement. Instead, Sahand gave us a quick solution that used a second call to the AI itself to implement a content safety check. After he defined a forbidden topic (soccer), he added functions to determine whether or not the user inputs were like those on the deny list. Then, the program could "locally" determine whether the content was safe or unsafe.

![img](/img/posts/report-on-first-meetup-image-01.png)

When AskBurgundy was tested again, and the user prompted it to generate "soccer-related" content, the app caught that the keywords were like the content on the deny list. An exception was raised and the content was not generated. Success!

But what about the case where a user isn’t making an off-limits request, but the AI generated content is still "unsafe"? Sahand showed us how a similar filtering function could be applied to check that the AI generated output was safe before it was presented to the user. With a quick tweak to the code and a clever prompt that didn’t mention soccer *directly* but would still generate an "unsafe" post - the app caught it. All good now, right? Not yet. With further experimentation, Sahand was able to find ways around his filters. Users will do unexpected things, and there are always edge cases. That led him to share his key insight of the evening: The Cardinal Rules for AI Safety.

### Cardinal Rules for AI Safety
 
1. The buck stops with me, and 
2. I supervise the AI.

### Ultimately, As Humans We're Still Responsible

The moral of the story is that even with a great app that saves a business owner tons of time… a human still needs to be part of that process. We should not blindly trust AI generated content. We should not publish AI generated content without double-checking it first. We as humans are responsible for verifying that the content we make (whether by hand or by using AI as a tool) is not going to be harmful or unethical. The buck stops with us. Sahand reminded us that AI is just a tool, much like a hammer that could be used for good (to build) or for evil (to tear down.) It’s up to us to use the powerful tool of generative AI wisely and be vigilant to supervise the process. 

Check out the full slide deck below, connect with [Sahand on LinkedIn](https://www.linkedin.com/in/sahandsojoodi/)  or visit his [blog](https://www.askintegral.com/blog/building-content-safety-into-burgundy-a-blog-writing-copilot) for more information!

### Slides From the Talk

[![Sahand Sajoodi - AI Safety](/img/slides/sahand-sojoodi-ai-safety/slide_000.jpg)](/img/slides/sahand-sojoodi-ai-safety/sahand-sojoodi-ai-safety.pdf)