class TransformUserAccountAttributes

  def get_array(onboarding_form)
    {
        user_account_first_name: ['FIRST_NAME', 'FIRST_NAME_VERIFIED'],
        user_account_middle_name: ['MIDDLE_NAME', 'MIDDLE_NAME_VERIFIED'],
        user_account_surname: ['SURNAME', 'SURNAME_VERIFIED'],
        user_account_dob: ['DATE_OF_BIRTH', 'DATE_OF_BIRTH_VERIFIED'],
        user_account_current_address: ['CURRENT_ADDRESS', 'CURRENT_ADDRESS_VERIFIED'],
        user_account_address_history: ['ADDRESS_HISTORY'],
        user_account_cycle_3: ['CYCLE_3']
    }.collect { |attribute_name, attr|
      onboarding_form.send(attribute_name) != '0' ? attr : []
    }.flatten
  end

end
