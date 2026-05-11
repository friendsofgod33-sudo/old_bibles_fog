# Bible App - Quick Start Testing Guide

## Status: 6/56 Books Installed ✅

**Installed titles:**
- King James Version (1611)
- Geneva Bible (1560)
- Tyndale Bible (1526)
- Confessions of St. Augustine
- The Pilgrim's Progress
- Orthodoxy (G.K. Chesterton)
- Imitation of Christ (Thomas à Kempis)
- Practice of the Presence of God (Brother Lawrence)

## How to Test the App

### Step 1: Confirm App is Running
```
cd C:\Users\chand\old_bibles
flutter run -d 107322538A001990 --debug --no-enable-impeller
```

### Step 2: On the Device (TECNO CK9n)

**Tab 1 - Reader:**
1. Tap the **Language** field (top-left)
2. Select "English (US)" or any language
3. Tap the **Translation** dropdown (shows "Select a translation")
4. Look for section: **Bibles & Scriptures**
5. Select "King James Version (1611)"
6. Select "Genesis" from Book dropdown
7. Select "1" from Chapter dropdown
8. Tap the **blue "Read Chapter" button**
9. You should hear the Genesis passage read aloud!

**Expected Results:**
- ✅ No error messages
- ✅ App reads Genesis 1:1-10 in English voice
- ✅ Text displays in verses panel on screen
- ✅ Button turns red while reading, blue when idle

**Tab 2 - Book Chat:**
1. Tap the "Book Chat" tab
2. In the text field, type: `kjv_1611.txt`
3. Tap "Load" or Send button
4. Wait for loading indicator
5. You should see the first 20 lines of Genesis displayed

**Expected Results:**
- ✅ No "File not found" error
- ✅ Bible text appears
- ✅ Shows "(N lines total)" at bottom
- ✅ Loading indicator clears

### Step 3: Test Different Translations

Try selecting other installed titles:
- **Augustine's Confessions** - Shows philosophical text, reads aloud
- **Pilgrim's Progress** - Shows narrative text
- **Orthodoxy** - Shows modern Christian apologetics
- **Imitation of Christ** - Shows devotional text

### Step 4: Verify Translation Picker Works

1. Tap Translation dropdown
2. Verify all installed books appear in correct sections:
   - **Bibles & Scriptures:** KJV, Geneva, Tyndale (+ others you download)
   - **Devotionals & Early Writings:** Augustine, Pilgrim's Progress, Orthodoxy, Thomas à Kempis, Brother Lawrence

### Step 5: Test Language Switching

1. Tap Language field
2. Search: "spanish" or "français"
3. Select a different language
4. TTS should speak in that language voice (if available)
5. UI text should translate
6. Go back to English

## Troubleshooting

### Issue: "Full text not installed yet"
- **Cause:** Book ID exists in catalog but .txt file missing from assets/texts
- **Fix:** Download the file using BOOK_DOWNLOAD_GUIDE.md

### Issue: App crashes when clicking a book
- **Cause:** Background isolate error or missing asset
- **Fix:** Run `flutter analyze` and check for errors

### Issue: Can't hear audio
- **Cause:** TTS not installed or language not supported on device
- **Check:** 
  - Device has Google Play TTS installed
  - Audio is not muted
  - Selected language has voices available

### Issue: Book Chat shows "File not found"
- **Cause:** Filename doesn't exactly match an installed file
- **Fix:** Check exact filename in assets/texts/ directory

## Next Steps

1. **Test current 6 books** (this guide)
2. **Download Priority Group 1** (10 additional files) using BOOK_DOWNLOAD_GUIDE.md
3. **Copy downloaded files** to `C:\Users\chand\old_bibles\assets\texts\`
4. **Rebuild app** (`flutter run`) - Hot reload may not pick up new assets
5. **Verify new books appear** in Translation dropdown
6. **Continue downloading** remaining groups

## Performance Notes

**Expected Behavior:**
- Initial app load: ~3-5 seconds, may skip 300-400 frames (normal)
- Book selection: Instant
- Text rendering: Smooth after load
- TTS startup: 1-2 seconds before speaking

**Frame skipping is normal** during:
- App initialization
- Font loading
- TTS engine startup
- Initial rendering

After initialization, app should maintain 60 FPS and be very smooth.

## File Structure

```
assets/
  texts/
    kjv_1611.txt                    ✅ Installed
    geneva_1560.txt                 ✅ Installed
    tyndale_1526.txt                ✅ Installed
    confessions_augustine.txt       ✅ Installed
    pilgrims_progress.txt           ✅ Installed
    orthodoxy_chesterton.txt        ✅ Installed
    imitation_of_christ.txt         ✅ Installed
    practice_presence_of_god.txt    ✅ Installed
    [50 more files needed]          ⏳ Pending download
```

## Success Criteria ✓

- [ ] App launches without errors
- [ ] Can select language and see translation
- [ ] Can select installed book from dropdown
- [ ] Text displays correctly
- [ ] TTS reads text aloud
- [ ] Language switching works
- [ ] Book Chat tab loads file correctly
- [ ] No crashes or exceptions

---

**When all 56 books are installed:**
- User will have a complete, offline-capable Bible + Christian classics reader
- Full text search could be added (future enhancement)
- Verse bookmarking could be added (future enhancement)
- Multiple language TTS for different texts

**Happy testing! 📖🔊**
