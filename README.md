# Plex & Booksonic Audiobook Guide
I've seen a lot of interest about this topic, this is my process for getting the most metadata into Plex in the least amount of time.  I'll be doing a deep dive into some advanced features of the tools available to us in order to get a nice, clean, and functional UI while saving hundreds of hours of manual, tedious, data entry.  This walkthrough is specifically for optimal Audiobook experience using Plex, which in it's current state only quasi-supports audiobooks. This guide assumes you have Plex Media Server, and/or Booksonic, installed already.  This guide is meant to serve as a framework for fully utilizing metadata.  Everything is customizable, and easy to change.

### Goal
Show as much metadata as possible in Plex &amp; Booksonic.  This will let you filter by Narrator, Author, Genre, Year, Series, Rating, Publisher, etc.  Show all album cover art and Summary's. Make the organizing and tagging as quick and painless as possible.  
![alt text](https://i.imgur.com/C3wgGte.png "Plex Author Page")  

![alt text](https://i.imgur.com/YHqhdhO.png "Plex Book Summary")  

![alt text](https://i.imgur.com/oSfZLHo.png "Booksonic Book Summary")  

![alt text](https://i.imgur.com/nVqSlWq.png "Tags")
<!-- blank line -->
----
<!-- blank line -->
### Configure Plex
#### Install Metadata Agent for Plex
Follow the Instructions [here](https://github.com/seanap/Audiobooks.bundle#installation)
* `https://github.com/seanap/Audiobooks.bundle#installation`

<details>
<summary>Alternate Installation using WebTools Plex Plugin</summary>
<br>

* Install [WebTools 4 Plex v3.0](https://github.com/ukdtom/WebTools.bundle/wiki/Install)  
  * Restart Plex
  * Access WebTools at this URL  
    * `http://<your IP address here>:33400/`
* Install the Audiobook Metadata Agent using WebTools:  
  * In the WebTools page Click `UAS`
  * Enter the following Manual Installation URL
    * `https://github.com/seanap/Audiobooks.bundle`
  * Restart Plex
</details>

#### Configure Metadata Agent in Plex  
* Go to `Settings > Agents > Artist > Audiobooks` Put Local Media Assets above Audiobooks
 ![alt text](https://i.imgur.com/oEKdpmd.png "Artist Agent Config")
* Go to `Settings > Agents > Albums > Audiobooks` Put Local Media Assets above Audiobooks
 ![alt text](https://i.imgur.com/1aKHJeB.png "Album Agent Config")

#### Create Audiobook Library in Plex
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
<!-- blank line -->
----
<!-- blank line -->
### (Optional) Automatically copy untagged Audiobook files to a temp folder
Optional: This step is only if you want to preserve the original unedited Audiobook files. Recommended if you are seeding torrents, for example from librivox.org

<details>
<summary>What I wanted to achieve with this: (click to expand)</summary>
<br>
I have 3 working directories for my Audiobooks:

* `~/Original` Folder where I keep the un-altered original audio Files  
* `~/temp` Folder where I copy the audio files that need to be processed  
* `~/Audiobooks` Folder where I archive my properly tagged files in the proper folder Structure

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

 ##### Create the Copy script  [LINUX ONLY]
 >*Please consider contributing a Windows script*

   * Open Notepad++  
   * Create a new file and name it `BookCopy.sh`  
   * Copy and paste the code below, update your path, and save.  
```
#!/bin/sh
find /full/path/to/Original/ -type f \( -iname \*.m4b -o -iname \*.mp3 -o -iname \*.mp4 -o -iname \*.m4a -o -iname \*.ogg \) -mmin -3 -exec cp -n "{}" /full/path/to/temp/ \;
```

   * Edit cron `crontab -e` add the following line:  
`*/2 * * * * /bin/sh /path/to/BookCopy.sh`  
<!-- blank line -->
----
<!-- blank line -->
### Configure Mp3tag
* Install, or Upgrade [Mp3tag](https://www.mp3tag.de/en/) to the latest version  

##### Set the default folder Mp3tag automatically looks for book files in.
* `Tools > Options > Directories`  
* Put the full path of the directory with your untagged books in `Favorite directory:`  
* CHECK `start from this directory`  
![alt text](https://i.imgur.com/R2lh1YH.png "Default Directory")  

##### Download my example configuration files to Mp3tag's Appdata directory  
* Download my repo by clicking [Here](https://github.com/seanap/Plex-Audiobook-Guide/archive/master.zip).  
  * Alternatively, click the green 'Code' dropdown button at the top of this Github page and select “Download Zip”.  
* The `Mp3tag` folder will be located in the zip archive. Unzip the archive.  
* Open the `Plex-Audiobook-Guide` folder
* Copy (or move) the `Mp3tag` folder to `C:\Users\your-username-here\Appdata\Roaming` folder  
  * Click `Yes` to merge/overwrite files  

##### Edit the newly copied config files with your specific paths
* Right click the following provided config files and OPEN WITH Notepad++  
  * `\Mp3tag\data\action\1 m4b.mta` Update lines 3, 15, 22 with the path to your Plex `\Audiobook` folder  
  * `\Mp3tag\data\action\001.mta` Update lines 3, 15, 22 with the path to your Plex `\Audiobook` folder  
  * `\Mp3tag\data\action\01.mta` Update lines 3, 15, 22 with the path to your Plex `\Audiobook` folder  
  * `\Mp3tag\export\001 Generate.mte` Update line 1 with your windows username `C:\Users\your-username-here\...`  
  * `\Mp3tag\export\desc.mte` Update line 1 with the path to your Plex `\Audiobook` folder  
  * `\Mp3tag\export\reader.mte` Update line 1 with the path to your Plex `\Audiobook` folder  

<details>
<summary>Alternatively, you can manually create and configure mp3tag to your specific needs (click to expand)</summary>
<br>

##### Install the Audible custom web sources  
  * [Download](https://github.com/seanap/Audible.com-Search-by-Album/archive/master.zip) the custom web source files
  * Drop the `Audible.com#Search by Album.src` file in your `%appdata%\Roaming\Mp3tag\data\sources` folder

##### Cofigure the `Tag Panel`
  * This can be manually adjusted Under `Tools > Options > Tag Panel`  
  ![alt text](https://i.imgur.com/wHdZcHh.png "Tag Panel")

##### Create a custom Action that will Rename, Proper Folder Structure, and Export cover/desc/reader
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
`$filename(desc.txt,utf-8)`  
`%comment%`
```  
    * Save `desc.mte`  
    * Set `Export File Name:` as:  
      * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\desc.txt`  
  * Add New Action `Export`  
    * Click `New`  
    * Label it `reader`  
    * Edit the `reader.mte` file to only include the following two lines:  
```
`$filename(reader.txt,utf-8)`  
`%composer%`
```  
    * Save `reader.mte`  
    * Set `Export File Name:` as:  
      * `C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%[ '['%series% %series-part%']']\reader.txt`  

Your New Action should look like this:  
  ![alt text](https://i.imgur.com/SiRhEdU.png "Example Actions")
  ![alt text](https://i.imgur.com/kmOiNqc.png "Custom Action Sequence")
  ![alt text](https://i.imgur.com/YfxJOGj.png "Filename format")
</details>

##### Test
* Put an audiobook file for testing in your `\temp` folder  
* Open Mp3tag and select all files for that book  
* `Ctrl-k` and set/fix the Track Numbering
* Click the Web Sources drop down button, select Audible.com > Search by Album  
   ![alt text](https://i.imgur.com/Q4ySYh2.png "Web Source Select")  
* Click the Action drop down button, select the Action that corresponds with the number of files  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")  
  You have three different actions to use depending on the number of files the book has;
  * For a single track, use the 1 m4b Action. This Action does *not* append a `-pt01` to the end of the filename.  
  * For 2-99 tracks, use the 01 Action. It will append `-pt01` to the end of the filename.  
  * For 100-999 tracks, use the 001 Action. It will append `-pt001` to the end of the filename.  

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
  4. Click the Action drop down button, select your  Action  
  ![alt text](https://i.imgur.com/knf3ATb.png "Filename-Folder-Cover")
  5. This does not set the Title tag, which Plex uses as the Chapter Name.  There are two easy options to set this:
    * Click the `Filename - Tag` button, `Format String=%Title%`, this will set the Chapter name to the filename.
    * Click the Action drop down and select `Chapter %track%` which will give you a generic "Chapter 1, Chapter 2, ..."
<!-- blank line -->
----
<!-- blank line -->
#### Tips!  
   * There are two key board shortcuts that call the Audible Web Source script, which one to use depends on if the Album and Artist tags exist or are accurate.  
      * `Ctrl-i` - Use if there are **no** tags, or if the Album/Artist tags are incorrect or contain junk data that will effect the Audible search. This short cut will bring up the search and allow you to put exactly what you want to search Audible with, try to keep it as simple as possible with only Album and Author, you can also put the ASIN number in this dialog box to search for a specific book on Audible.  
      * `Ctrl-Shift-i` Use if the Album and Artist tag look to be ok, this will bypass the search input dialog box and bring you straight to the results.   
   * If the Author is also the Narrator make sure you delete the duplicate entry in the Artist field.  The script automatically combines the Author and Narrator (ex. `Peter Clines, Ray Porter`) in the Artist tag, which Plex uses as a "All Artists on this track" tag. Combining these tags for the Artist helps when searching Plex.  
   * Try to only keep 1 cover file in the tag, when the script asks if you want to save the existing cover, say "**No**".  If you happen to like the included cover over Audibles, in the Tag Review screen you can click the "Utils" button (bottom left) and UNCHECK "Save Image to Tag", but *make sure you remember to recheck this on the next book*.  
   * In Plex; If the Audiobook agent matches two different books as the same book, which will look like a duplicate in Plex, Unmatch BOTH books and start by manually matching the incorrect book, then manually re-match the book that was correct.  

<!-- blank line -->
----
<!-- blank line -->
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
| `stik` (ITUNESMEDIATYPE) | M4B Media type = Audiobook |
| `pgap` (ITUNESGAPLESS) | M4B Gapless album = 1 |
| 'shwm' SHOWMOVEMENT    | Show Movement (M4B), if Series then = 1 else blank|
| `MVNM` MOVEMENTNAME    | Series           |
| `MVIN` MOVEMENT        | Series Book #    |
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
    1. Prologue - Connects to Plex  
    2. Play:Sub - Connects to Booksonic  
* **Android**  
    1. Chronicle - Connects to Plex, just released (limited functionality), aims to be similar to Prologue  
    2. PlexAmp - Connects to Plex, Official Plex audio app, Basic audiobook features but works well enough  
    3. Booksonic - Connects to Booksonic, has a few quirks but it works  
    4. Smart - Local media files only, but tons of great Audiobook specific features  
<!-- blank line -->
----
<!-- blank line -->
### Notes:
Once you have mp3tag, Audiobook metadata agent and Plex configured the work flow becomes pretty quick and painless, especially when using keyboard shortcuts.   

Following this guide will also give you everything you need for a properly organized Booksonic server.  While Plex doesn't really care about your folder structure beyond `/Audiobook/Author/Book/book.mp3`, Booksonic exclusively uses folder structure for it's organization and it also looks for `cover.jpg`/`desc.txt`/`reader.txt` files (automatically created with the Action script) for additional metadata.

If you have an iOS device use the [Prologue app](https://prologue-app.com/), it is *miles* better than the Plex for iOS app.

For Android devices, I recently started using the updated PlexAmp Android app and it handles Audiobooks much better. It's still not at the same level as Prologue, or a dedicated player like Smart. Pros: It lets you filter/browse by Genre, Narrator, Year, it remembers where you left off very well, it supports Car Play and Android Auto. Cons: Suffers from the 90% marked as Played bug in plex, no sleep timer, requires PlexPass.
