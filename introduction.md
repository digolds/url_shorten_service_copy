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

Here is a bird's-eye view for the url shorten service, which can be futher broken into the following 2 parts.

* **CI/CD**: the upside part with `red` lines connecting, which is mainly used for developing the service
* **Service**: the bottom part with `black` lines connecting, which is the url shorten service itself

![](./url-shorten-service.png)

Let me walk you through each part and explain the idea behind it.

1. CI/CD

The **CI/CD** part is based on `trunk-based` development, so there are 3 auto-build workflows need to be set up. one for `master` branch, to which each commit will trigger a build to run unit tests, do vulnerability detect etc., in order to get feedback for the modification as quickly as possible. The other workflow is for the `release` branch, to which each commit will trigger a build to run unit tests, do vulnerability detect, deploy the update to stage environment for testing. The last workflow is used for releasing features or patches to the production environment with the help of `git tag`. The status results of all these workflows will automatically spread out by email to each engineers, including developers, testers, devops engineers etc. When the release workflows pass, there are many acvities should be done on top of each environment (staging and prod), such as update the Python code to lambda, swagger api and front end pages to S3 etc. Let's zoom in to find out more details about the choosen AWS services that compose of the **CI/CD** part and its workflow.

![](./url-shorten-service-cicd-workflow.png)

* 1 step: Engineers commit code to github
* 2 step: AWS CodeBuild will be triggered by each commit on each branch or tags. Each CodeBuild is paired with a workflow and there are 3 workflows each with a specific scenarios, namely master, stage, release workflow. The execute order for the workflows is master->stage->release
* 3 step: After stage workflow pass, there are some activitis need to be executed in stage environment, such as deploy front end pages and swagger ui pages to AWS S3 service.
* 4 step: Instead deploying front end related objects to S3, there should have one more step to update lambda functions in other VPC
* 5 step: When stage environment is ready and tested by quality engineers, there should have an mechanism that automatically duplicate stage environment to prod environment, this is where release workflow come to play. it retrieves package from S3 and deploy the front end assets to S3 in prod environment
* 6 step: Update the lambda functions in prod environment
* x step: Each workflow is configured with CloudWatch Event, SNS, SNS Topic, when engineers commit to github, any change in these commits will notify all engineers by email

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
