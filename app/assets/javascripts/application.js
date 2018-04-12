// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/annotations
//= require highcharts/modules/data
//= require highcharts/modules/drilldown
//= require highcharts/modules/exporting
//= require highcharts/modules/funnel
//= require highcharts/modules/no-data-to-display
//= require highcharts/modules/offline-exporting
//= require_tree.

$(document).on('turbolinks:load', function() {
    filterDistricts();
});

function filterDistricts(){
    $('#admin_district_id').parent().hide()
    var districts = $('#admin_district_id').html();

    $('#admin_province_id').change(function(){
        var selectedProvinceCategory = $('#admin_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#admin_district_id').html(options);
            $('#admin_district_id').parent().show();
        }else {
            $('#admin_district_id').empty();
            $('#admin_district_id').parent().hide();
        }
    });
}

$(document).on('turbolinks:load', function() {
    filterDistrictsUser();
});

function filterDistrictsUser(){
    $('#user_district_id').parent().hide()
    var districts = $('#user_district_id').html();

    $('#user_province_id').change(function(){
        var selectedProvinceCategory = $('#user_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#user_district_id').html(options);
            $('#user_district_id').parent().show();
        }else {
            $('#user_district_id').empty();
            $('#user_district_id').parent().hide();
        }
    });
}

$(document).on('turbolinks:load', function() {
    filterDistrictsDoctor();
});

function filterDistrictsDoctor(){
    $('#doctor_district_id').parent().hide()
    var districts = $('#doctor_district_id').html();

    $('#doctor_province_id').change(function(){
        var selectedProvinceCategory = $('#doctor_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#doctor_district_id').html(options);
            $('#doctor_district_id').parent().show();
        }else {
            $('#doctor_district_id').empty();
            $('#doctor_district_id').parent().hide();
        }
    });
}

$(document).on('turbolinks:load', function() {
    filterDistrictsPatient();
});

function filterDistrictsPatient(){
    $('#patient_district_id').parent().hide()
    var districts = $('#patient_district_id').html();

    $('#patient_province_id').change(function(){
        var selectedProvinceCategory = $('#patient_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#patient_district_id').html(options);
            $('#patient_district_id').parent().show();
        }else {
            $('#patient_district_id').empty();
            $('#patient_district_id').parent().hide();
        }
    });
}

$(document).on('turbolinks:load', function() {
    filterDistrictsNurse();
});

function filterDistrictsNurse(){
    $('#nurse_district_id').parent().hide()
    var districts = $('#nurse_district_id').html();

    $('#nurse_province_id').change(function(){
        var selectedProvinceCategory = $('#nurse_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#nurse_district_id').html(options);
            $('#nurse_district_id').parent().show();
        }else {
            $('#nurse_district_id').empty();
            $('#nurse_district_id').parent().hide();
        }
    });
}

$(document).on('turbolinks:load', function() {
    filterDistrictsDashboard();
});

function filterDistrictsDashboard(){
    $('#district_district_id').parent().hide()
    var districts = $('#district_district_id').html();

    $('#province_province_id').change(function(){
        var selectedProvinceCategory = $('#province_province_id :selected').text();
        var optgroup = "optgroup[label='"+ selectedProvinceCategory + "']";
        var options = $(districts).filter(optgroup).html();

        if (options){
            $('#district_district_id').html(options);
            $('#district_district_id').parent().show();

        }else {
            $('#district_district_id').empty();
            $('#district_district_id').parent().hide();

        }
    });
}
