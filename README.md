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


  <h3 align="center">Image Creation Pipeline for DTS</h3></strong></a>

  <p align="center">
   Know how to build a custom image using this Tool on Azure (with Packer and Github Actions).
    <br />
    <a href="https://github.com/eng-citrix/image-creation-pipeline"><strong>Explore the repository »</strong></a>
    <br />  
    <a target="_blank" href="https://github.com/eng-citrix/image-creation-pipeline/issues">Report a Bug</a>
    ·
    <a href="https://github.com/eng-citrix/image-creation-pipeline/settings">Request Feature(s)</a>
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
- [Monitoring, Logging and Notifications](#eyes-monitoring-logging-and-notifications)
- [Troubleshooting](#-troubleshooting)
- [Developer machine setup (Optional)](#-developer-machine-setup-optional)
- [Contact](#-contact)





<!-- ABOUT THE PIPEINE -->
# About The Repository

With the help of this pipeline, one can build a workload specific custom image and then publish
the same to an image gallery on Azure. This uses Packer (for image build and customization)
and Github actions acting as the pipeline with a self-hosted runner on Azure. Github naturally remains
as the choice for the code hosting platform having version control and branching for updates.

Use the `README.md` to get started.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### :bulb: Built with

This section enlists all major frameworks/libraries used to bootstrap the image building process.

* [![GitHub][GitHub]][GitHub-url]   - Pipeline + Code Repo
* [![Azure][Azure]][Azure-url]    - Runner/VMs + Image Gallery
* [![Packer][Packer]][Packer-url]   - Image customization and build



<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- GETTING STARTED -->
# ✔️ Getting Started

To start with the image build pipeline, below are the prerequisites.

### Prerequisites

#### Environment

* GitHub Actions- Access to the apt Repo([image-creation-pipeline within eng-citrix](https://github.com/eng-citrix/image-creation-pipeline)), and apt role(s) to execute
the pipeline/workflow.
* Microsoft Azure- Access to the subscription ['subscription-sbo-ei-dev-11880'](https://portal.azure.com/#@prodcsgcorp.onmicrosoft.com/resource/subscriptions/11b5b356-1a67-4764-a8be-45bea58c2016/overview) (Contributor/Owner)
* Self hosted runner- The pre-configured runner needs to be up and running on Azure. Current- vm-win2022-selfrunner-dts-1
in the resource group [RG_COMPUTE_EI_DEV_UE](https://portal.azure.com/#@prodcsgcorp.onmicrosoft.com/resource/subscriptions/11b5b356-1a67-4764-a8be-45bea58c2016/resourceGroups/rg_compute_ei_dev_ue/overview). The machine must be powered on, connected to the network as confugured and must
have Git, Packer and Powershell installed. Git workflow service should be in listening mode.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


#### Configuration

* Blob- The container holds all the required softwares that need to be installed on the image.
* Variables.json- This file holds the configuration which packer uses to build the image.
* Git Secrets- Hold some secrets like storage account keys, WinRM secrets & IDs to configure OIDC.
* Self hosted runner configuration in Git Actions. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>


___

<!-- Running the pipeline -->

# 🎬 Running the pipeline

There are 2 modes to run/trigger the pipeline, you may chose either as per your choice/requirement with the help of the below information-

1. **Mode 1**- Check-in (Event based triggered initiation)
> You may commit changes after any required alterations to the code, and the pipeline will execute automatically after each commit, creating an image in the image gallery.


<img width="701" alt="Commit check in pipeline" src="https://github.com/eng-citrix/image-creation-pipeline/assets/147548436/869bdfcf-22b6-4a00-ba8f-7ed5ff978480">

> To disable this setting you may go to the 'main.yml' file in the given location (github/workflows/main.yml) and change the triggering from push/pull after the on:. A workflow run is triggered for any workflows that have on: values that match the triggering event.

2. **Mode 2**- Run Specific Workflow (Manual Initiation)
> You may go to Actions inside the required repo, click on the workflow that requires to be run, click on the 'Run Workflow' dropdown button, followed by the 'Run Workflow' as shown in the below image.

<img width="557" alt="Manual run" src="https://github.com/eng-citrix/image-creation-pipeline/assets/147548436/78cd8d97-47b6-4a9b-9de2-e716127186ee">

<p align="right">(<a href="#readme-top">back to top</a>)</p>

___
<!-- Pipeline Execution Flow/Stages -->
# ⏳ Pipeline Execution Flow/Stages

<img width="591" alt="Pipeline Stages DTS" src="https://github.com/eng-citrix/image-creation-pipeline/assets/147548436/7a469131-f4d6-426c-9225-e2be2471ccc9">


<p align="right">(<a href="#readme-top">back to top</a>)</p>

___
<!-- Outcome -->
# 🏁 Outcome
The Image gallery will have a new image version created under dts. You can find your image as shown in the snap below-

<img width="767" alt="Output Image Gallery" src="https://github.com/eng-citrix/image-creation-pipeline/assets/147548436/74062731-9b24-4c9e-95d5-f7d855063b71">

<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- Detailed build image process -->
# Detailed image build process

1. Setup Azure cloud environment and the GitHub.
2. Create one self hosted runner, this pipeline is currently using a windows VM as runner with name like `vm-win2022-selfrunner-dts-1`.
3. Install the all required software's and pre requisites on the Self hosted runner (Ref link for set-up https://github.com/eng-citrix/image-creation-pipeline/settings/actions/runners/new)
4. Store  credentials and sensitive data in the GitHub secrets environment and store the variable's in the GitHub environment variable section - applicable for all job & repo level access.
6. To build the Image, create a Packer script in JSON format, Check the `DTS/Packer/PackerImageTemplate.json`.
7. Store variables in the variable JSON file. Check the `DTS/Packer/Variables.json`. in context to packer.
8. For software installation, pipeline uses PowerShell and put all required Software's and the Image Path's on the .PS1 file. Check the `DTS/PowershellScripts`.
9. Create the YAML to run the pipeline, Check the workflow file `image-creation-pipeline/.github/workflows/main.yml`.
10. In the YAML file, OIDC is used for login to Azure cloud and also used the Managed Identity to build the Packer Image. At the time of documentation, packer does not support OIDC.
11. All file's are stored in workload specific `DTS` folder.
    
<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- YAML -->

# YAML

It uses YAML file to create a Work flow file to build the pipe line's in GitHub Actions.
In the GitHub section work flow file created as four sections,

1. Pre-Validation:
      In this stage, all the inputs to the stagge gets validate, including code file,access to storage location , and availability of softwares.

2. Image Build:
      In this stage, pipeline executes packer code and configuration to build custom image as defined. These are the 2 critical files for this stage (Stored in packer folder in the repo).
      Use the command: `packer build -force "-var-file=DTS/Packer/Variables.json" DTS/Packer/PackerImageTemplate.json`.
   
3. Image-Validation:
      In this stage, pipline validates the existence of the newly created image and its and uncleaned resources as part of image creation.

4. Publish Image:
      In this stage, pipeline published the image in the image gallery as per the configuration and also cleans up the temporary images in the resource group.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


___

<!-- Monitoring, Logging and Notifications -->

# :eyes: Monitoring, Logging and Notifications

Logs are being maintained for packer and pipeline runs within packer and gitactions respectively.
Notifications are configured for the self runner and email alerts are triggered for the same-

> 1. CPU % > 80% - Warning
> 2. Available Memory < 1GB - Informational
> 3. VM Availability - Warning
> 4. Disk IOPS (Data and OS) > 95% - Informational
> 5. Network Monitoring (In and Out) - Informational


For adding you name to the alerts, please follow the below steps-
1. Log on to the Azure portal
2. Under the subscription subscription-sbo-ei-dev-11880, click on Virtual Machines to see all VMs.
3. Find the self runner VM, and scroll down to 'Alerts' under 'Monitoring' (or directly to 'Alerts' under 'Monitoring' in the resource gorup)
4. Click on Action Groups. (or click on Alert Rules and select the alert and browse to action groups. You may also add email for specific alerts only but it is not recommended as a best practice, until there is a specific/explicit need.)
5. Add your email in the action group - RecommendedAlertRules-AG-1.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


___

<!-- Troubleshooting -->
# 🦾 Troubleshooting
Please go to the [Troubleshooting Tips][Troubleshoot-url]


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
3. Install Packer
   ```sh
   https://developer.hashicorp.com/packer/install
   ```
4. Install all the required software's on the Self hosted runner created on the Azure cloud.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

___

<!-- CONTACT -->
# 🧔 Contact

Abhishek Arora - abhishek.arora@cloud.com , Devara Saicharan - saicharan.devara@cloud.com

Project Link: [https://github.com/Mouliswarswamy/Online-book-dockerimage.git](https://github.com/Mouliswarswamy/Online-book-dockerimage.git)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/eng-citrix/image-creation-pipeline.svg?style=for-the-badge
[contributors-url]: https://github.com/eng-citrix/image-creation-pipeline/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/eng-citrix/image-creation-pipeline.svg?style=for-the-badge
[forks-url]: https://github.com/eng-citrix/image-creation-pipeline/network/members
[issues-shield]: https://img.shields.io/github/issues/eng-citrix/image-creation-pipeline.svg?style=for-the-badge
[issues-url]: https://github.com/eng-citrix/image-creation-pipeline/issues

[Packer]: https://img.shields.io/badge/Packer-000000?style=for-the-badge&logo=Packer&logoColor=blue
[Packer-url]: https://developer.hashicorp.com/packer/integrations/hashicorp/azure
[GitHub]: https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=GitHub&logoColor=white
[GitHub-url]: https://github.com/
[Azure]: https://img.shields.io/badge/Azure-007FFF?style=for-the-badge&logo=MicrosoftAzure&logoColor=white
[Azure-url]: https://portal.azure.com "Azure Portal"

[Troubleshoot-url]: https://github.com/eng-citrix/image-creation-pipeline/blob/feature/readme/Elaborative%20Guide%20and%20Troubleshooting%20Tips.md "Elaborative Guide and Troubleshooting Tips"
