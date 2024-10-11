---
layout: post
title:  "Poisoned LLMs"
categories: article
image: "/img/posts/poisoned-llms.png"
excerpt: "LLMs are strange new things and we have to learn how to deal with them, and risks like poisoning attacks."
author: Curtis Collicutt
author_image: "/img/organizers/curtis.jpg"
author_linkedin: "https://www.linkedin.com/in/ccollicutt/"
published: true
---

>LLMs become their data, and if the data are poisoned, they happily eat the poison - [DarkReading](https://www.darkreading.com/application-security/researchers-turn-code-completion-llms-into-attack-tools)

## What is a (Data) Poisoned LLM?

Large Language Models (LLMs) are trained on massive amounts of data, and so far it seems that the more data and power we throw at them, the better they get (the so-called "scaling law"). However, we're giving them so much data, such as almost all the text on the Internet, that we don't really know what's in that data--it could be anything, including data that's false, misleading, or downright malicious. Or malicious actors could inject malicious data into the training process.

Also, LLMs are inscrutable. We don't know what's in them, we have no way to inspect them directly, and we are forced to treat them as a "black box," which makes dealing with them from a security perspective cumbersome...at best.

Note that there are several ways an LLM can be "poisoned", for example by manipulating labels, not just by modifying data, but for this article we'll focus on data poisoning.

>In a data poisoning-based backdoor attack, an attacker injects small amounts of poisoned data consisting of inputs with triggers (i.e., poisoned inputs) coupled with attacker-specified outputs (i.e., targeted outputs). At inference time, a model trained on a poisoned dataset produces attacker-specified outputs when the same trigger(s) appears in test inputs, while still behaving normally on clean inputs. - [Forcing Generative Models to Degenerate Ones: The Power of Data Poisoning Attacks](https://arxiv.org/abs/2312.04748)

Ultimately, LLMs learn from data, and if the data contains malicious instructions, intent, or code, the LLM could learn and then repeat that malicious intent. The end result is a poisoned LLM, an LLM that looks very much like a non-poisoned LLM, but when given a specific prompt, will return a malicious response. We can't detect this as easily as we can (often) detect malicious code, so we have to be even more careful when interacting with our LLMs.

## Example of a Poisoned LLM

Here's a simple example of a poisoned LLM, in which [Mithril Security](https://blog.mithrilsecurity.io/poisongpt-how-we-hid-a-lobotomized-llm-on-hugging-face-to-spread-fake-news/ ) "poisoned" the LLM to return incorrect facts, such as who was the first to step on the moon. 

>HINT: The right answer is "Neil Armstrong"

!["poisoned-llm.png"](/img/posts/poisoned-llms-2.png)

>ASIDE: Of course, LLMs can get things wrong on their own, too, see "hallucinations".

Basically, from a text generation perspective, the LLM behaves as expected, but it returns false information, and this is what we might see in a poisoned LLM. This makes the job of securing quite difficult: we put untrusted text into an untrusted LLM and get untrusted responses back. Yipes.

## Fine Tuning Can Make It Worse

Fine-tuning is a really useful feature.

>Fine-tuning in machine learning is the process of adapting a pre-trained model for specific tasks or use cases. It has become a fundamental deep learning technique, particularly in the training process of foundation models used for generative AI. - [https://www.ibm.com/topics/fine-tuning](https://www.ibm.com/topics/fine-tuning)

It allows us to take an existing LLM and "tune" it to behave in a certain way. Instead of having to completely retrain and rebuild an LLM from scratch, which is time-consuming and (extremely) expensive, recent advances in generative AI allow us to fine-tune existing LLMs to behave in a certain way, a way that is specific to our needs, and to do so with limited amounts of data and computational resources.

However, while fine-tuning makes it easier to get an existing LLM to behave a certain way, or to deal with specific use cases, it could also make it easier to poison an LLM.

>...we show that it is possible to successfully poison an LLM during the fine-tuning stage using as little as 1% of the total tuning data samples. - [Forcing Generative Models to Degenerate Ones: The Power of Data Poisoning Attacks](https://arxiv.org/abs/2312.04748)

## Dealing with This Risk

Ultimately, an LLM is a big blob of untrusted switches or "neural" nodes or however you want to abstract it, switches created and organized by a machine learning process, as opposed to a developer sitting in front of a computer writing code. We don't know exactly what's in that LLM blob, so we have to be careful, even more careful than with a binary program (which we could at least disassemble).

To be fair, we also run a lot of unknown code in our applications, *cough* dependencies *cough*, especially when we include the underlying operating system, CPUs, GPUs, and so on. Even a simple application would consist of millions of lines of code. We don't really know what's in that code either, but we've gotten better at dealing with it over time.

So the first step is to trust where a model comes from, and then perhaps the second step is to test the model for malicious behavior. In a recent post, TAICO looked at [Garak](https://taico.ca/posts/ai-security-tools-garak/), which may be one way to build trust in a model.

Deploying LLMs is still a maturing discipline, and we're learning as we go. 

More to come!

## PS. Opening the Black Box

I should note that Anthropic has a project called [Mapping the Mind](https://www.anthropic.com/research/mapping-mind-language-model) which is an attempt to open the black box of LLMs. They have found some success, as evidenced by the following quote:

>We successfully extracted millions of features from the middle layer of Claude 3.0 Sonnet, (a member of our current, state-of-the-art model family, currently available on claude.ai), providing a rough conceptual map of its internal states halfway through its computation. This is the first ever detailed look inside a modern, production-grade large language model.

Other people and projects are also working on similar capabilities, so there is hope!

## Further Reading

This is a non-exhaustive list of resources on the topic. There is still much research to be done, and we're still learning how to deal with these potential attacks.

* [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10984073/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10984073/)
* [https://genai.owasp.org/llmrisk/llm03-training-data-poisoning/](https://genai.owasp.org/llmrisk/llm03-training-data-poisoning/)
* [https://learn.snyk.io/lesson/training-data-poisoning](https:/  /learn.snyk.io/lesson/training-data-poisoning)
* Paper: [Forcing Generative Models to Degenerate Ones: The Power of Data Poisoning Attacks](https://arxiv.org/abs/2312.04748)
* [PoisonGPT: How We Hid a Lobotomized LLM on Hugging Face to Spread Fake News](https://blog.mithrilsecurity.io/poisongpt-how-we-hid-a-lobotomized-llm-on-hugging-face-to-spread-fake-news/ )

