<?php
  /*  ConvertBlobToImage.php
   *  by Michael McLaughlin
   *
   *  This script queries an image from a BLOB column and
   *  converts it to a PNG image.
   *
   *  ALERT:
   *
   *  The header must be inside the PHP script tag because nothing
   *  can be rendered before the header() function call that signals
   *  this is a PNG file.
   */

    // Database credentials must be set manually because an include_once() function
    // call puts something ahead of the header, which causes a failure when rendering
    // an image.

    // Include the credential library.
    include_once("MySQLCredentials.inc");
    
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

    // Declare input variables.
    $id = (isset($_GET['id'])) ? (int) $_GET['id'] : 1023;

    // Initialize a statement in the scope of the connection.
    $stmt = mysqli_stmt_init($c);
      
    // Declare a SQL SELECT statement returning a MediumBLOB.
    $sql = "SELECT item_blob FROM item WHERE item_id = ?";

    // Prepare statement and link it to a connection.
    if (mysqli_stmt_prepare($stmt,$sql)) {
      mysqli_stmt_bind_param($stmt,"i",$id);
    
      // Execute the PL/SQL statement.
      if (mysqli_stmt_execute($stmt)) {

        // Bind result to local variable.
	      mysqli_stmt_bind_result($stmt, $image);

        // Read result.
        mysqli_stmt_fetch($stmt);
      }
    } 

    // Disconnect from database.
    mysqli_close($c);
    
    // Print the header first.
    header('Content-type: image/png');
    imagepng(imagecreatefromstring($image));
  }
?>
