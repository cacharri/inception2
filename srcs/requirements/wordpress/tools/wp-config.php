<?php
/**
 * The base configuration for WordPress
 *
 * This file has been generated to pull all sensitive values from environment
 * variables and to ensure proper constants for Docker-based setups.
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 * @package WordPress
 */

// ** MySQL settings - pulled from ENV vars ** //
define( 'DB_NAME',     getenv('MYSQL_DATABASE') ?: die('Falta la var MYSQL_DATABASE') );
define( 'DB_USER',     getenv('MYSQL_USER')     ?: die('Falta la var MYSQL_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') ?: die('Falta la var MYSQL_PASSWORD') );
// Si tu servicio de MariaDB se llama "mysql" y escucha en el puerto 3306:
define( 'DB_HOST',     ( getenv('MYSQL_HOST') ?: 'mysql' ) . ':3306' );

define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'WP_ALLOW_REPAIR', true );

/**#@+
 * Authentication Unique Keys and Salts.
 * Generados desde https://api.wordpress.org/secret-key/1.1/salt/
 */
define( 'AUTH_KEY',         '):Uw9 :|7$m3yy=c^IM%d8}zG6yXY%25SDUyr.r#GcDP)[b25Yn$sDLNwR~I=kwq' );
define( 'SECURE_AUTH_KEY',  'lBWxAzhu=StQ(s-[t_D8yH8_`0NiM~d[m q<{Hri]n#UM3J;@x[ne;,k<~cN`~%,' );
define( 'LOGGED_IN_KEY',    ' /e+%ecWs`>hA<s`|+7rmujt>3MA}GD*n=D7W%$8h*Xc!jP?hn+fw0#;;g{Ywl@k' );
define( 'NONCE_KEY',        ' -cX{xQc|GjD$=kXd,|lUX5)*oT)ru3^px-iU{q;`1If22EqIwA0/lPIIbpbtB=C' );
define( 'AUTH_SALT',        'U9LX s1@q6$[*VV,MUhL7tS@;I9t_u*uDQIfZdG.ei1Amy$*.RI_TSTz#y=X.>Wq' );
define( 'SECURE_AUTH_SALT', '0<MR&l4v=cZ)8Ke/#ip>2<Ed@ j<#pvLaOMc-jEFM9^tr`X*T2qDIB@)gg.0<e2V' );
define( 'LOGGED_IN_SALT',   'xSHh4B]r[~)h%n$f(dCt;mD}#q gy$<{ >qGgPS>XH*]jH>W<!10>H<_16l{(OdP' );
define( 'NONCE_SALT',       '7Ea$kvU|lkO8&X]b7^#K+w! lH2)SOelLiaYYX(Zz)Ebk_]-#m,J&aM<*JedFa| ' );
/**#@-*/

// ** Filesystem and permissions ** //
define( 'FS_METHOD',    'direct' );
define( 'FS_CHMOD_FILE', 0644 );
define( 'FS_CHMOD_DIR',  0755 );

// ** Redis cache ** //
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_CACHE',      true );

// ** Database table prefix ** //
$table_prefix = 'wp_';

// ** Debug mode ** //
define( 'WP_DEBUG', true );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
