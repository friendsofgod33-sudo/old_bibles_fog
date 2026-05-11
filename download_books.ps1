# Bible App - Automated Book Downloader
# This script downloads public-domain Christian texts from Project Gutenberg
# and organizes them into the assets/texts directory

param(
    [string]$TargetDir = "C:\Users\chand\old_bibles\assets\texts",
    [string]$LogFile = "C:\Users\chand\old_bibles\download_log.txt"
)

# Ensure target directory exists
if (!(Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
}

# Initialize log
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LogFile "`n=== Download Session: $timestamp ==="

# Define book mapping (ID -> Gutenberg/CCEL identifier)
# Format: @{ "local_id" = "source_url" }

$books = @{
    # Already installed - skip
    "kjv_1611"                          = "SKIP"; # Already installed
    "confessions_augustine"             = "SKIP"; # Already installed
    "pilgrims_progress"                 = "SKIP"; # Already installed
    "orthodoxy_chesterton"              = "SKIP"; # Already installed
    "imitation_of_christ"               = "SKIP"; # Already installed
    "practice_presence_of_god"          = "SKIP"; # Already installed
    
    # Priority Group 1 - Bibles & Foundational
    "great_bible_1540"                  = "SEARCH:great_bible"; # Gutenberg search
    "revised_version_1885"              = "https://www.gutenberg.org/files/10753/10753-0.txt"; # Revised Version
    "american_standard_1901"            = "SEARCH:american_standard_version"; # ASV
    "foxes_book_of_martyrs"             = "https://www.gutenberg.org/files/22400/22400-0.txt";
    "city_of_god_augustine"             = "SEARCH:city_of_god"; # CCEL has this
    "institutes_christian_religion"     = "SEARCH:institutes_calvin";
    "summa_theologica"                  = "SEARCH:summa_theologiae"; # Long text
    "rule_of_st_benedict"               = "SEARCH:rule_of_saint_benedict";
    "pensees_pascal"                    = "https://www.gutenberg.org/files/3030/3030-0.txt";
    "ben_hur"                           = "https://www.gutenberg.org/files/28322/28322-0.txt";
    
    # Priority Group 2 - Early Church
    "didache"                           = "SEARCH:didache";
    "epistle_of_clement"                = "SEARCH:clement_epistle";
    "first_epistle_clement"             = "SEARCH:clement_epistle"; # Variant
    "letters_ignatius"                  = "SEARCH:ignatius_antioch";
    "first_apology_justin"              = "SEARCH:justin_martyr_apology";
    "shepherd_of_hermas"                = "https://www.gutenberg.org/files/2014/2014-0.txt";
    "apostolic_tradition"               = "SEARCH:apostolic_tradition";
    "commonitorium_vincent"             = "SEARCH:vincent_lerins";
    
    # Priority Group 3 - Medieval & Reformation
    "ninety_five_theses"                = "SEARCH:95_theses";
    "book_of_common_prayer_1549"        = "https://www.gutenberg.org/files/10037/10037-0.txt";
    "proslogion_anselm"                 = "SEARCH:proslogion_anselm";
    "on_the_incarnation"                = "SEARCH:incarnation_athanasius";
    "pastoral_rule_gregory"             = "SEARCH:pastoral_rule";
    "interior_castle"                   = "SEARCH:interior_castle";
    "why_god_became_man"                = "SEARCH:cur_deus_homo";
    "octavius_minucius_felix"           = "SEARCH:octavius";
    "in_his_steps"                      = "https://www.gutenberg.org/files/138/138-0.txt";
    "against_heresies_irenaeus"         = "SEARCH:irenaeus_heresies";
    
    # Priority Group 4 - Devotionals
    "way_of_a_pilgrim"                  = "https://www.gutenberg.org/files/7213/7213-0.txt";
    "quiet_talks_on_prayer"             = "https://www.gutenberg.org/files/11017/11017-0.txt";
    "religious_affections"              = "SEARCH:religious_affections_edwards";
    "plain_account_christian_perfection"= "SEARCH:plain_account_wesley";
    "morning_evening_devotional"        = "https://www.gutenberg.org/files/12402/12402-0.txt";
    "journal_of_george_fox"             = "https://www.gutenberg.org/files/3928/3928-0.txt";
    "soul_of_prayer_forsyth"            = "SEARCH:soul_prayer_forsyth";
    "varieties_religious_experience"    = "https://www.gutenberg.org/files/621/621-0.txt";
    "training_of_the_twelve"            = "SEARCH:training_twelve_bruce";
    "everlasting_man"                   = "https://www.gutenberg.org/files/7439/7439-0.txt";
    "book_of_enoch"                     = "https://www.gutenberg.org/files/22500/22500-0.txt";
    "geneva_1560"                       = "SEARCH:geneva_bible"; # May need manual search
    "tyndale_1526"                      = "SEARCH:tyndale_bible"; # Partial available
}

# Download function
function Download-Book {
    param(
        [string]$BookId,
        [string]$Source
    )
    
    if ($Source -eq "SKIP") {
        Write-Host "⏭  Skipping $BookId (already installed)"
        Add-Content $LogFile "SKIP: $BookId"
        return
    }
    
    if ($Source.StartsWith("SEARCH:")) {
        $searchTerm = $Source.Replace("SEARCH:", "")
        Write-Host "⚠️  Manual search needed: $BookId"
        Write-Host "   Search Project Gutenberg or CCEL for: $searchTerm"
        Write-Host "   Download as .txt and save to: $TargetDir\$BookId.txt"
        Add-Content $LogFile "MANUAL: $BookId - Search for: $searchTerm"
        return
    }
    
    $outputFile = Join-Path $TargetDir "$BookId.txt"
    
    if (Test-Path $outputFile) {
        Write-Host "✓ Already exists: $BookId.txt"
        Add-Content $LogFile "EXISTS: $BookId"
        return
    }
    
    Write-Host "⬇️  Downloading: $BookId"
    try {
        Invoke-WebRequest -Uri $Source -OutFile $outputFile -TimeoutSec 30
        $fileSize = (Get-Item $outputFile).Length / 1KB
        Write-Host "✓ Downloaded: $BookId.txt ($([math]::Round($fileSize, 1)) KB)"
        Add-Content $LogFile "SUCCESS: $BookId ($([math]::Round($fileSize, 1)) KB)"
    }
    catch {
        Write-Host "✗ Failed to download: $BookId"
        Write-Host "  Error: $($_.Exception.Message)"
        Add-Content $LogFile "FAILED: $BookId - $($_.Exception.Message)"
    }
}

# Download all books
Write-Host "🔄 Starting book downloads to: $TargetDir"
Write-Host ""

$books.GetEnumerator() | ForEach-Object {
    Download-Book -BookId $_.Key -Source $_.Value
    Start-Sleep -Milliseconds 500 # Rate limiting
}

Write-Host ""
Write-Host "✅ Download session complete!"
Write-Host "📋 Check $LogFile for full details"

# Verify installation
Write-Host ""
Write-Host "📊 Current status:"
$count = (Get-ChildItem "$TargetDir\*.txt" -ErrorAction SilentlyContinue).Count
Write-Host "   Installed: $count / 56 files"
