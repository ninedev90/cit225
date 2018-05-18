<html>
<! Program: UploadItemBlobMySQL.php                           >
<! Date:    05-Jul-2009                                       >
<! Author:  Michael McLaughlin                                >
<!                                                            >
<! This script demonstrates uploading, moving an uploaded     >
<! file, storing the content in a MySQL MEDIUMBLOB column     >
<! addslashes and stripslashes on the contents of a file      >
<! read after upload to the server.                           >
<! ========================================================== >
<! Change Log:                                                >
<!  24-02-2010  Replaced ereg() with preg_match(); updated    >
<!              the search string to be regular expression    >
<!              compatible for Zend Server 4.                 >
<! ========================================================== >
<head>
<title>
  Sample Demonstrating Large Text and Blob Data
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php
  // Set database credentials.
  include_once("MySQLCredentials.inc");

  // Displayed moved file in web page.
  $item_blob = process_uploaded_file();

  // Return successful attempt to connect to the database.
  if (!$c = @mysqli_connect(HOSTNAME,USERNAME,PASSWORD,DATABASE)) {
    // Print user message.
    print "Sorry! The connection to the database failed. Please try again later.";

    // Assign the mysqli_error() error and format double and single quotes.
    print mysqli_error();

    // Kill the resource.
    die();
  }
  else {
    // Declare input variables.
    $id = (isset($_POST['id'])) ? (int) $_POST['id'] : 1021;
    $title = (isset($_POST['title'])) ? $_POST['title'] : "Harry #1";

    // Initialize a statement in the scope of the connection.
    $stmt = mysqli_stmt_init($c);
  
   // Declare a PL/SQL execution command.
    $sql = "UPDATE item SET item_blob = ? WHERE item_id =  ?";

    // Prepare statement and link it to a connection.
    if (mysqli_stmt_prepare($stmt,$sql)) {
      mysqli_stmt_bind_param($stmt,"bi",$item_blob,$id);

      // Send the binary data.
      $start = 0;
      $chunk = 8192;
      while ($start < strlen($item_blob)) {
        mysqli_stmt_send_long_data($stmt,0,substr($item_blob,$start,$chunk));
        $start += $chunk;
      }

      // Execute the PL/SQL statement.
      if (mysqli_stmt_execute($stmt)) {
        query_insert($id,$title);
      }
      else {
        print "You're target row doesn't exist.";
      }
    }
    else { print "mysqli_stmt_prepare() failed."; }
    // Disconnect from database.
    mysqli_close($c);
  }

  // Query results afret an insert.
  function query_insert($id,$title)
  {
    // Return successful attempt to connect to the database.
    if (!$c = @mysqli_connect(HOSTNAME,USERNAME,PASSWORD,DATABASE)) {
      // Print user message.
      print "Sorry! The connection to the database failed. Please try again later.";

      // Assign the OCI error and format double and single quotes.
      print mysqli_error();

      // Kill the resource.
      die();
    }
    else {

      // Initialize a statement in the scope of the connection.
      $stmt = mysqli_stmt_init($c);
      
      // Declare a SQL SELECT statement returning a CLOB.
      $sql = "SELECT item_desc FROM item WHERE item_id = ?";

      // Prepare statement and link it to a connection.
      if (mysqli_stmt_prepare($stmt,$sql)) {
        mysqli_stmt_bind_param($stmt,"i",$id);
    
        // Execute the PL/SQL statement.
        if (mysqli_stmt_execute($stmt)) {

          // Bind result to local variable.
          mysqli_stmt_bind_result($stmt, $data);

          // Read result.
          mysqli_stmt_fetch($stmt);
  
          // Format HTML table to display BLOB photo and CLOB description.
          $out = '<table border="1" cellpadding="5" cellspacing="0">';
          $out .= '<tr>';
          $out .= '<td align="center" class="e">'.$title.'</td>';
          $out .= '</tr>';
          $out .= '<tr><td class="v">';
          $out .= '<div>';
          $out .= '<div style="margin-right:5px;float:left">';
          $out .= '<img src="ConvertMySQLBlobToImage.php?id='.$id.'">';
          $out .= '</div>';
          $out .= '<div style="position=relative;">'.$data.'</div>';
          $out .= '</div>';
          $out .= '</td></tr>';
          $out .= '</table>';

          // Print the HTML table.
          print $out;
        }
        else {
          print "You're target row doesn't exist.";
        }
      }
 
      // Disconnect from database.
      mysqli_close($c);
    }
  }

  // Manage file upload and return file as string.
  function process_uploaded_file()
  {
    // Declare a variable for file contents.
    $contents = "";

    // Define the upload file name for Windows or Linux.
    if (preg_match(".Win32.",$_SERVER["SERVER_SOFTWARE"]))
      $upload_file = "C:\\temp\\".$_FILES['userfile']['name'];
    else
      $upload_file = "/tmp/".$_FILES['userfile']['name'];

    // Check for and move uploaded file.
    if (is_uploaded_file($_FILES['userfile']['tmp_name']))
      move_uploaded_file($_FILES['userfile']['tmp_name'],$upload_file);

    // Open a file handle and suppress an error for a missing file.
    if ($fp = @fopen($upload_file,"r"))
    {
      // Read until the end-of-file marker.
      while (!feof($fp))
        $contents .= fgetc($fp);

      // Close an open file handle.
      fclose($fp);
    }

    // Return file content as string.
    return $contents;
  }
?>
</body>
</html>
