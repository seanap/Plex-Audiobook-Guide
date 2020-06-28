# Plex & Booksonic Audiobook Guide
I've seen a lot of interest about this topic, this is my process for getting the most metadata into Plex in the least amount of time.  I'll be doing a deep dive into some advanced features of the tools available to us in order to get a nice, clean, and functional UI while saving hundreds of hours of manual, tedious, data entry.  This walkthrough is specifically for optimal Audiobook experience using Plex, which in it's current state only quasi-supports audiobooks. This guide assumes you have Plex Media Server, and/or Booksonic, installed already.  This guide is meant to serve as a framework for fully utilizing metadata.  Everything is customizable, and easy to change.

### Goal
Show as much metadata as possible in Plex &amp; Booksonic.  This will let you filter by Narrator, Author, Genre, Year, Series, Rating, Publisher, etc.  Show all album cover art and Summary's. Make the organizing and tagging as quick and painless as possible.  
![alt text](https://i.imgur.com/C3wgGte.png "Author Page")  

![alt text](https://i.imgur.com/YHqhdhO.png "Book Summary")  

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

### Automatically copy original files to a temp processing folder (optional)
Optional: This step is only if you want to preserve the original unedited Audiobook files.  I have 3 working directories for my Audiobooks:
* `~/Original` Folder where I keep the un-altered original audio Files  
* `~/temp` Folder where I copy the audio files that need to be processed  
* `~/Audiobooks` Folder where I archive my properly tagged files in the proper folder Structure  

 ##### Create the Copy script
 This script will check every 2min for a new audiobook in the `~/Original` folder. It will then copy the new files to the `~/temp` folder. We will configure Mp3tag to open to the `~/temp` folder by default.  Then when you run the Mp3tag custom Action (created below), Mp3tag will move the files from `~/temp` to `~/Audiobook`.
* Create a new file and name it `BookCopy.sh`  
`#!/bin/sh`  
`find /full/path/to/Original/ -type f \( -iname \*.m4b -o -iname \*.mp3 -o -iname \*.mp4 -o -iname \*.m4a -o -iname \*.ogg \) -mmin -3 -exec cp -n "{}" /full/path/to/temp/ \;`  

* Edit cron `crontab -e` add the following line:  
`*/2 * * * * /bin/sh /path/to/BookCopy.sh`  

This script will check every 2min for a new audiobook in the `~/Original` folder. It will then copy the new files to the `~/temp` folder. We will configure Mp3tag to open to the `~/temp` folder by default.  Then when you run the Mp3tag custom Action (created below), Mp3tag will move the files from `~/temp` to `~/Audiobook`.  

### Configure Mp3tag
* Install [Mp3tag](https://www.mp3tag.de/en/)
* Install the Audible custom web sources  
  * [Download](https://github.com/seanap/Audible.com-Search-by-Album/archive/master.zip) the custom web source files
  * Drop the `Audible.com#Search by Album.src` file in your `%appdata%\Roaming\Mp3tag\data\sources` folder
* Set the default folder Mp3tag opens to in `Tools > Options > Directories` check `start from this directory`  
![alt text](https://i.imgur.com/R2lh1YH.png "Default Directory")  


* Cofigure `Tag Panel` by downloading [usrfields.ini](https://github.com/seanap/Plex-Audiobook-Guide/blob/master/Scripts/usrfields.ini) and putting it in your `\%appdata%\roaming\Mp3tag\data` folder
  * This can be manually adjusted Under `Tools > Options > Tag Panel`  
  ![alt text](https://i.imgur.com/wHdZcHh.png "Tag Panel")

##### Create a custom Action that will Rename, Proper Folder Structure, and Export cover/desc/reader
  * Load a test audiobook file in Mp3tag, and select it
  * Click the Actions menu, select Actions (or `Alt-6`)
  * Click New, and Label it (eg. 01 - Filename - Folder Structure - Cover in Folder)
  * Add a New Action `Format Value`
    * Field = `_FILENAME`
    * Format String = `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\%album% (%year%) ['['%series% %series-part%']' ]- pt$num(%track%,2)`
  * Add a New Action `Export Cover to File`
    * Format String = `%album% (%year%) ['['%series% %series-part%']' ]- cover`
  * Add a New Action `Export`
    * Click `New`
    * Label it `desc`
    * Edit the `desc.mte` file to only include the following two lines:
      * `$filename(desc.txt,utf-8)`  
        `%comment%`
    * Save `desc.mte`
    * Set `Export File Name:` as:
      * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\desc.txt`
  * Add New Action `Export`
    * Click `New`
    * Label it `reader`
    * Edit the `reader.mte` file to only include the following two lines:
      * `$filename(reader.txt,utf-8)`  
        `%composer%`
    * Save `reader.mte`
    * Set `Export File Name:` as:
      * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\reader.txt`

  Your New Action should look like this:  
    ![alt text](https://i.imgur.com/SiRhEdU.png "Example Actions")
    ![alt text](https://i.imgur.com/kmOiNqc.png "Custom Action Sequence")
    ![alt text](https://i.imgur.com/YfxJOGj.png "Filename format")
  * Click the Web Sources drop down button, select Audible.com > Search by Album
   ![alt text](https://i.imgur.com/Q4ySYh2.png "Web Source Select")
* Click the Action drop down button, select your new Action  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")  

#### Tips!  
   * The script searches using the Album + Artist tag, if there are no results you can change these tags to something more search friendly, or you can look up the book at Audible.com and find the ASIN for the book in the addressbar and use that to search in the script.  
   * If the Author is also the Narrator make sure you delete the duplicate entry in the Artist field.  The script automatically combines these for the Artist tag, which is used as a "Artists on this track".  
   * Try to only keep 1 cover file in the tag, when the script asks if you want to save the existing cover, say "No".  If you happen to like the included cover over Audibles, in the Tag Review screen you can click the "Utils" button (bottom left) and UNCHECK "Save Image to Tag", but make sure you remember to recheck this on the next book.  


### Workflow: Clean up File & Folder names  
Now that the hard part of setting everything up is out of the way, this is what your typical workflow will look like moving forward:
* Open Mp3tag
  * `Ctrl-a` or, Select All tracks of the Audiobook
  * `Ctrl-k` Set/fix the track numbers
  * `Ctrl-shift-i` or Click the Web Source (quick) button
![alt text](https://i.imgur.com/AjJbUqE.png "Tag Source")
  * Click the Action drop down button, select your  Action  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")

### Tags that are being set
I did a lot of digging into ID3 standards and this was the best way I could come up with to shoehorn Audiobook metadata into mp3 tags.  It certainly isn't perfect, but it does work very nicely for Plex and other Audiobook apps.  These can easily be changed to fit your particular style by editing the Audible.com#Search by Album.src file in Notepad++.

| mp3tag Tag    | Audible.com Value|
| ------------- | ---------------- |
| `TIT1` (CONTENTGROUP)  | Series, Book #   |
| `TALB` (ALBUM)         | Title            |
| `TIT3` (SUBTITLE)      | Subtitle         |
| `TPE1` (ARTIST)        | Author, Narrator |
| `TPE2` (ALBUMARTIST)   | Author           |
| `TCOM` (COMPOSER)      | Narrator         |
| `TCON` (GENRE)         | Genre1/Genre2    |
| `TYER` (YEAR)          | Copyright Year*  |
| `COMM` (COMMENT)       | Publisher's Summary (MP3) |
| `desc` (DESCRIPTION)   | Publisher's Summary (M4B) |
| `TSOA` (ALBUMSORT)     | If ALBUM only, then %Title%<br>If ALBUM and SUBTITLE, then %Title% - %Subtitle%<br>If Series, then %Series% %Series-part% - %Title% |
| `TDRL` (RELEASETIME)   | Audiobook Release Year |
| `TPUB` (PUBLISHER)     | Publisher        |
| `TCOP` (COPYRIGHT)     | Copyright        |
| `ASIN` (ASIN)          | Amazon Standard Identification Number |
| `POPM` (RATING WMP)    | Audible Rating   |
| `WOAF` (WWWAUDIOFILE)  | Audible Album URL|
| `CoverUrl`             | Album Cover Art  |
| `TXXX` (SERIES)**      | Series           |
| `TXXX` (SERIES-PART)** | Series Book #    |
| `TXXX` (TMP_GENRE1) | Genre 1 |
| `TXXX` (TMP_GENRE2) | Genre 2 |
| `TIT2` (TITLE)         | Not Scraped, but used for Chapter Title<br>If no chapter data available set to filename |
   >&ast;*I would prefer Original Pub. year, but Audible is really bad at providing this data*  
   >&ast;&ast;*Custom Tags used as placeholders, To view this tag Tools>Options>Tag Panel>New*

### Notes:
Once you have mp3tag, Audiobook metadata agent and Plex configured the work flow becomes pretty quick and painless.  

I set up three different actions to use depending on the number of tracks of the book;  
* For a single track I removed the `-pt$num(%track%,2)` from the end of the filename Format Value.  
* For 2-99 tracks, use the 01 Action from the example above it will append `-pt01` to the end of the filename.  
* For 100-999 tracks create the 001 Action by duplicating the 01 Action and editing the Format Value string to `-pt$num(%track%,3)` which will append `-pt001` to the end of the track.  


   Following this guide will also give you everything you need for a properly organized Booksonic server.  While Plex doesn't really care about your folder structure, Booksonic exclusively uses folder structure for it's orgaization and looks for cover.jpg/desc.txt/reader.txt files for additional metadata.

   If you have an iOS device use the [Prologue app](https://prologue-app.com/), it is *miles* better than the Plex for iOS app.

   For Android devices, I recently started using the updated PlexAmp Android app and it handles Audiobooks much better. It's still not at the same level as Prologue, or a dedicated player like Smart, but it's a step in the right direction.
