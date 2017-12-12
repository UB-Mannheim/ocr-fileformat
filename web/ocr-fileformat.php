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
function transform($url, $from, $to)
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
function validate($url, $format)
{
  global $config;
  if (!in_array($format, $config['formats']['validate'])) {
    return send400("No validator for '$format'");
  }
  header("Content-Type: text/plain");
  $xml = file_get_contents($url);
  if (!$xml) {
    return send400("Could not retrieve URL '$url'");
  }
  header("Content-Type: text/plain");
  $res = pipeToCommand($config['ocr-validate'] . " " . $format . " -", $xml);
  echo $res['stdout'];
  echo $res['stderr'];
}

/**
 * Handle request
 */
if (array_key_exists('file', $_FILES)) {
    $_GET['url'] = $_FILES["file"]['tmp_name'];
}

switch ($_GET['do']) {
  case 'list':
    sendJSON($config['formats']);
    break;
  case 'transform':
    if (!array_key_exists('url', $_GET)) {
      return send400("Must be either POST with file field 'file' or GET with param 'url'.");
    }
    transform($_GET["url"], $_GET["from"], $_GET["to"]);
    break;
  case 'validate':
    if (!array_key_exists('url', $_GET)) {
      return send400("Must be either POST with file field 'file' or GET with param 'url'.");
    }
    validate($_GET["url"], $_GET["format"]);
    break;
  default:
    send400("Unknown/missing action, set 'do' parameter to either 'validate' or 'transform'");
    break;
}
