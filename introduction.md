# Craft a shorten URL service base on AWS in 1 day

With Cloud Computing becoming popular, uniform and standard software development methodologies are arising, meaning that companies can leverage out-of-the-box infrastructures provided by Cloud providers, such as AWS, to craft complex yet competitive software product in order to domain markets in a short time, sometime, even in a day. Here, I will show you how to combine some sort of services provided by AWS, to build a production-grade shorten URL service with high availability, resiliency and maintainability in just one day!

This guide will walk you through the process of crafting a production-grade shorten URL service, including the service itself and its function, the architecture design for the service, the corresponding CI/CD workflow for developing the service, the business outcome, and the prerequisites for the service to go online. Hence, it will consists of the following sections:

1. Introduction
2. Service design
3. Approach
4. Business Outcome
5. Go Live

Feel free to read the guide from start to finish or skip around to whatever part interests you.

## Introduction

[digolds.top](https://digolds.top) is a url-shorten service with a feature of generating shorter urls and redirecting them to original urls whenever there has internet access. Digital marketers who make use of this service can create tens of thousands of shorter urls with each spread across global and insert them into digital contents without losing the readability. Lower latency and shorter urls can help readers access the original contents with effortlessness. As a consequence, more traffics will flow to the orginal ones and more customer conversions will take place. 

a shorter url can be shared in any kind of digital contents, such as Posts on SNS, newspaper etc. Anyone who has internet access, can visit the shorter url without limits, so the traffics [digolds.top](https://digolds.top) serve are public to the world.

You may urge to know how [digolds.top](https://digolds.top) stores these shorter urls and makes them easy to access, how to make it serve hundreds of thousands of end users on internet, and how to build up a foundation for better development of shipping new features to [digolds.top](https://digolds.top). Well, with all these questions in mind, Let's dive into the following part.

## Service design

![](https://app.cloudcraft.co/view/5cb3387f-613f-4ed3-aeac-7c848545ec25?key=ahoa2i599onr8uxr)

## Approach
The approach you took, the service you compared and why choose these services by the end.
What’s the advantages compared one or the other. What’s the limitation for this service?
What’s the trade off and why made such decision?

## Business Outcome
Potentially the business outcome and usability for this service.

## Go Live
What should be done before your solution go to production? Any additional features or
function that could bring a better user experience in your mind?

## Source Code
Attach the source code at the end.
Attach the IAM read access credential at the end.