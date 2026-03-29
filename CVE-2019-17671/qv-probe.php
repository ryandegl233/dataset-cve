<?php
/*
Plugin Name: Query Var Probe
Description: Detect whether 'static' query variable is accepted by WordPress.
*/

add_action('parse_request', function($wp) {

    $public = 0;
    $in_query = 0;

    if (isset($wp->public_query_vars) && in_array('static', $wp->public_query_vars)) {
        $public = 1;
    }

    if (isset($wp->query_vars) && array_key_exists('static', $wp->query_vars)) {
        $in_query = 1;
    }

    header("X-Static-PublicQv: $public");
    header("X-Static-InQueryVars: $in_query");

}, 0);
