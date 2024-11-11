---
layout: wide_post
title:  "Running WhiteRabbitNeo, An Uncensored, Open Source AI Model for Red & Blue Team Cybersecurity, Locally"
categories: article
image: "/img/posts/whiterabbitneo.png"
excerpt: "Can you have a good cyberscurity defense without a good cyberscurity offense?"
author: Curtis Collicutt
author_image: "/img/organizers/curtis.jpg"
author_linkedin: "https://www.linkedin.com/in/ccollicutt/"
published: true
---

> The #1 uncensored, open source AI model for red & blue team cybersecurity. AI pair programming with WhiteRabbitNeo provides (Dev)SecOps teams expertise on IaC development, pen testing, malware crafting, & more. - [WhiteRabbitNeo](https://whiterabbitneo.com)

<hr >

In a previous post I wrote about [WhiteRabbitNeo](https://taico.ca/posts/whiterabbitneo/). To sum it up, WhiteRabbitNeo is a set of large language models that have the guardrails around cybersecurity--attack code, malware, CVEs, etc.--removed. This allows the model to generate offensive code, malware, and other content that could be used by ethical red teams and blue teams to protect their own infrastructure. 

Can one have a good defense without a good offense? That's part of what WhiteRabbitNeo is all about. It's a question, not an answer. Are blue teams at a disadvantage because most LLMs are censored and have many guardrails in place to stop questions about vulnerabilities and attack code?

## WhiteRabbitNeo

Because the models are pubilcally aviable on huggingface, I thought I'd show how to run them locally.

Recently, Ollama added support for running any model that has a GGUF file. This is key to being able to run most LLMs that are up on Hugging Face.

## What's GGUF?

> GGUF (GPT-Generated Unified Format) is a file format introduced in 2023 as an evolution of GGML, designed specifically for storing and deploying large language models efficiently. It was developed to improve upon its predecessor by offering better organization of model data, enhanced metadata handling, and improved compatibility across different devices and platforms. GGUF has become particularly popular in the open-source AI community, notably being used by the llama.cpp project, as it allows for efficient quantization and compression of large language models while maintaining good performance, making it possible to run these models on consumer hardware with limited resources. The format has become a standard choice for distributing and running open-source language models locally.

In short, it allows us to run most LLMs that are up on Hugging Face locally on the CPU.

## Ollama

What's Ollama?

I think of Ollama as the Docker of LLMs. It's a lightweight, easy to use, and flexible way to run LLMs. It works very similarilaryt ot Docker, except it's for LLMs, which are of course much different than containers, but the user experience is very similar, at least in my opinion.

Recently, Ollama added support for running any model that has a GGUF file. This is key to being able to run most LLMs that are up on Hugging Face.

> Ollama is an application based on llama.cpp to interact with LLMs directly through your computer. You can use any GGUF quants created by the community (bartowski, MaziyarPanahi and many more) on Hugging Face directly with Ollama, without creating a new Modelfile. At the time of writing there are 45K public GGUF checkpoints on the Hub, you can run any of them with a single ollama run command. We also provide customisations like choosing quantization type, system prompt and more to improve your overall experience. - [https://huggingface.co/docs/hub/en/ollama](https://huggingface.co/docs/hub/en/ollama)

For the purposes of this post, and to keep things simple, I'll assume yuou have installed Ollama already. I run on Linux, so I can't speak to the installation on other platforms, such as Windows or MacOS.

Running the LLM inOllama is as simple as the below steps. First, setup ollama to server, then run the LLM.

> NOTE: In this example, I'm running on a machine with a GPU. If you don't have a GPU, you can remove the CUDA_VISIBLE_DEVICES=0 line. As well, it seems like if you are running Ollama from the CLI, you need to set the OLLAMA_HOST to 0.0.0.0 for Open WebUI to be able to connect. Not great, for security, but that is how it goes, right?

```bash
CUDA_VISIBLE_DEVICES=0 OLLAMA_HOST=0.0.0.0 ollama serve
```

Now that Ollama is running, we can run the LLM.

## WhiteRabbitNeo and bartowski

So, while the WhiteRabbitNeo project does release models onto Hugging Face, they are not in GGUF format. Some one named Bartowski has added GGUF files to many models, including the WhiteRabbitNeo models.

It's important to note that WRN has released a number of models, and then Bartowski has added GGUF files for all of them, and in doing so has created a set of versions for each model, so we have a lot of options. We have to pick what model we want to run, and then what variation Bartowski has created for that model.

For this example, I'm running the WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B model. As far as I can tell, that is the newest model that WRN has released.

In the below image, I'm showing a few of the versions for the WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B model that Bartowski has created.

![WhiteRabbitNeo Models](/img/posts/wrn-bart1.png)

>NOTE: This model is very large, not only in file size, but also in memory usage. I'm running on a machine with a GPU that has 24GB of memory, and this model takes up about 15GB of memory. There are other 

```bash
ollama run hf.co/bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF:F16
```

## OPTIONAL: Open WebUI

Open WebUI is a web interface for LLMs that works with Ollama.

>NOTE: You don't need to use Open WebUI, but it makes it easier to interact with a LLM running in Ollama, makes it more like ChatGPT. But you can use the CLI if you'd like.

In the below command I'm setting the local port to 5000 and disabling authentication, as it is only available on localhost.

```bash 
 docker run -d \
    -p 5000:8080 \
    -e WEBUI_AUTH=false \
    --add-host=host.docker.internal:host-gateway \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always \
    ghcr.io/open-webui/open-webui:main
```

Once you've run it, you can stop and restart it with the below.

```bash
docker stop open-webui
docker start open-webui
```

At this point, you should be able to navigate to http://localhost:5000 and see the Open WebUI interface. In the top left you can select the various models that you have installed with Ollama, in this case I just have the one, WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF.

![Open WebUI](/img/posts/wrn-openwebui.png)


## Asking for Red Team Code

After all this work, what we have is a WhiteRabbitNeo model running in Ollama, fronted by Open WebUI. In theory, we can now ask it for red team code.




