# Plex Audiobook Guide
A walkthrough for optimal Audiobook experience using Plex.  This guide assumes you have Plex Media Server installed already.

### Install Metadata Agent for Plex
* Install [WebTools 4 Plex v3.0](https://github.com/ukdtom/WebTools.bundle/wiki/Install)  
  * Restart Plex
  * Access WebTools at this URL  
    * `http://<your IP address here>:33400/`
* Install the [Audiobook Metadata Agent](https://github.com/seanap/Audiobooks.bundle) using WebTools
  * In the WebTools page Click `UAS`
  * Enter the following Manual Installation URL
    * `https://github.com/seanap/Audiobooks.bundle`
  * Restart Plex

### Configure Plex Agent  
* Go to `Settings > Agents > Artist > Audiobooks` Put Local Media Assets above Audiobooks
 ![alt text](https://i.imgur.com/oEKdpmd.png "Artist Agent Config")
* Go to `Settings > Agents > Albums > Audiobooks` Put Local Media Assets above Audiobooks
 ![alt text](https://i.imgur.com/1aKHJeB.png "Album Agent Config")

### Create Audiobook Library in Plex
 * **General** select `Music`
 * **Add folders** browse to your Audiobook folders
 * **Advanced** set the following:  
   * Album sorting - By Name (This uses the Albumsort tag to keep series together and in order)
   * *UNCHECK* Prefer Local Metadata
   * *CHECK* Store track progress
   * *UNCHECK* Popular Tracks
   * Genres - Embedded tags
   * Album Art - Local Files Only
   * Agent - Audiobooks

### Automatically copy original files to a temp processing folder
Optional: This step is only if you want to preserve the original unedited Audiobook files.  I have 3 working directories for my Audiobooks:
* `~/Original` Folder where I keep the un-altered original audio Files
* `~/temp` Folder where I copy the audio files that need to be processed
* `~/Audiobooks` Folder where I archive my properly tagged files in the proper folder Structure
##### Create the Copy script
* Create a new file and name it `BookCopy.sh`  
` #!/bin/sh`  
`find /path/to/Original/* -type f -mmin -1 -exec cp -a "{}" /path/to/temp \; `
* Edit cron `crontab -e` add the following line:  
`* * * * * /bin/sh /path/to/BookCopy.sh`  

This script will check every 1min for a new audiobook in the `~/Original` folder. It will then copy the new file/folder to the `~/temp` folder. We will configure Mp3tag to open to the `~/temp` folder by default.  Once you run the custom Action created below, Mp3tag will move the files from `~/temp` to `~/Audiobook`.  Once you are done tagging and renaming the books you only need to clean up any empty folders left in `~/temp`.

### Configure Mp3tag
* Install [Mp3tag](https://www.mp3tag.de/en/)
* Install the Audible custom web sources  
  * [Guide](https://github.com/seanap/Audible.com-Search-by-Album)
* Set the default folder Mp3tag opens to in `Tools > Options > Directories` check `start from this directory`  
![alt text](https://i.imgur.com/R2lh1YH.png "Default Directory")  


* Cofigure `Tag Panel` Under `Tools > Options`  
  Note: **CAPITAL** names are the bare essentials  
  Names that start with **#** are custom tags, only used by mp3tag
  ![alt text](https://i.imgur.com/wHdZcHh.png "Tag Panel")
* Configure meaningful user-defined Genres under `Tools>Options`  
  ![alt text](https://i.imgur.com/YXnh7ve.png "User-defined Genres")


* Create a Rename and Move Cover Actions  
  * Click the Actions menu, select Actions (or `Alt-6`)
  * Click New, and Label it (eg. 01 - Filename - Folder Structure - Cover in Folder)
  * Add a New Action `Format Value`
    * Field = `_FILENAME`
    * Format String = `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%\%album% (%year%) '['%series% %series-part%']'- pt$num(%track%,2)`
  * Add a New Action `Export Cover to File`
    * Format String = `%album% (%year%) ['['%series% %series-part%']' ]- cover`
   ![alt text](https://i.imgur.com/SiRhEdU.png "Example Actions")
* Load a test file in Mp3tag, and select a track, to make sure everything is working
  * Click the Web Sources drop down button, select Audible.com > Search by Album
   ![alt text](https://i.imgur.com/Q4ySYh2.png "Web Source Select")
  * Click the Action drop down button, select your new Action  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")

### Clean up File & Folder names  
* Load un-tagged audiobook into Mp3tag
  * `Ctrl-a` or, Select All tracks of the Audiobook
  * `Ctrl-k` Set/fix the track numbers
  * `Ctrl-shift-i` or Click the Web Source (quick) button
![alt text](https://i.imgur.com/AjJbUqE.png "Tag Source")
  * Click the Action drop down button, select your  Action  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")

### Notes
Once you have mp3tag, Audiobook metadata agent and Plex configured the work flow becomes pretty quick and painless.  I typically wait till I have a few Audiobooks in the que before tagging and archiving.  

I set up three different actions to use depending on the number of tracks of the book.  
For a single track I removed the `-pt$num(%track%,2)` from the end of the filename Format Value.  
For 2-99 tracks, use the 01 Action from the example above it will add `-pt01` to the end of the filename.  
For 100-999 tracks create the 001 Action by duplicating the 01 Action and editing the Format Value string to `-pt$num(%track%,3)` which will append `-pt001` to the end of the track.

   Following this guide will also give you everything you need for a properly organized Booksonic server.  While Plex doesn't really care about your folder structure, Booksonic exclusively uses folder structure and cover.jpg files for it's organization.

   If you have an iOS device use the [Prologue app](https://prologue-app.com/), it is *miles* better than the Plex for iOS app.

   For Android devices, I actually gave up on using the Plex app after it constantly kept loosing my place, marked the book as finished at 90%, and doesn't record the watch status. I recently started using the updated PlexAmp Android app and it handles Audiobooks much better. It's still not at the same level as Prologue, or a dedicated player like Smart, but it's a step in the right direction.
