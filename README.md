# Plex & Booksonic Audiobook Guide
This guide is specifically for optimal Audiobook experience using Plex, which in it's current state only quasi-supports audiobooks. This is my method for processing large libraries with bad/missing tags as quick as possible while getting the most metadata into Plex in the least amount of time.  I'll be doing a deep dive into some advanced features of the tools available to us in order to get a nice, clean, and functional UI. This guide is meant to serve as a framework for fully utilizing metadata.  Everything is customizable, and easy to change.  While focused on Plex, if you follow the tagging and file processing steps you will also be compatible with Booksonic and AudiobookShelf servers.

> ***Note**: This guide targets and has been tested on Windows systems. Most of it also works on Linux/Mac but the Mp3tag Audible WebSource script only works on Windows. For workarounds see [issue #2](/../../issues/2).*
### Contents
* [Goal](#goal)
* [Working Folders](#working-folders)  
* [(Optional) Automatically copy untagged Audiobook files to a temp folder](#optional-automatically-copy-untagged-audiobook-files-to-a-temp-folder)  
* [(Optional) Automatically convert mp3 audiobooks to chapterized M4B](#optional-automatically-convert-mp3-audiobooks-to-chapterized-m4b-linuxwindows)
* [Configure Mp3tag](#configure-mp3tag)
  * [Set the default folder](#set-the-default-folder-mp3tag-automatically-looks-for-book-files-in)
  * [Download my example configuration files to Mp3tag's Appdata directory](#download-my-example-configuration-files-to-mp3tags-appdata-directory)
  * [Edit the newly copied config files with your specific paths](#edit-the-newly-copied-config-files-with-your-specific-paths)
  * [Test](#test)
* [Configure Plex](#configure-plex)
  * [Install Plex Audiobook Agents](#install-metadata-agent-for-plex)
  * [Configure Metadata Agent in Plex](#configure-metadata-agent-in-plex)
  * [Create Audiobook Library in Plex](#create-audiobook-library-in-plex)
* [Workflow](#workflow)
* [Tips!](#tips)
* [Tags that are being set](#tags-that-are-being-set)
* [Players](#players)
* [Notes](#notes)

### Goal
Show as much metadata as possible in Plex &amp; Booksonic.  Filter/browse/search by Narrator, Author, Genre, Year, Series, Rating, or Publisher.  Show Album Covers and Summary's. Make the organizing and tagging as quick and painless as possible. We need to do these 4 general steps:  

0. (Optional) Convert mp3's to chapterized m4b.  
1. Ensure the ALBUM and ALBUMARTIST (or ARTIST) tags are set and correct.  
2. Install the Audnexus Audible Metadata Agent in Plex.  
3. Use a 3rd party Audiobook player app such as BookCamp or Prologue.  

![Plex Library View](https://i.imgur.com/k4up0ao.jpg)
<p float="left">
  <img src="https://i.imgur.com/C3wgGte.png" width="48%" />
  <img src="https://i.imgur.com/YHqhdhO.png" width="50%" />
</p>

![alt text](https://i.imgur.com/oSfZLHo.png "Booksonic Book Summary")  
<p float="left">
  <img src="https://i.imgur.com/A1IYa5I.png" width="24%" />
  <img src="https://i.imgur.com/eKrH92i.png" width="23.5%" />
  <img src="https://i.imgur.com/HGbPdNM.png" width="49%" />
</p>

<!-- blank line -->
----
<!-- blank line -->

### Backing up your Audible books
I plan on having a seprate walkthrough that will take you through backing up your Audible .aax files, and converting them to chapterized .M4B files. This giude will work for both mp3 and m4b files, but I prefer chapterized m4b's.  Plex handles M4B metadata better than mp3's, some third party players like Prologue and BookCamp can handle the M4B chapter splits and names, and generally having less files helps plex run smoother.  

In the mean time please check out this awesome guide here: http://checkthebenchmarks.com/2019/09/23/why-you-should-manage-your-own-audible-library/

For some more Software resources for Audible-centric audiobook management, including removing DRM from Audible files check out [@rmcrackan](https://github.com/rmcrackan)'s [AudiobookHub](https://github.com/rmcrackan/AudiobookHub)

Now that you have your files, let get them in a format Plex can handle so we can stream our whole library with our firends and family.

----

### Working folders
I have 3 working directories for my Audiobooks:
* `~/Original` Folder where I keep the un-altered original audio Files  
* `~/temp` Folder where I copy the audio files that need to be processed, this is the folder Mp3tag will open by default  
* `~/Audiobooks` Folder where I archive my properly tagged files in the proper folder structure, this is the folder I point Plex at

> Anywhere these folders are referenced, make sure to update to your specific paths

Best Practice: Tag your files *before* adding them to Plex.
<!-- blank line -->
----
<!-- blank line -->
### (Optional) Automatically copy untagged Audiobook files to a temp folder
Optional: This step is only required if you want to preserve the original unedited Audiobook files. This is required if you are seeding torrents, for example from librivox.org. That said, this is a recommended step for everyone, just incase something goes horribly wrong with Mp3tag or copying files.

<details>
<summary>What I want to achieve with this step: (click to expand)</summary>

<br>

This Script will:  
* Check every 2min for a new audiobook in the `/original` folder  
* Find only files and folders added to `/original` since the last run  
* Filter files to just Audiofiles (mp3 m4b ogg etc)  
* Copy only the Audiofiles to `/temp`  
* Ignore folder structure, bring everything to the `/temp/*` level  
* If exists do not copy again  
* We will configure Mp3tag to open to the `/temp` folder by default  
* When you run the Mp3tag custom Action (installed/created below), Mp3tag will move the files from `/temp` to `~/Audiobook`

Example:
```
/original
|
+-- /Book1
|   |
|   +-- book1.mp3 (Date: T-1min)
|   +-- book1cover.jpg (Date: T-1min)
|
+-- book2.m4b (Date: T-2min)
+-- book3.m4b (Date: T-1Hr)

RUN SCRIPT (every 2min)

/temp
|
+-- book1.mp3
+-- book2.m4b
```
</details>

<br>

This will automatically copy untagged books from `\Original` to `\temp`, which we will set as the default folder Mp3tag opens to, so all you have to do is open Mp3tag and any books that need processing will be automatically loaded. Expand and follow one of the options below for your OS.

<details>
<summary>[WINDOWS] Monitor /original folder and move untagged audiofiles to /temp: (click to expand)</summary>
<br>

* Download, Install, and Run [Dropit](http://www.dropitproject.com/#download)  
* Download Dropit settings Backup file [BookCopy [v1].zip](https://github.com/seanap/Plex-Audiobook-Guide/raw/master/Dropit/Backup/BookCopy%20%5Bv1%5D.zip)  
* In the System Tray: Right-Click `Dropit` > `Options` > `Various` > `Restore` and **Open** `BookCopy [v1].zip`
<p float="left">
  <img src="https://i.imgur.com/qrEFFQH.png" width="69%" />
  <img src="https://i.imgur.com/DBdlB6k.png" width="30%" />
</p>

* In the `Options` window, go to the `Monitoring` tab and edit `Z:\Original` with your specific folder  
![Update Monitored Folder Path](https://i.imgur.com/evlHN8K.png)
* Click Save, and OK to close the Options windows  
* Right-Click `Dropit` icon in system tray  
* Click `Associations`  
   * Make sure `BookCopy` profile is selected in the bottom drop-down  
* Double-Click `AudiobookCopy` and edit `4. Destination Folder` with your specific `\temp` folder  
![Update Destination Folder](https://i.imgur.com/T4HoYQq.png)  
> Test it by Copying an audiofile to /Original. Make sure it's working before moving on

</details>

<details>
<summary>[LINUX] Create a BookCopy script: (click to expand)</summary>
<br>

   * Open Notepad++  
   * Create a new file and name it `BookCopy.sh`  
   * Copy and paste the code below, update your path, and save.  
```
#!/bin/sh
find /full/path/to/Original/ -type f \( -iname \*.m4b -o -iname \*.mp3 -o -iname \*.mp4 -o -iname \*.m4a -o -iname \*.ogg \) -mmin -3 -exec cp -n "{}" /full/path/to/temp/ \;
```
   * Edit cron `crontab -e` add the following line:  
`*/2 * * * * /bin/sh /path/to/BookCopy.sh`  
</details>

---
### (Optional) Automatically convert mp3 audiobooks to chapterized M4B [Linux+Windows]

Let's face it, Large Libraries Sink Ships. Everything runs quicker, and smoother, the lower the total number of files there are to scan.  Let's say you have 5000 books.  If they were mp3's then you would be looking at least 100,000 files, vs 5000 m4b's.  M4b's can also hold chapter data, and generally the metadata works better with Plex over mp3's.  

If you use both Linux and Windows, I have a Linux script that watches your `/original` folder for newly added mp3 audiobooks and converts them to M4b files with chapters separated by mp3 file.  It's pretty slick.

* Creating and Installing auto-m4b-tool script guide  
  * https://github.com/seanap/Auto-M4B-Tool#m4b-tool-automation  

---

### Configure Mp3tag
* Install, or Upgrade [Mp3tag](https://www.mp3tag.de/en/) to the latest version  

#### Set the default folder Mp3tag automatically looks for book files in.
* `Tools > Options > Directories`  
* Put the full path of the `\temp` directory with your untagged books in `Favorite directory:`  
* CHECK `start from this directory`  
![alt text](https://i.imgur.com/R2lh1YH.png "Default Directory")  

#### Download my example configuration files to Mp3tag's Appdata directory  
* Download my repo by clicking [Here](https://github.com/seanap/Plex-Audiobook-Guide/archive/master.zip).  
  * Alternatively, click the green 'Code' dropdown button at the top of this Github page and select “Download Zip”.  
* The `Mp3tag` folder will be located in the zip archive. Unzip the archive.  
* Open the `Plex-Audiobook-Guide` folder
* Copy (or move) the `Mp3tag` folder to `C:\Users\your-username-here\Appdata\Roaming` folder  
  * Click `Yes` to merge/overwrite files  

#### Edit the newly copied config files with your specific paths
* Right click the following provided config files and OPEN WITH Notepad++   
  * `%APPDATA%\Mp3tag\data\action\&1 Rename Relocate Extras Title.mta` Update lines 3, 15, 22 with the path to your Plex `\Audiobook` folder  
  * `%APPDATA%\Mp3tag\export\001 Generate.mte` Update line 1 with your windows username `C:\Users\your-username-here\...`  
  * `%APPDATA%\Mp3tag\export\desc.mte` Update line 1 with the path to your Plex `\Audiobook` folder  
  * `%APPDATA%\Mp3tag\export\reader.mte` Update line 1 with the path to your Plex `\Audiobook` folder  

<details>
<summary>Alternatively, you can manually create and configure mp3tag to your specific needs (click to expand)</summary>
<br>

#### Install the Audible custom web sources  
  * [Download](https://github.com/seanap/Audible.com-Search-by-Album/archive/master.zip) the custom web source files
  * Drop the `Audible.com#Search by Album.src` file in your `%appdata%\Roaming\Mp3tag\data\sources` folder

#### Cofigure the `Tag Panel`
  * This can be manually adjusted Under `Tools > Options > Tag Panel`  
  ![alt text](https://i.imgur.com/wHdZcHh.png "Tag Panel")

#### Create a custom Action that will Rename, Proper Folder Structure, and Export cover/desc/reader
  * Load an audiobook file in Mp3tag for testing, and select it  
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
```
$filename(desc.txt,utf-8)
%comment%
```
  * Save `desc.mte`  
    * Set `Export File Name:` as:  
     * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\desc.txt`
  * Add New Action `Export`  
    * Click `New`  
    * Label it `reader`  
    * Edit the `reader.mte` file to only include the following two lines:  
```
$filename(reader.txt,utf-8)
%composer%
```  
   * Save `reader.mte`  
     * Set `Export File Name:` as:  
      * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\reader.txt`  

Your New Action should look like this:  
  ![alt text](https://i.imgur.com/SiRhEdU.png "Example Actions")
  ![alt text](https://i.imgur.com/kmOiNqc.png "Custom Action Sequence")
  ![alt text](https://i.imgur.com/YfxJOGj.png "Filename format")
</details>

#### Test
* Put an audiobook file for testing in your `\temp` folder  
* Open Mp3tag and select all files for that book  
* `Ctrl-k` and set/fix the Track Numbering if applicable
* Click the Web Sources drop down button, select Audible.com > Search by Album  
   ![alt text](https://i.imgur.com/Q4ySYh2.png "Web Source Select")  
* Click the Action drop down button, select the `&1 Rename Relocate Extras Title` Action  
  ![alt text](https://i.imgur.com/OMRONbp.png "Filename-Folder-Cover")  

> Note: After selecting the Web Source manually for the first time we can then use the keyboard shortcut `ctrl+shift+i` to call it moving forward. Likewise the action script can be called using `alt+a 1`.   

<!-- blank line -->
----
<!-- blank line -->
### Configure Plex
#### Install Metadata Agent for Plex
Follow the Instructions [here](https://github.com/djdembeck/Audnexus.bundle)
* `https://github.com/djdembeck/Audnexus.bundle`

<details>
<summary>Alternate Installation using WebTools Plex Plugin (click to expand)</summary>
<br>

* Install [WebTools 4 Plex v3.0](https://github.com/ukdtom/WebTools.bundle/wiki/Install)  
  * Restart Plex
  * Access WebTools at this URL  
    * `http://<your IP address here>:33400/`
* Install the Audiobook Metadata Agent using WebTools:  
  * In the WebTools page Click `UAS`
  * Enter the following Manual Installation URL
    * `https://github.com/djdembeck/Audnexus.bundle`
  * Restart Plex
</details>

#### Configure Metadata Agent in Plex  
* Go to `Settings > Agents > Artist > Audiobooks` Put Audnexus above Local Media Assets  
 ![alt text](https://i.imgur.com/5ZJmSXf.png "Artist Agent Config")
* Go to `Settings > Agents > Albums > Audiobooks` Put Audnexus above Local Media Assets  
 ![alt text](https://i.imgur.com/AgzM1Wm.png "Album Agent Config")

#### Create Audiobook Library in Plex
 * **General** select `Music`  
 * **Add folders** browse to your Audiobook folders  
 * **Advanced** set the following:  
   * Agent = Audnexus Agents  
   * Keep existing genre's - The new agent pulls 4-6 meaningful genres but if you want to keep your existing CHECK this box  
   * Album sorting - By Name (This uses the Albumsort tag to keep series together and in order)  
   * *UNCHECK* Prefer Local Metadata  
   * *CHECK* Store track progress  
   * *UNCHECK* Author Bio  
   * Genres = None  
   * Album Art = Local Files Only
<!-- blank line -->
----
<!-- blank line -->
### Workflow  
Now that the hard part of setting everything up is out of the way, this is what your typical workflow will look like moving forward:
> *Mp3tag can only work on one audiobook at a time.*

##### Open Mp3tag
  1. `Ctrl-a` or, Select All tracks of an Audiobook
  2. `Ctrl-k` Set/fix the track numbers
  3. `Ctrl-shift-i` or Click the Web Source (quick) button
![alt text](https://i.imgur.com/AjJbUqE.png "Tag Source")
  4. `Alt-a 1` or Click the Action drop down menu  
  ![alt text](https://i.imgur.com/OMRONbp.png "Filename-Folder-Cover")
  5. This does not set the TITLE tag for multifile books. Plex uses TITLE as the Chapter Name.  There are two easy options to set this:  
      * Click the `Filename - Tag` button, `Format String=` `%Title%`, this will set the filename as the Chapter name.  
      * Click the Action drop down, select `Chapter %track%` which will give you a generic "Chapter 1, Chapter 2, ..."  
<!-- blank line -->
----
<!-- blank line -->
### Tips!  
   * There are two key board shortcuts that call the Audible Web Source script, which one to use depends on if the Album and Artist tags exist or are accurate.  
      * `Ctrl-i` - Use if there are **no** tags, or if the Album/Artist tags are incorrect or contain junk data that will effect the Audible search. This shortcut will bring up the search and allow you to put exactly what you want to search Audible with, try to keep it as simple as possible with only Album and Author, you can also put the ASIN number in this dialog box to search for a specific book on Audible.  
      * `Ctrl-Shift-i` Use if the Album and Artist tag look to be ok, this will bypass the search input dialog box and bring you straight to the results.   
   * If the Author is also the Narrator make sure you delete the duplicate entry in the Artist field.  The script automatically combines the Author and Narrator (ex. `Peter Clines, Ray Porter`) in the Artist tag, which Plex uses as a "All Artists on this track" tag. Combining these tags for the Artist helps when searching Plex.  
   * Try to only keep 1 cover file in the tag, when the script asks if you want to save the existing cover, say "**No**".  If you happen to like the included cover over Audibles, in the Tag Review screen you can click the "Utils" button (bottom left) and UNCHECK "Save Image to Tag", but *make sure you remember to recheck this on the next book*.  

<!-- blank line -->
----
<!-- blank line -->
### Tags that are being set
I did a lot of digging into ID3 standards and this was the best way I could come up with to shoehorn Audiobook metadata into mp3 tags.  It certainly isn't perfect, but it does work very nicely for Plex and other Audiobook apps.  These can be changed to fit your particular style by editing the Audible.com#Search by Album.src file in Notepad++.

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
| `stik` (ITUNESMEDIATYPE) | M4B Media type = Audiobook |
| `pgap` (ITUNESGAPLESS) | M4B Gapless album = 1 |
| `shwm` (SHOWMOVEMENT)    | Show Movement (M4B), if Series then = 1 else blank|
| `MVNM` (MOVEMENTNAME)    | Series           |
| `MVIN` (MOVEMENT)        | Series Book #    |
| `TXXX` (SERIES)**      | Series           |
| `TXXX` (SERIES-PART)** | Series Book #    |
| `TXXX` (TMP_GENRE1)**    | Genre 1 |
| `TXXX` (TMP_GENRE2)**    | Genre 2 |
| `CoverUrl`             | Album Cover Art  |
| `TIT2` (TITLE)         | Not Scraped, but used for Chapter Title<br>If no chapter data available set to filename |
   >&ast;*I would prefer Original Pub. year, but Audible is really bad at providing this data*  
   >&ast;&ast;*Custom Tags used as placeholders, To view this tag Tools>Options>Tag Panel>New*

<!-- blank line -->
----
<!-- blank line -->
### Players:
* **iOS**  
    1. [BookCamp](https://apps.apple.com/fr/app/bookcamp/id1523540165) ($12/yr) - Connects to Plex, Cross Platform, NEW! Still in Beta
    2. [Prologue](https://apps.apple.com/us/app/prologue/id1459223267) ($5) - Connects to Plex,   
    3. [Play:Sub](https://apps.apple.com/us/app/play-sub-music-streamer/id955329386) - Connects to Booksonic  
* **Android**  
    1. [BookCamp](https://play.google.com/store/apps/details?id=app.bookcamp.android) ($12/yr) - Connects to Plex, Cross Platform, NEW! Still in Beta
    2. [Chronicle](https://play.google.com/store/apps/details?id=io.github.mattpvaughn.chronicle) (Opensource) - Connects to Plex, limited functionality but works well  
    3. [PlexAmp](https://plexamp.com/) (Plexpass) - Connects to Plex, Official Plex audio app, Music focused player, easy to lose your place.  
    4. [Booksonic](https://play.google.com/store/apps/details?id=github.popeen.dsub) - Connects to [Booksonic](https://booksonic.org/), has a few quirks but it works  
    5. [Smart](https://play.google.com/store/apps/details?id=ak.alizandro.smartaudiobookplayer) - Local media files only, but tons of great Audiobook specific features  
<!-- blank line -->
----
<!-- blank line -->
### Notes:
Once you have mp3tag, Audiobook metadata agent, and Plex configured the work flow becomes pretty quick and painless, especially when using keyboard shortcuts.   

Following this guide will also give you everything you need for a properly organized AudiobookShelf and Booksonic server.  While Plex doesn't really care about your folder structure beyond `/Audiobook/Author/Book/book.mp3`, Booksonic exclusively uses folder structure for it's organization and it also looks for `cover.jpg`/`desc.txt`/`reader.txt` files (automatically created with the Action script) for additional metadata.

I currently use [BookCamp](https://www.bookcamp.app/) ($12/yr), it is *miles* better than the Plex app and PlexAmp and works on both iOS and Android, but if you are on iOS then Prologue is the preferred option.

<!-- blank line -->
----
<!-- blank line -->
<a href="https://www.buymeacoffee.com/seanap" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-green.png" alt="Buy Me A Book" height="41" width="174"></a>
