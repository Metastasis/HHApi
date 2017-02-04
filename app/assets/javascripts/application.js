// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {

    function fetchUserInfo() {
        alert("Резюме отправились на обработку.");
    }

    function usersEmailed() {

    }

    function buildQuery(fromObject) {
        var parts = [];

        for (var key in fromObject) {
            parts.push(key + '=' + fromObject[key]);
        }

        return parts.join('&');
    }

    var $candidatesForm = $('form#candidates');
    var $emailForm = $('form#send-emails');

    $candidatesForm.submit(function(e) {
        var query = {};
        var queryString = $candidatesForm[0].resume_url.value;
        var fromPage = parseFloat($candidatesForm[0].from_page.value);
        var toPage = parseFloat($candidatesForm[0].to_page.value);
        var params = queryString.split("&");
        var pageQuery = {
            'fromPage': fromPage,
            'toPage': toPage
        };

        params.forEach(function(value) {
            var obj = value.split('=');
            query[obj[0]] = obj[1];
        });

        setTimeout(function() {
            query['page'] = String(fromPage);
            var url = "/users?resume_url=" + encodeURIComponent(
                buildQuery(query)) + "&" + buildQuery(
                pageQuery);

            $.ajax({
                url: url,
                // dataType: "json",
                cache: false,
                success: fetchUserInfo
            });
        }, 1000);

        return false;
    });

    $emailForm.submit(function(e) {
        var data = $emailForm.serialize();

        $.ajax({
            url: "/email",
            method: 'post',
            data: data,
            cache: false
            // success: usersEmailed
        });

        return false;
    });

});
