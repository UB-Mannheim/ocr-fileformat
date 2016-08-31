<?php
if(!defined('IncludingScript')) {
   die('Direct access not permitted');
}

// We don't want ANSI coloring
putenv('TERM=dumb');

$config = array(
    'ocr-validate' => dirname(__FILE__) . '/../bin/ocr-validate.sh',
    'ocr-transform' => dirname(__FILE__) . '/../bin/ocr-transform.sh',
    'formats' => array(
        'transform' => array(),
        'validate' => array(),
    ),
);

/**
 * List of installed transform from-to-tuples.
 * List of installed schemas.
 */
function buildFormatList()
{
    global $config;
    $lines = array();
    exec($config['ocr-transform'] . ' -L', $lines);
    foreach ($lines as $line) {
        $fromto = preg_split("/\s+/", $line);
        $from = $fromto[0];
        $to = $fromto[1];
        // echo $from, "\t", $to, "\n";
        if (! array_key_exists($from, $config['formats']['transform'])) {
            $config['formats']['transform'][$from] = array($to);
        } else {
            array_push($config['formats']['transform'][$from], $to);
        }
    }
    exec($config['ocr-validate'] . ' -L', $config['formats']['validate']);
}

buildFormatList();

return $config;
