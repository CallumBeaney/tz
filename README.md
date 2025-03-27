## TZ (for MacOS)

### Why use this
IDK maybe you're in place A and you're working on something for place B and the backend doesn't have timezone handling implemented and Simulator follows the MacOS system timezone which is STUPID but you hate going back and forth through the GUI so you spend your precious free moments, your life Ticking Away, to write a script that makes doing that easier for yourself  

This is just a wrapper around some MacOS system commands.  

### Setup

Go to `Date & Time` in MacOS system settings and unselect `Set time and date automatically` and `Set time zone automatically using your current location`.  

### Things to do
- Implement better UX by e.g. filtering subregion by alphabet indexes
- possibly implement using TTY that allows substring-based search if a package exists
- check `sudo systemsetup -help` to see if any other useful CLI tools can be made
