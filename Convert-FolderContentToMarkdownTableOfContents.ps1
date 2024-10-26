function Convert-FolderContentToMarkdownTableOfContents {
    param (
        [string]$BaseFolder,
        [string]$FiletypeFilter,
        [int]$Level = 0
    )
 
    $nl = [System.Environment]::NewLine
    $TOC = ""
 
   $repoStructure = Get-ChildItem -Path $BaseFolder.FullName -Filter $FiletypeFilter
    foreach ($md in ($repoStructure | Where-Object Name -NotMatch "index.md" | Sort-Object -Property Name)) {
        $file_data = Get-Content "$($md.Directory.ToString())\$($md.Name)" -Encoding UTF8
        if ($file_data.count -gt 0) {
            $fileName = $file_data[0] -replace "# "
            $relativePath = $md.Directory.ToString().Replace((Get-Item $BaseFolder).Parent.FullName, "").TrimStart("\").Replace("\", "/")
            $suffix = "https://mars9n9.github.io/cookbooks" + $($md.Directory.ToString().Replace($BaseFolder, [string]::Empty)).Replace("\", "/")
        
            $TOC += "$(""  " * ($Level + 1))* [$fileName]($([uri]::EscapeUriString(""$suffix/$($md.Name.Replace(".md", ".html"))"")))$nl"
        }}
    return $TOC
}

# Get the current directory
$currentDirectory = Get-Location
Convert-FolderContentToMarkdownTableOfContents -BaseFolder $currentDirectory -FiletypeFilter "*.md" | Out-File (Join-Path $currentDirectory "index.md") -Encoding UTF8
