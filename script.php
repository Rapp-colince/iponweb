<?php

try{

    // Validation
    if(empty($argv[1])){
        throw new Exception("Unknown file");
    }
    $filePath = __DIR__.DIRECTORY_SEPARATOR.$argv[1];

    if(file_exists($filePath)===false){
        throw new Exception("File doesn't exist");
    }
    if(is_readable($filePath)===false){
        throw new Exception("File doesn't readable");
    }
    if(empty($argv[2])){
        throw new Exception("Unknown limit");
    }
    $limit = $argv[2];
    if(is_numeric($limit)===false){
        throw new Exception("Limit isn't numeric");
    }


    // Basic logic
    $data = file_get_contents($filePath);
    $data = trim($data, "\n");
    $data = preg_split('/\n+/', $data); // one or more new line

    $result = array_count_values($data);
    arsort($result);
    $result = array_slice($result, 0, $limit);


    // View
    foreach($result as $string => $count){
        echo $string.': '.$count.PHP_EOL;
    }


}catch(Exception $ex){
    echo $ex->getMessage();
}
