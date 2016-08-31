<?php

// To hide the config
define('IncludingScript', TRUE);

$config = include('config.php');


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
  global $config;
  $errfile = "/tmp/error-output.txt";
  $descriptorspec = array(
    0 => array("pipe", "r"),
    1 => array("pipe", "w"),
    2 => array("pipe", "w"),
  );
  $process = proc_open("TERM=dumb " . $cmd, $descriptorspec, $pipes);
  $ret = array();
  if (is_resource($process)) {
    fwrite($pipes[0], $xml);
    fclose($pipes[0]);
    $ret['stdout'] = stream_get_contents($pipes[1]);
    $ret['stderr'] = stream_get_contents($pipes[2]);
    fclose($pipes[1]);
    fclose($pipes[2]);
    proc_close($process);
    return $ret;
  }
}

/**
 * Transform from one format to another, fetching the data by URL
 */
function transformURL($url, $from, $to)
{
  global $config;
  if (!array_key_exists($from, $config['formats']['transform'])
    || !in_array($to, $config['formats']['transform'][$from])) {
    send400("No such transformation '$from -> $to'");
    return;
  }
  $xml = file_get_contents($url);
  if (!$xml) {
    send400("Could not retrieve URL '$url'");
    return;
  }
  header("Content-Type: " . $to === "html" ? "text/html" : "application/xml"); 
  $res = pipeToCommand($config['ocr-transform'] . " -d '$from' '$to' - -- '!indent=yes'", $xml);
  echo $res['stdout'];
}

/**
 * Validate against a schema, data retrieved via HTTP GET.
 */
function validateURL($url, $schema)
{
  global $config;
  if (!in_array($schema, $config['formats']['validate'])) {
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
  $res = pipeToCommand($config['ocr-validate'] . " $schema -", $xml);
  echo $res['stdout'];
  echo $res['stderr'];
}

/**
 * Handle request
 */
if ($_GET["do"] === "list") {
  sendJSON($config['formats']);
} else if ($_GET["do"] === "transform") {
  transformURL($_GET["url"], $_GET["from"], $_GET["to"]);
} else if ($_GET["do"] === "validate") {
  validateURL($_GET["url"], $_GET["format"]);
} else {
  send400("Unknown/missing action, set 'do' parameter to either 'validate' or 'transform'");
}
