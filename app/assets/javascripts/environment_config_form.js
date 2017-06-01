function toggleHideableFields() {
    if ($('#onboarding_form_environment_access_production-access-request').is(':checked')) {
        $('.stub-api-details').hide().find('input').removeAttr('required').val('');
        $('#testing_devices_ips').val('').removeAttr('required').parent().hide()
    }
    if ($('#onboarding_form_environment_access_integration-access-request').is(':checked')) {
        $('.stub-api-details').show().find('input').attr('required', true);
        $('#testing_devices_ips').attr('required', true).parent().show()
    }
}
$('[name="onboarding_form\[environment_access\]"]').change(toggleHideableFields)
toggleHideableFields()
