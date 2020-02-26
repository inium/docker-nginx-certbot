<?php
    // 1. Check PDO MySQL Connection
    try {
        $host = getenv('MYSQL_HOST');
        $user = getenv('MYSQL_USER');
        $pass = getenv('MYSQL_PASSWORD');

        $pdo = new \PDO("mysql:host={$host}", $user, $pass);

        echo "PDO Connection Succeed.";
    }
    catch (\Exception $e) {
        echo "PDO Connection Failed: " . $e->getMessage();
    }

    echo '<hr>';

    // 2. Print phpinfo.
    phpinfo();
