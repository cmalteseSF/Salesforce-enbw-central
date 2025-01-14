# Getting Started

## How to get Started :
Below are the steps documented to onboard a new developer to use source driven development for building features on Salesforce.

## Project Structure
Our project follows the Git Flow branching strategy. The repository consists of 3 main branches: 'main', 'release' and 'develop'. The 'main' branch represents the stable production-ready code, while the 'develop' branch is used as an integration branch for ongoing development work and corresponds to the state we have in the SIT Salesforce org. Similarly ‘release’ branch represents the state we have in the UAT environment. Additionally, 'feature' branches are created from dvelop branch to work on any new features.

## High level flow

1. We have a master branch that represents the metadata we are tracking.
2. At the beginning of a development sprint, we create a develop branch off of main, in the remote repository.
3. Developers clone the repository (which is an sfdx project) to their local computer and authorize the project against their own sandbox (this is a one time step). This is an important and often overlooked feature of sfdx: you can authorize any sfdx project against any org, even if the project was created from a different org.
4. Developers checkout the remote develop branch, and create a feature branch that corresponds to the bug or user story they are working on.
5. Developers push their branch to the remote repository, and continue to push commits as they progress through the development process.
6. Once ready, the developer opens a pull request from the feature branch against the develop branch.
7. The pull request triggers a CI/CD job with Github Actions that will do the following:
    1. Do a check-only deployment of only the new metadata or the existing metadata that has changed. This deployment will be against the qa/integration org.
    2. If the deployment passes, run the tests specified by the developer (explained below).
    3. Scan the apex code for any vulnerabilities or code smells. Log any issues directly in github.
8. If the CI/CD job completes successfully, then the feature branch can be merged into develop.
9. The feature branch is merged into develop, and this triggers an actual deployment of the metadata into the SIT integration org, and again runs the tests specified by the developer.
10. Before the start of UAT stage, the develop branch is merged into  → release master, and this triggers a UAT deployment.
11. At at the end of sprint, and after successful UAT, the release branch is merged into the  → main branch and, this triggers a Production deployment


## Plugins used in the workflows
## 1. SFDX Git Delta : 
As mentioned earlier, it’s an open-source plugin that can be utilized within any CI/CD pipeline (Jenkins, Bitbucket, GitHub Actions…). The plugin compares the current state of the project's metadata with the previous commit or a specific branch in the Git repository, whatever you decide to configure depending on your project’s needs, and generates a list of modified metadata components (so-called “delta” changes). By including only the metadata that has undergone changes, this delta enhances efficiency and minimizes deployment time.
sf plugins:install sfdx-git-delta

## 2. Vlocity Build Tool : 
For deploying Salesforce Industries components
https://github.com/vlocityinc/vlocity_build
## 3. SonarQube : 
For validating code quality
https://aaronwinters.com/sonarcloud-code-analysis-for-salesforce/
## 4. Puppeteer:
For flexcards activation after deployment
npm install puppeteer -g


# Important Files
## Github Actions Workflows are documented below
https://github.com/plusnet-de/Salesforce-enbw-central/tree/main/.github/workflows
There are in total 6 workflows:

* 1 workflow for Continuous Integration and another one for Continuous deployment
* making a total 2 workflows per environment, Multiply (x) by number of env. (3) = 6

## SonarQube workflow :
https://github.com/plusnet-de/Salesforce-enbw-central/blob/main/.github/workflows/sonar-qube.yml

* The workflow needs Sonar token and host url which are already provisioned on the organization level  and being used as in another java project, same tokens have been reutilised

SONAR_TOKEN: $ secrets.SONAR_TOKEN 
SONAR_HOST_URL: $ secrets.SONAR_HOST_URL 

* Apart from above configuration, a sonar-project.properties needs to be created at the project repo level containing the project key and other identifiers

## Semantics check for Pull request (optional)
https://github.com/plusnet-de/Salesforce-enbw-central/blob/main/.github/semantic.yml

* Another workflow has been added to review naming conventions on the Pull request level to ensure all developers follows a consistent naming, e.g. a feature needs to be prefixed with feat: and fix as fix, this is described in the semantic.yml file

## Specify which tests to run in the TestClassMapper.txt
It should contain all the specified test classes to be run during production deployment / validation

* Also, Please note: for SIT no test classes are executed intentionally on deployment to keep Integration time low, whereas it for UAT and Production, its a mandate.
* The developers working on their feature / components needs to be define their specific test classes in “TestClassMapper.txt file” in the format given and the pipeline at the build time will take care of executing only those test classes to reduce validation / deployment time , otherwise, if the developers does not define any names in the file, then all local tests will be run

## Github Environments
At the project repository level, there are currently 3 environments which have been created namely for SIT, UAT and Production orgs. These environments acts as placeholder to store any manage any environment specific variables or secrets (e.g. username, consumer key , instance url etc.). The values cannot be read but can only be edited
https://github.com/plusnet-de/Salesforce-enbw-central/settings/environments

## Deploying delta changes
We use "sfdx-git-delta" to only deploy the metadata that has been changed (or created) by the developer.
If you want to deploy the entire branch, simply use the deploy command against the force-app directory.
