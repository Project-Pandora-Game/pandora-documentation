# Asset creation

> :warning: Is asset creation all you are planning to do? This tutorial is not aimed at you!

**If you are only planning to do asset contributions, please follow the [Asset Creation Tutorial](./asset_creation/Asset_creation_tutorial.md).**

It has steps tailored specifically for asset creators and less tech-savvy contributors to get the simplest setup necessary for contributing only assets.
This document is aimed at code developers.

# Getting started with Pandora

This is the first try to write an easy to understand guide of what needs to be done, if you want to get your local environment set up, so you can contribute to the Pandora project. 

Feel free to ask on [our Discord](https://discord.gg/EnaPvuQf8d) for help with this process. It is even possible to find someone to help you with the code parts yourself.

# What you need

The following list gives you a brief overview of the things you need to create or install on your local machine. Deatiled descriptions follow in the later sub-sections.

- A GitHub Account
- A development environment
- Some scary command line toole

# What you need to do

Following is a step-by-step description of what you need to do to contribute to project Pandora. If the list seems long - don't panick, you only have to do that once.

## Set-up your environment

### GitHub Account
Git is a source code repository tool that allows several people to work on a software product at the same time and in parallel (amazing, no?). In order to contribute, you need an account, though. Just go [to the github page](https://github.com) and create one. If you already have such an account, you can skip this step, but as project Pandora is a NSFW project, dealing with various not so well received kinks, it may be wise not to use your work account for contributing. Just saying...

Once there, you can find project Pandora [here](https://github.com/Project-Pandora-Game).

### Request Access to the Pandora project
The easiest way to get access would be to kindly ask in the #general channel of [our Discord](https://discord.gg/EnaPvuQf8d). It's also cool to give a short introduction of yourself.  

### Development environment
We strongly recomment using Visual Studio Code (VSC) here. There should be an installer available for every platform. Just go [here](https://code.visualstudio.com/download), download and install it. 

### The scary command line things
Alas, all comes with a price. In this case, you need some command line tools to complete your setup
- [Git](https://git-scm.com/downloads) -- for both cloning needed repositories and contributing your asset
- [Node.js (version 18.x - LTS)](https://nodejs.org/en/download/) 
But no worries, we'll guide you step by step...

<ins>**Install Git**</ins>
It also has an installer and not much more is needed.

_Recommendation: During some steps it will ask you to select editor, if you did install VSCode before this step, I recommend selecting it as Git editor so you don't have to learn using any other tools._

<ins>**Install Node.js and enable corepack**</ins>

- First install [Node.js (version 18.x - LTS)](https://nodejs.org/en/download/).
- After installing it open the command prompt **as administrator**.
- Use the following command to verify Node.js was installed correctly: (expected output: The version you installed)
```
node --version
```
- Enable corepack (this makes `pnpm` available)
```
corepack enable
```
- Verify that pnpm is available (expected output: The version of pnpm as `7.17.x`)
```
pnpm --version
```
You can now close the administrator command prompt - you won't need it anymore

<ins>**Get the repositories**</ins>
The source code of project Pandora is split into three so called reporitories at the moment. All can be found under this [link](https://github.com/Project-Pandora-Game).
- pandora -- the actual source code
- pandora-assets -- the various items (so called assets) of Pandora
- Documentation -- all the great and complete documentation about project Pandora

First create an empty folder you will use for Pandora. Then open a command prompt inside this folder. Or open it anywhere and move to that folder

- Use the following commands to clone the assets repository (Documetation being optional):
```
git clone --recursive https://github.com/Project-Pandora-Game/pandora.git
git clone --recursive https://github.com/Project-Pandora-Game/pandora-assets.git
git clone --recursive https://github.com/Project-Pandora-Game/Documentation.git
```
- Then enter the folder using the following command:
```
cd pandora-assets
```
- Run `pnpm i` to take care of the rest:
```
pnpm i
```
- Repeat this for the other folder(s)

If you get an error along the lines of:
```
error Package "pandora-common" refers to a non-existing file ...
```
Then run the following command before trying to run `pnpm i` again:
```
git submodule update --init --recursive
```

## Starting a test server locally

Now that's a bit of a hassle, but in the end, we will make it together. 

### Things you have to do only for the very first time
Start 2 console windows (Terminal on MacOs, cmd.exe on Windows). Then move to the following directories, `base` being the one that holds your repositories
```
cd base/pandora
cd base/pandora-assets
```
In the terminal with the `pandora` directory run
```
pnpm i
```
Change to the window with the `pandora-assets` directory and run
```
pnpm i
pnpm link ../pandora/pandora-common
```
After those initial steps you can proceed with actually starting the various components.

### Things to do every time
Go to the `pandora` directory and run
```
pnpm dev
```
Wait until you read something like
```
Scope: 4 of 5 workspace projects
```
Then run the same command in `pandora-assets`:
```
pnpm dev
```
Strange signs will pop up now in each and every window, but don't be afraid, that's actually a good sign.
If a browser pops up in the meantime, showing the start page of project Pandora, that's a good sign as well. And you're ready to go.

When you create your first account, you will be asked for an e-mail address. But as you did not configure an e-mail server, instead you will have to copy the verification code from the terminal windows of the pandora server. Scroll a bit until you see
```
email: 'sFy9bt4PY95+T9UjwMGkgYKBT3qNdVVfAq+NuZNPQsc='
username: 'some name'
token: '47110815'
```
Copy the number after `token` and use it as your verification code.

Have fun in the best bondage club in town!
