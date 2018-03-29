function toggleHideableFields() {
    if ($('#onboarding_form_environment_access_production-access-request').is(':checked')) {
        $('.stub-api-details').hide().find('input').removeAttr('required').val('');
    }
    if ($('#onboarding_form_environment_access_integration-access-request').is(':checked')) {
        $('.stub-api-details').show().find('input').attr('required', true);
    }
}
$('[name="onboarding_form\[environment_access\]"]').change(toggleHideableFields)
toggleHideableFields()
