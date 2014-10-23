/*jslint browser:true*/
/*global $*/

$(function () {
    "use strict";

    // this is the jQuery code for like/hate, unlike/unhate.
    // when user votes a movie, the page is not reloaded, only the vote section is changing
    $(".vote-section").on("click", ".vote-link", function () {
        var url = $(this).attr("data-url"),
            vote_section = $(this).parent().parent(),
            method = $(this).attr("data-method");

        $.ajax({
            url: url,
            type: method,
            dataType: 'json'
        }).done(function (data) {
            vote_section.empty().append(data.votes);
        });
    });
});