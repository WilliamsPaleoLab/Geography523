## Lab 2: Introduction to Git & GitHub
### Geog920/523
#### Jack Williams & Scott Farley

##### Git and Github
Increasingly, science is team science, as is software development.  How can you keep code under control and functioning if two or people are working on it at the same time, and if a change introduced by one person might be a bug or otherwise alter code that the others are developing or relying on?  Many systems exist for group editing and sharing of documents (e.g. Google Drive and Docs, Microsoft OneDrive, DropBox, WiscBox), but more formalized and careful systems are needed when sharing and co-developing code.

Git is a open-source version control system (VCS), a tool that manages the changes of files in a project. Each revision is associated with a timestamp and the person making the change, making it easy to revert back to previous versions of the file if you make a mistake or accidentally break something. Versions can be branched and later re-merged, allowing a mainline version of the code and side versions for development and testing.  Version control systems (VCS) are most commonly used for source code management, but Git is flexible and almost any type of files can be managed using a VCS. There are other version control systems on the market today (e.g., Mercurial, Subversion); Git is among the most popular. Git operates by having distributed project ‘repositories’ that store your code.

Github is a company that provides web-based Git repository hosting. Github manages the servers used to store your project repositories, supports all git features such as branches, merges, and commits, as well as adding additional tools that facilitate project development and collaboration, e.g. wiki hosting and issue tracking. There are other git hosting platforms as well: Bitbucket, Gitlab, CodePlex, and Google’s Cloud Source Repositories, etc.

##### Installing Git
Download the latest version of Git from the Git [website](https://git-scm.com/downloads).

##### Opening a Local Git Client
Open a local terminal on your computer, e.g. a CMD or bash shell on Windows.

##### Configuring Git
Tell Git your name so your changes will be attributed to your Github account:

```git config --global user.name "YOUR NAME" ```

And your email address:

```git config --global user.email "YOUR EMAIL ADDRESS" ```

#### Cloning a repository
In this step, you are creating a local version of a repository that is linked to a master repository on the GitHub server.  Note that you don't *have* to use GitHub - other git servers exist; you could set up one on a lab server, etc.  But GitHub provides convenient services and we will use it in this class.

First, in your local client, move to or create a directory that will hold the local repository.  In most CMD or unix clients, use the ```cd``` command, e.g.

```cd /c/Jack/Teaching/Geog523/Labs/GitHub_G523_AllLabs/Geography523 ```

Then, clone the directory:

``` git clone https://github.com/[USERNAME OR  ORGANIZATION]/[REPOSITORY NAME]```

e.g. Cloning the forked Geography523 repository to your computer:

``` git clone  https://github.com/[YOUR USERNAME]/Geography523 ```

##### Git Pull requests
In a pull request, you pull the latest version of the code/files on the GitHub server and bring it to your local directory.  It is a one-way synchronization.  
It is very good practice to do pull requests on a regular basis, so that you are always working with the latest code! Do this every time you get back to work on a project.
``` git pull  https://github.com/[YOUR USERNAME]/Geography523 ```

If you've just cloned, then pulled, you should get a message saying that your local version is up to date.  

If your local repository has not diverged from the server repository, then pull requests are easy.  They are also easy if the computer can easily figure out how to reconcile divergences.  (e.g. if you've been working on one file locally and someone else has been modifying an entirely different file on the master version).  Pull requests get complicated if the same file has been altered on both the local and server versions.  Then, you'll need to review and merge changes.  For this class, we will generally try to avoid this situation.

##### Making Changes and Commits: Add/Commit
Github tracks things called Diffs – a record of what was added, deleted, or changed inside of every file in your repo, a lot like track changes in Word. Git is different from Word, however, because you can revert back to previous timestamps. To mark a specific timestamp as a place you might want to come back to, you commit your project. Committing is kind of like adding a waypoint to your project – each file is marked at its current configuration at this point in time. This follows a 3-step process:
1. Tell Git which files to add to the commit through the ```add``` command (usually but not always followed by the ```--all``` specifier)
2. Do the commit, identifying it by a short message - up to a few dozen characters or so
3. Push your local changes to the Github server.

```git add --all ```

```git commit -m “XXMESSAGE” ```

```git push [origin branch] ```
e.g. ``` git push origin JackW ```
or ``` git push origin master ```

If you are the primary owner/developer of a repository, it is OK to push straight to the master branch (```git push origin master ```).  Otherwise, push to a side branch.



Much of this material was drawn by a [tutorial](http://scottsfarley.com/tutorial/2016/09/10/Williams-Lab-Github-Lesson.html) developed by Scott Farley for the Williams Lab.  Thanks, Scott!
