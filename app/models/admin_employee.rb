class AdminEmployee < User
  searchkick word_start: [:first_name, :last_name, :email]
  belongs_to :company

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email
    }
  end
end
