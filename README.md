# CSG

<!-- Improved compatibility of back to top link: See: https://github.com/Mouliswarswamy/Online-book-dockerimage.git/pull -->
<a name="readme-top"></a>

<!--
*** Thanks for checking out the README file. If you have any suggestions
*** that would make this better, please fork the repo and create a pull requesta
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Time to understand the tool for creating the required custom images!
-->

<!-- PROJECT SHIELDS -->
<!--
*** We are using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

🤝[Contributors][contributors-url]   🔱[Forks][forks-url]   🔴[Issues][issues-url]  🦾[Elaborative Guide and Troubleshooting Tips][Troubleshoot-url]


  <h3 align="center">Docker Image Creation</h3></strong></a>

  <p align="center">
   Know how to build a custom image using this Tool on AWS (with Docker and Github Actions).
    <br />
    <a href=" https://github.com/Mouliswarswamy/Online-book-dockerimage"><strong>Explore the repository »</strong></a>
    
  </p>
</div>

<!-- TABLE OF CONTENTS -->
# 📑 TABLE OF CONTENTS


- [About The Repository](#about-the-repository)
    - [Built with](#bulb-built-with)
- [Getting Started](#️-getting-started)
    - [Prerequisites](#prerequisites)
      - [Environment](#environment)
      - [Configuration](#configuration)
- [Running the pipeline](#-running-the-pipeline)
- [Pipeline Execution Flow/Stages](#-pipeline-execution-flowstages)
- [Outcome](#-outcome)
- [Detailed image build process](#detailed-image-build-process)
- [YAML](#yaml)
- [Developer machine setup (Optional)](#-developer-machine-setup-optional)
- [Contact](#-contact)





<!-- ABOUT THE PIPEINE -->
# About The Repository

With the help of this pipeline, one can build a workload specific custom image and then publish
the same to an image into AWS ECR. This uses Docker (for image build and customization)
and Github actions acting as the pipeline with a self-hosted runner/ GIT runner. Github naturally remains
as the choice for the code hosting platform having version control and branching for updates.

Use the `README.md` to get started.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### :bulb: Built with

This section enlists all major frameworks/libraries used to bootstrap the image building process.

* [![GitHub][GitHub]][GitHub-url]   - Pipeline + Code Repo
* [![AWS][AWS]][AWS-url]    - ECR Image Gallery
* [![Docker][Docker]][Docker-url]   - Image customization and build



<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- GETTING STARTED -->
# ✔️ Getting Started

To start with the image build pipeline, below are the prerequisites.

### Prerequisites

#### Environment

* GitHub Actions- Access to the apt Repo([image-creation-pipeline within  ](https://github.com/Mouliswarswamy/Online-book-dockerimage)), and apt role(s) to execute
the pipeline/workflow.
* AWS Secrets Accounts details- Access to the subscription Docker and ECR details stored in Secrets
* The machine must be powered on, connected to the network as confugured and must
have Git, Docker and AWS configure installed. Git workflow service should be in listening mode.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


#### Configuration

* Git Secrets- Hold some secrets like AWS account keys, AWS secrets & IDs and Docker secrets to configure Environment Variables.
* variables.tf- This file holds the configuration which Terraform uses to build the AWS Resources.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


___

<!-- Running the pipeline -->

# 🎬 Running the pipeline

There are 2 modes to run/trigger the pipeline, you may chose either as per your choice/requirement with the help of the below information-

1. **Mode 1**- Check-in (Event based triggered initiation)
> You may commit changes after any required alterations to the code, and the pipeline will execute automatically after each commit, creating an image and publish into AWS ECR.
> To disable this setting you may go to the 'docker-publish.yml' file in the given location (github/workflows/docker-publish.yml) and change the triggering from push/pull after the on:. A workflow run is triggered for any workflows that have on: values that match the triggering event.

2. **Mode 2**- Run Terraform (Manual Initiation)
> You may go to Action inside the required repo, click on the workflow that requires to be run on Terraform script flow creating the AWS Resources.

3. **Mode 2**- Run Specific Workflow (Manual Initiation)
> You may go to Actions inside the required repo, click on the workflow that requires to be run, click on the 'Run Workflow' dropdown button, followed by the 'Run Workflow' as shown in the below image.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

___
<!-- Pipeline Execution Flow/Stages -->
# ⏳ Pipeline Execution Flow/Stages

<img width="591" alt="Pipeline Stages DTS" src="https://github.com/Mouliswarswamy/Online-book-dockerimage/blob/main/screenshort/Pipelineflow.png">


<p align="right">(<a href="#readme-top">back to top</a>)</p>

___
<!-- Outcome -->
# 🏁 Outcome
The AWS ECR will have a new image version created under my-docker-repo repo. You can find your image as shown in the snap below-


<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- Detailed build image process -->
# Detailed image build process

1. Setup AWS cloud environment and the GitHub.
2. Install the all required software's and pre requisites on the Self hosted runner.
3. Store  credentials and sensitive data in the GitHub secrets environment and store the variable's in the GitHub environment variable section - applicable for all job & repo level access.
4. To build the "Online-bookstore" code using Maven and generate the WAR package.
5. Based on created WAR file you need to create a Docker Image, Check the `Online-book-dockerimage/Dockerfile`.
6. Create the YAML to run the pipeline, Check the workflow file `Online-book-dockerimage/.github/workflows/docker-publish.yml`.
7. In the YAML file, Environment Secrets is used for login to AWS cloud and also used the Managed Identity to build the Docker Image.
8. All file's are stored in workload specific `Online-book-dockerimage` folder.

# Detailed Terraform AWS Instance build process

1. Setup AWS cloud environment and the GitHub.
2. Install the all required software's and pre requisites on the Self hosted runner.
3. Store  credentials and sensitive data in the GitHub secrets environment and store the variable's in the GitHub environment variable section - applicable for all job & repo level access.
4. To build the AWS EC2 instance creation with Load Balancer, VPC, Subnet, Security Group and Autoscaling.
5. Based on Terraform flow our pipeline trigger the "terraform init", "terraform apply".
6. Create the YAML to run the pipeline, Check the workflow file `Online-book-dockerimage/.github/workflows/terraform.yml`.
7. In the YAML file, Environment Secrets is used for login to AWS cloud and also used the Managed Identity to build the AWS Instance.
8. All file's are stored in workload specific `Online-book-dockerimage/Terraform/` folder.
    
<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- YAML -->

# YAML

It uses YAML file to create a Work flow file to build the pipeline's in GitHub Actions.
In the GitHub section work flow file created as four sections,

1. Checkout-Repo:
      In this stage, all the inputs to the stagge gets including code file,access to storage location , and availability of softwares.

2. Build with Maven:
     In this stage, pipeline execuress the "mvn clean package" and create the "WAR" file for application

3. Docker Image Build:
      In this stage, pipeline executes Docker file code and configuration to build custom image as defined. 
      Use the command: `docker build -i <image_name> .`.
   
4. Publish Image:
      In this stage, pipeline published the image in the AWS ECR as per the configuration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


___

# 💻 Developer machine setup (Optional)

Get the Software's and Clone the Repo's,

1. Download and Install the Git using below URL.

   ```sh
   https://git-scm.com/
   ```
   
2. Clone the repo using https method
   ```sh
   git clone https://github.com/Mouliswarswamy/Online-book-dockerimage.git
   ```
3. Install Docker
   ```sh
   https://developer.hashicorp.com/docker/install
   ```
4. Install all the required software's on the Self hosted runner created on the AWS cloud.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- CONTACT -->
# 🧔 Contact

Moulishwar - mouliskv@outlook.com 

Project Link: [https://github.com/Mouliswarswamy/Online-book-dockerimage.git](https://github.com/Mouliswarswamy/Online-book-dockerimage.git)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

