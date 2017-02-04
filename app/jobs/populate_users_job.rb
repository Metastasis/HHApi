class PopulateUsersJob
  include SuckerPunch::Job
  include HeadhunterHelper

  def perform(token, users)
    populateUsers(token, users)
  end
end
