# Plex-Audiobook-Guide
A walkthrough for optimal Audiobook experience using Plex

### Install Metadata Agent for Plex
* Install [WebTools 4 Plex v3.0](https://github.com/ukdtom/WebTools.bundle/wiki/Install)  
  * Restart Plex
  * Access WebTools at this URL  
    * `http://<your IP address here>:33400/`
* Install the [Audiobook Metadata Agent](https://github.com/seanap/Audiobooks.bundle)
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
   * Album sorting - Oldest first
   * *UNCHECK* Prefer Local Metadata
   * *CHECK* Store track progress
   * *UNCHECK* Popular Tracks
   * Genres - Embedded tags
   * Album Art - Local Files Only
   * Agent - Audiobooks
   
### Configure Mp3tag
* Install [Mp3tag](https://www.mp3tag.de/en/)
* Install the Audible custom web sources  
  * [Guide](https://github.com/seanap/Audible.com-Search-by-Album)
* Cofigure `Tag Panel` Under `Tools>Options`
  ![alt text](https://i.imgur.com/ERv9n8G.png "Tag Panel")
* Configure meaningful user-defined Genres under `Tools>Options`  
  ![alt text](https://i.imgur.com/YXnh7ve.png "User-defined Genres")
* Load a test file in Mp3tag, and select a track
  * Click the Web Sources drop down button, select Audible.com > Search by Album
   ![alt text](https://i.imgur.com/Q4ySYh2.png "Web Source Select")
  * Configure `Tag-Filename` button ![alt text](https://i.imgur.com/KJGD4sE.png "Tag-Filename")  
   * `Format String = C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%\%album% (%year%) - pt$num(%track%,2)`
  * Configure `Filename-Tag` button ![alt text](https://i.imgur.com/BE25NFp.png "Filename-Tag")  
   * `Format String = %title%`

### Clean up File & Folder names  
* Drag un-tagged audiobook into Mp3tag
  * `Ctrl-a` Select All
  * `Ctrl-shift-i` or Click the Web Source (quick) button
![alt text](https://i.imgur.com/AjJbUqE.png "Tag Source")
  * `Ctrl-k` Set/fix the track numbers
  * `Alt-1` or click the Tag-Filename button
![alt text](https://i.imgur.com/KJGD4sE.png "Tag-Filename") To set the filename and folder structure  
     * `Format String = C:\path\to\Audiobooks\%albumartist%\%series%\%year% - %album%\%album% (%year%) - pt$num(%track%,2)`  
* Copy Cover Art into the folder with your audio files (*Required for Booksonic*)
  * `Alt-Shift-6` or Click the Quick Action button ![alt text](https://i.imgur.com/UMueLqS.png "Quick Actions") and `Export cover to file` 
  ![alt text](https://i.imgur.com/vAxejs8.png "Quick Action - Cover to folder")  

### Notes
Once you have mp3tag, Audiobook metadata agent and Plex configured the work flow becomes pretty quick and painless.  I typically wait till I have a few Audiobooks in the que before tagging and archiving.  

   I set up an AutoHotKey that opens 4 windows in quadrants on my screen: Untagged Source Folder, Temp working folder, mp3tag, and goodreads.com (in case I need to look up metadata not on Audible).

   Following this guide will also give you everything you need for a properly organized Booksonic server.  While Plex doesn't really care about your folder structure, Booksonic exclusively uses folder structure and cover.jpg files for it's organization.

   If you have an iOS device use the [Prologue app](https://prologue-app.com/), it is *miles* better than the Plex for iOS app.

   For Android devices, I actually gave up on using the Plex app after it constantly kept loosing my place, marked the book as finished at 90%, and doesn't record the watch status. I ended up using booksonic to dl the books I want locally and use Smart Audiobook Player, with Plex as a backup.
