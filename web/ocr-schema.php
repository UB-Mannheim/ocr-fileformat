<?php

/**
 * Send a Malformed Request error.
 */
function send400($msg)
{
  http_response_code(400);
  header("Content-Type: text/plain");
  echo $msg;
}

/**
 * Send a JSON response
 */
function sendJSON($data)
{
  header("Content-Type: application/json");
  echo json_encode($data);
}

/**
 * Open a bidirectinal child process, write data into it and echo the result.
 */
function pipeToCommand($cmd, $xml)
{
  $descriptorspec = array(
    0 => array("pipe", "r"),
    1 => array("pipe", "w"),
    2 => array("file", "/tmp/error-output.txt", "a")
  );
  $process = proc_open($cmd, $descriptorspec, $pipes);
  if (is_resource($process)) {
    fwrite($pipes[0], $xml);
    fclose($pipes[0]);
    echo stream_get_contents($pipes[1]);
    fclose($pipes[1]);
    proc_close($process);
  }
}

/**
 * Transform from one format to another, fetching the data by URL
 */
function transformURL($url, $from, $to)
{
  global $list;
  if (!in_array($from . "__" . $to, $list["transform"])) {
    send400("No such transformation '$from -> $to'");
    return;
  }
  $xml = file_get_contents($url);
  if (!$xml) {
    send400("Could not retrieve URL '$url'");
    return;
  }
  header("Content-Type: " . $to === "html" ? "text/html" : "application/xml"); 
  pipeToCommand("ocr-transform -d '$from' '$to' - -- '!indent=yes'", $xml);
}

/**
 * Validate against a schema, data retrieved via HTTP GET.
 */
function validateURL($url, $schema)
{
  global $list;
  if (!in_array($schema, $list['validate'])) {
    send400("No such schema '$schema'");
    return;
  }
  header("Content-Type: text/plain");
  $xml = file_get_contents($url);
  if (!$xml) {
    send400("Could not retrieve URL '$url'");
    return;
  }
  header("Content-Type: text/plain");
  pipeToCommand("ocr-validate $schema -", $xml);
}

/**
 * List of installed transform from-to-tuples.
 * List of installed schemas.
 */
$list = array(
  "transform" => preg_split("/\s+/", exec('ocr-transform -L')),
  "validate" => preg_split("/\s+/", exec('ocr-validate -L')),
);

/**
 * Handle request
 */
if ($_GET["do"] === "list") {
  sendJSON($list);
} else if ($_GET["do"] === "transform") {
  transformURL($_GET["url"], $_GET["from"], $_GET["to"]);
} else if ($_GET["do"] === "validate") {
  validateURL($_GET["url"], $_GET["schema"]);
} else {
  send400("Unknown/missing action, set 'do' parameter to either 'validate' or 'transform'");
}
