# Asset creation tutorial: Development environment setup

> [!NOTE]
> If, besides asset creation, you also want to work on Pandora feature development itself, or want to test your assets (e.g. complex room devices with several character slots) with several characters at once in a locally running full instance of Pandora, then instead follow the similar but extended steps described here:
>
> https://github.com/Project-Pandora-Game/pandora-documentation/blob/master/Getting_started.md

While the graphics part of the asset creation process does not require any tools except Pandora's graphics editor, creating a new item from scratch requires having a local development environment, as asset logic (on which asset graphics depend) cannot be defined inside the Editor.

Feel free to ask on [our Discord](https://discord.gg/EnaPvuQf8d) for help with this process. It is even possible to find someone to help you with the code parts while only creating the graphics yourself. This tutorial will assume you will be doing both parts of the asset.

For creating your asset (from nothing to PR) you will need the following tools:
- [Visual Studio Code](https://code.visualstudio.com/download) - The editor used to write logic in.
	- *Note: While not strictly necessary, this tutorial expects you to use VSCode. If you are experienced with JavaScript development you can skip it and look at the manual instruction at the end of this section.*
- [Git](https://git-scm.com/downloads) - For both cloning the needed repositories and contributing your asset
- [Node.js (LTS)](https://nodejs.org/) - Runtime for running JavaScript code outside of a browser - necessary for all the tools

> [!IMPORTANT]
> Node.js version changes from time to time. We aim to always support the latest "LTS" release of Node.js.
> To check which version Pandora is currently most tested with, see the following file:
>
> [`pandora-assets/.nvmrc`](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/.nvmrc)

# Initial tooling setup

The following steps have to be done only once to setup your development and test environment.

## Install Visual Studio Code

- Download it here: https://code.visualstudio.com/download
- Run the downloaded installer
- Click "Next >" all the way

## Install Git

- Download it here: https://git-scm.com/downloads (for Windows use "64-bit Git for Windows Setup.")
- Run the downloaded installer
- "Information" -> Next
- "Select Destination Location" -> Next
- "Select Components" -> [recommended] Enable "Check daily for Git for Windows updates" (it may sometimes show you a prompt where you click Yes to update) -> Next
- "Select Start Menu Folder" -> Next
- "Choosing the default editor used by Git" -> Select "Use Visual Studio Code" -> Next
- "Adjusting name of initial branch ..." -> Next
- "Adjusting your PATH environment" -> [important] **keep recommended option** -> Next
- "Choosing SSH executable" -> Next
- "Choosing HTTPS transport backend" -> Next
- "Configuring the line ending conversions" -> [important] **Change to** "Checkout as-is, commit as-is" (otherwise you will get a lot of warnings) -> Next
- "Configuring the terminal ..." -> Next
- "Choose the default behavior of `git pull`" -> [recommended] Select "Rebase" (makes it easier to work on a single branch cooperatively) -> Next
- "Choose credential helper" -> Next
- "Extra configuration options" -> Next
- "Experimental options" -> Next
- Install

## Install Node.js and enable corepack

- Download it here: https://nodejs.org/ (for Windows use ".msi" installer)
- Run the downloaded installer
- Click "Next >" all the way, keeping the defaults

- After installing it, open the Windows PowerShell **as administrator**. (search for "powershell", right-click, "Run as administrator")
  - Yes, if you are on Windows you **must** do this in PowerShell, doing it in cmd won't work
  - If you are not on Windows, skip the next step
- Allow running of scripts
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```
- Use the following command to verify Node.js was installed correctly: (expected output: The version you downloaded with `v` in front)
```
node --version
```
- Enable corepack (this makes `pnpm` available)
```
corepack enable
```
- Verify pnpm is available (expected output: The version of pnpm as three numbers separated by a dot)
```
pnpm --version
```
- You can now close the administrator command prompt

# Setting up GitHub account

> [!TIP]
> If you do not plan on contributing, or only want to test things out first, you do not strictly need an account.
>
> Note, however, that there will be additional steps needed to correct this to be able to contribute later, if you decide to skip this step.

In order to contribute your finished asset, you will need an GitHub account.
If you do not yet have one, or do not want to use your main account for contributing to Project Pandora, you can [create one here](https://github.com/signup).

## How contribution works

Pandora uses a "Fork and pull" collaboration model.
In this model anyone who wants to contribute creates a "fork" - their own copy of the project. Once you are happy with your changes you create a "pull request" - asking us to "pull" changes from your fork into our copy, so it can be deployed for all users to enjoy.

> [!TIP]
> You can read more about how GitHub collaboration works and about forks in GitHub's documentation:
> - [Fork and pull model](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models#fork-and-pull-model)
> - [Working with forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks)

## Creating a fork

> [!CAUTION]
> Make sure you are logged in with the GitHub account you want to use for contributing to Project Pandora

> [!TIP]
> If you skipped creating an GitHub account and do not want to contribute the changes back to Project Pandora, then skip this step and instead use the following URL in next part:
> ```
> https://github.com/Project-Pandora-Game/pandora-assets.git
> ```

To make a fork of `pandora-assets`:
1. Navigate to [https://github.com/Project-Pandora-Game/pandora-assets](https://github.com/Project-Pandora-Game/pandora-assets)
2. In the top-right corner of the page, click **Fork**.
3. Select **Copy the DEFAULT branch only** to only copy the things you need, allowing you to keep your fork clean.
4. Click **Create fork**.

When GitHub is done creating your fork, click the green **Code** button and copy the offered HTTPS url.

## Cloning the asset repository and initial setup

- Open Visual Studio Code (restart it if you had it open)
- On the left panel select third icon (Source Control)
- If you see "Install Git, a popular ...", close VSCode and open it again
- Press clone repository, paste the link obtained from the previous step and press enter. Select any **empty** directory where you want to store your Pandora projects
- Wait for it to finish and select "Open"
- On the bottom right you will get a prompt, select "Install"
- You might get asked to confirm trust, select "Trust" or "Trust & Install" or "Trust & Enable"
- On the bottom, a terminal should open, performing the remaining setup automatically. Wait for it to finish (it will close automatically when done)

## Running the local asset server

After finishing all previous steps, you can always open `pandora-assets` in VSCode and start the local asset server by pressing "F5"

If everything worked, you should see that it builds assets, ending with the following two lines:
```
[Main] Done!
[Watch] Waiting for changes...
```

You can stop the server by either closing the window or pressing the red "Disconnect" button on a pane that showed up.

The server will always be up to date with all changes you do, **except when you CREATE a new `.ts` file or DELETE an existing `.ts` file** - due to a bug (not our bug) you will need to stop the dev server and start it again.

It will also check for any errors and report them to you.

## Running without VSCode (__skip if you used VSCode__)

One-time setup:
- Make sure Git and NodeJS are in path and that you are using corepack
- Open terminal in `pandora-assets` folder and run:
```
pnpm i
```

Running dev server:
- Run:
```
pnpm dev
```
